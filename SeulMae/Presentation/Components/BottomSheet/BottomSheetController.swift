//
//  BottomSheetController.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit

class BottomSheetController: UIViewController, Elevatable, ElevationOverriding {
    
    /// The view controller being presented as a bottom sheet.
    private(set) var contentViewController: UIViewController
    
    var shouldFlashScrollIndicatorsOnAppearance: Bool = false
    
    var traitCollectionDidChangeBlock: ((BottomSheetController, UITraitCollection?) -> Void)?
    
    weak var delegate: BottomSheetControllerDelegate?
    
    @ShadowElevation
    var currentElevation: CGFloat {
        didSet {
            guard currentElevation != currentElevation else { return }
            _view.elevation = currentElevation
            _view.mdc_elevationDidChange()
        }
    }
    
    var elevationDidChangeBlock: ((any Elevatable, CGFloat) -> Void)?
    
    var overrideBaseElevation: CGFloat = -1
    
    private var kElevationSpreadMaskAffordance: CGFloat = 50.0
    
    private(set) var state: SheetState
    
    private(set) var _view: ShapedView {
        get {
            return self.view as! ShapedView
        }
        set {
            self.view = newValue
        }
    }
    
    private var shapeGenerators = [SheetState: ShapeGenerating]() {
        didSet {
            updateShapeGenerator()
        }
    }
    
    // MARK: - TransitionController Properties
    
    private let transitionController: BottomSheetTransitionController
    
    lazy var trackingScrollView: UIScrollView? = transitionController.trackingScrollView
    
    lazy var adjustHeightForSafeAreaInsets: Bool = transitionController.adjustHeightForSafeAreaInsets
    
    lazy var dismissOnBackgroundTap: Bool = transitionController.dismissOnBackgroundTap {
        didSet {
            bottomSheetPresentationController?.dismissOnBackgroundTap = dismissOnBackgroundTap
        }
    }
    
    lazy var dismissOnDraggingDownSheet: Bool = transitionController.dismissOnDraggingDownSheet {
        didSet {
            bottomSheetPresentationController?.dismissOnDraggingDownSheet = dismissOnDraggingDownSheet
        }
    }
    
    lazy var ignoreKeyboardHeight: Bool = transitionController.ignoreKeyboardHeight {
        didSet {
            bottomSheetPresentationController?.ignoreKeyboardHeight = ignoreKeyboardHeight
        }
    }
    
    // MARK: - Scrim Properties
    
    /// The color applied to the sheet's background.
    var scrimColor: UIColor? {
        didSet {
            transitionController.scrimColor = scrimColor
        }
    }
    
    /// If true, the dimmed scrim view will act as an accessibility element for dismissing the bottom sheet.
    var isScrimAccessibilityElement: Bool = false {
        didSet {
            transitionController.isScrimAccessibilityElement = isScrimAccessibilityElement
        }
    }
    
    /// The accessibility label of the dimmed scrim view.
    var scrimAccessibilityLabel: String? {
        didSet {
            transitionController.scrimAccessibilityLabel = scrimAccessibilityLabel
        }
    }
    
    /// The accessibility hint of the dimmed scrim view.
    var scrimAccessibilityHint: String? {
        didSet {
            transitionController.scrimAccessibilityHint = scrimAccessibilityHint
        }
    }
    
    /// The accessibility traits of the dimmed scrim view.
    var scrimAccessibilityTraits: UIAccessibilityTraits = [] {
        didSet {
            transitionController.scrimAccessibilityTraits = scrimAccessibilityTraits
        }
    }
    
    // MARK: - Life Cycle

    /// Initializes the controller with a content view controller.
    init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        self.transitionController = BottomSheetTransitionController()
        self.transitionController.dismissOnBackgroundTap = true
        self.transitionController.dismissOnDraggingDownSheet = true
        self.transitionController.adjustHeightForSafeAreaInsets = true
        self.state = UIAccessibility.isVoiceOverRunning ? .extended : .preferred
        self.currentElevation = ShadowElevations.modalBottomSheet
        super.init(nibName: nil, bundle: nil)
        super.transitioningDelegate = transitionController
        super.modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        _view = ShapedView(frame: .zero)
        _view.elevation = currentElevation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _view.preservesSuperviewLayoutMargins = true
        contentViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentViewController.view.frame = _view.bounds
        addChild(contentViewController)
        _view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bottomSheetPresentationController?.delegate = self
        bottomSheetPresentationController?.dismissOnBackgroundTap = transitionController.dismissOnBackgroundTap
        bottomSheetPresentationController?.dismissOnDraggingDownSheet = transitionController.dismissOnDraggingDownSheet
        
        contentViewController.view.frame = _view.bounds
        contentViewController.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldFlashScrollIndicatorsOnAppearance {
            trackingScrollView?.flashScrollIndicators()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _view.layer.mask = createBottomEdgeElevationMask()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return contentViewController.supportedInterfaceOrientations
    }
    
    override var preferredContentSize: CGSize {
        get {
            return contentViewController.preferredContentSize
        }
        set {
            contentViewController.preferredContentSize = newValue
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollectionDidChangeBlock?(self, previousTraitCollection)
    }
    
    override func accessibilityPerformEscape() -> Bool {
        if !self.dismissOnBackgroundTap {
            return false
        }
        
        self.dismiss(animated: true) { [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?.bottomSheetControllerDidDismissBottomSheet(strongSelf)
            }
        }
        return true
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        self.presentationController?.preferredContentSizeDidChange(forChildContentContainer: self)
    }
    
    // MARK: - Private
    
    func createBottomEdgeElevationMask() -> CAShapeLayer {
        let boundsWidth = _view.bounds.width
        let boundsHeight = _view.bounds.height
        let visibleRectOutsideBounds = CGRect(
            x: 0 - kElevationSpreadMaskAffordance,
            y: 0 - kElevationSpreadMaskAffordance,
            width: boundsWidth + (2.0 * kElevationSpreadMaskAffordance),
            height: boundsHeight + kElevationSpreadMaskAffordance
        )
        let maskLayer = CAShapeLayer()
        let visibleAreaPath = UIBezierPath(rect: visibleRectOutsideBounds)
        maskLayer.path = visibleAreaPath.cgPath
        return maskLayer
    }
    
    private func shapeGeneratorForState(_ state: SheetState) -> ShapeGenerating? {
        var shapeGenerator = shapeGenerators[state]
        if state != .closed && shapeGenerator == nil {
            shapeGenerator = shapeGenerators[.closed]
        }
        return shapeGenerator
    }

    private func updateShapeGenerator() {
        guard let shapeGenerator = shapeGeneratorForState(state) else { return }
        if _view.shapeGenerator !== shapeGenerator {
            _view.shapeGenerator = shapeGenerator
            if let shapeLayer = (_view.layer as? ShapedShadowLayer)?.shapeLayer {
                self.contentViewController.view.layer.mask = shapeLayer
            } else {
                self.contentViewController.view.layer.mask = nil
            }
        }
    }
}

extension BottomSheetController: BottomSheetPresentationControllerDelegate {
    
    // MARK: - BottomSheetPresentationControllerDelegate
    
    func bottomSheetPresentationControllerDidDismissBottomSheet(_ bottomSheet: BottomSheetPresentationController) {
        delegate?.bottomSheetControllerDidDismissBottomSheet(self)
    }
    
    func bottomSheetWillChangeState(_ bottomSheet: BottomSheetPresentationController, sheetState: SheetState) {
        state = sheetState
        updateShapeGenerator()
        delegate?.bottomSheetControllerStateChanged(self, state: sheetState)
    }
    
    func bottomSheetDidChangeYOffset(_ bottomSheet: BottomSheetPresentationController, yOffset: CGFloat) {
        delegate?.bottomSheetControllerDidChangeYOffset(self, yOffset: yOffset)
    }
}
