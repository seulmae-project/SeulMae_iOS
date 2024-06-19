//
//  BottomSheetController.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit

class BottomSheetController: UIViewController, Elevatable, ElevationOverriding, BottomSheetPresentationControllerDelegate {

    private var kElevationSpreadMaskAffordance: CGFloat = 50.0
    
    /// The view controller being presented as a bottom sheet.
    private(set) var contentViewController: UIViewController
    
    /// Interactions with the tracking scroll view will affect the bottom sheet's drag behavior.
    var trackingScrollView: UIScrollView? {
        get {
            return transitionController.trackingScrollView
        }
        set {
            transitionController.trackingScrollView = newValue
        }
    }
    
    /// Determines if showFlashIndicators is called by default when viewDidAppear is called.
    var shouldFlashScrollIndicatorsOnAppearance: Bool = false
    
    /// Controls whether the bottom sheet can be dismissed by tapping outside of sheet area.
    var dismissOnBackgroundTap: Bool {
        return transitionController.dismissOnBackgroundTap
    }
    
    /// Controls whether the bottom sheet can be dismissed by dragging the sheet down.
    var dismissOnDraggingDownSheet: Bool {
        return transitionController.dismissOnDraggingDownSheet
    }
    
    /// Controls whether the height of the keyboard should affect the bottom sheet's frame.
    var ignoreKeyboardHeight: Bool {
        get {
            return transitionController.ignoreKeyboardHeight
        }
        set {
            transitionController.ignoreKeyboardHeight = newValue
            self.mdc_bottomSheetPresentationController?.ignoreKeyboardHeight = newValue
        }
    }
    
    /// The color applied to the sheet's background.
    var scrimColor: UIColor?
    
    /// If true, the dimmed scrim view will act as an accessibility element for dismissing the bottom sheet.
    var isScrimAccessibilityElement: Bool = false
    
    /// The accessibility label of the dimmed scrim view.
    var scrimAccessibilityLabel: String?
    
    /// The accessibility hint of the dimmed scrim view.
    var scrimAccessibilityHint: String?
    
    /// The accessibility traits of the dimmed scrim view.
    var scrimAccessibilityTraits: UIAccessibilityTraits = .button
    
    /// The bottom sheet delegate.
    weak var delegate: BottomSheetControllerDelegate?
    
    private let transitionController = BottomSheetTransitionController()
    private var shapeGenerators = [NSNumber: ShapeGenerating]()
    var overrideBaseElevation: CGFloat = -1
    var elevationDidChangeBlock: ((any Elevatable, CGFloat) -> Void)?
    
    /// The current state of the bottom sheet.
    private(set) var state: SheetState
    
    /// The elevation of the bottom sheet.
    var elevation: ShadowElevation {
        didSet {
            guard elevation.wrappedValue != self.elevation.wrappedValue else { return }
            self.customView.elevation = elevation.wrappedValue
            self.customView.mdc_elevationDidChange()
        }
    }
    
    func setElevation(_ elevation: ShadowElevation) {
    }
    
    /// Determines if the height of the bottom sheet should adjust for safe area insets.
    var adjustHeightForSafeAreaInsets: Bool = true
    
    
    private(set) var customView: ShapedView {
        get {
            return self.view as! ShapedView
        }
        set {
            self.view = newValue
        }
    }
    
    override func loadView() {
        self.customView = ShapedView(frame: .zero)
        self.customView.elevation = self.elevation.wrappedValue
    }
    
    /// Initializes the controller with a content view controller.
    init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        if UIAccessibility.isVoiceOverRunning {
            self.state = .extended
        } else {
            self.state = .preferred
        }
        self.elevation = ShadowElevation(wrappedValue: ShadowElevations.modalBottomSheet)
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.transitionController.dismissOnBackgroundTap = true
        self.transitionController.dismissOnDraggingDownSheet = true
        self.transitionController.adjustHeightForSafeAreaInsets = true
        self.transitioningDelegate = transitionController
        self.modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customView.preservesSuperviewLayoutMargins = true
        
        contentViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentViewController.view.frame = self.customView.bounds
        self.addChild(contentViewController)
        self.customView.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.mdc_bottomSheetPresentationController?.delegate = self
        
        self.mdc_bottomSheetPresentationController?.dismissOnBackgroundTap = transitionController.dismissOnBackgroundTap
        self.mdc_bottomSheetPresentationController?.dismissOnDraggingDownSheet = transitionController.dismissOnDraggingDownSheet
        
        self.contentViewController.view.frame = self.view.bounds
        self.contentViewController.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.shouldFlashScrollIndicatorsOnAppearance {
            self.trackingScrollView?.flashScrollIndicators()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.layer.mask = self.createBottomEdgeElevationMask()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.contentViewController.supportedInterfaceOrientations
    }
    
    override func accessibilityPerformEscape() -> Bool {
        if !self.dismissOnBackgroundTap {
            return false
        }
        
        weak var weakSelf = self
        self.dismiss(animated: true) {
            guard let strongSelf = weakSelf else { return }
            if let delegate = strongSelf.delegate as AnyObject?,
               delegate.responds(to: #selector(BottomSheetControllerDelegate.bottomSheetControllerDidDismissBottomSheet(_:))) {
                delegate.bottomSheetControllerDidDismissBottomSheet(strongSelf)
            }
        }
        return true
    }
    
    override var preferredContentSize: CGSize {
        get {
            return self.contentViewController.preferredContentSize ?? CGSize.zero
        }
        set {
            self.contentViewController.preferredContentSize = newValue
        }
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        self.presentationController?.preferredContentSizeDidChange(forChildContentContainer: self)
    }

    func bottomSheetWillChangeState(_ bottomSheet: BottomSheetPresentationController, sheetState: SheetState) {
        state = sheetState
        updateShapeGenerator()
        delegate?.bottomSheetControllerStateChanged(self, state: sheetState)
    }
    
    func bottomSheetDidChangeYOffset(_ bottomSheet: BottomSheetPresentationController, yOffset: CGFloat) {
        delegate?.bottomSheetControllerDidChangeYOffset(self, yOffset: yOffset)
    }
    
    func shapeGeneratorForState(_ state: SheetState) -> ShapeGenerating? {
        var shapeGenerator = shapeGenerators[state.rawValue as NSNumber]
        if state != .closed && shapeGenerator == nil {
            shapeGenerator = shapeGenerators[SheetState.closed.rawValue as NSNumber]
        }
        return shapeGenerator
    }
    
    func setShapeGenerator(_ shapeGenerator: ShapeGenerating?, forState state: SheetState) {
        shapeGenerators[state.rawValue as NSNumber] = shapeGenerator
        updateShapeGenerator()
    }
    
    func updateShapeGenerator() {
        guard let shapeGenerator = shapeGeneratorForState(state) else { return }
        if self.customView.shapeGenerator !== shapeGenerator {
            self.customView.shapeGenerator = shapeGenerator
            if let shapeLayer = (self.view.layer as? ShapedShadowLayer)?.shapeLayer {
                self.contentViewController.view.layer.mask = shapeLayer
            } else {
                self.contentViewController.view.layer.mask = nil
            }
        }
    }
    
    var currentElevation: CGFloat {
        return elevation.wrappedValue
    }
    
    func createBottomEdgeElevationMask() -> CAShapeLayer {
        let boundsWidth = self.view.bounds.width
        let boundsHeight = self.view.bounds.height
        let visibleRectOutsideBounds = CGRect(x: 0 - kElevationSpreadMaskAffordance,
                                              y: 0 - kElevationSpreadMaskAffordance,
                                              width: boundsWidth + (2.0 * kElevationSpreadMaskAffordance),
                                              height: boundsHeight + kElevationSpreadMaskAffordance)
        let maskLayer = CAShapeLayer()
        let visibleAreaPath = UIBezierPath(rect: visibleRectOutsideBounds)
        maskLayer.path = visibleAreaPath.cgPath
        return maskLayer
    }

    func shapeGenerator(forState state: SheetState) -> ShapeGenerating? {
        // Implementation here
        return nil
    }
    
    /// A block that is invoked when traitCollectionDidChange is called.
    @objc var traitCollectionDidChangeBlock: ((BottomSheetController, UITraitCollection?) -> Void)?
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollectionDidChangeBlock?(self, previousTraitCollection)
    }
    
    func bottomSheetPresentationControllerDidDismissBottomSheet(_ bottomSheet: BottomSheetPresentationController) {
        if let delegate = self.delegate as AnyObject?,
           delegate.responds(to: #selector(BottomSheetControllerDelegate.bottomSheetControllerDidDismissBottomSheet(_:))) {
            delegate.bottomSheetControllerDidDismissBottomSheet?(self)
        }
    }
}
