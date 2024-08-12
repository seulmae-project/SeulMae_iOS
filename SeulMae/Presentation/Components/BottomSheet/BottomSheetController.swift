//
//  BottomSheetController.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit

class BottomSheetController: UIViewController {
    
    /// The view controller being presented as a bottom sheet.
    private(set) var contentViewController: UIViewController
    
    var shouldFlashScrollIndicatorsOnAppearance: Bool = false
    
    var traitCollectionDidChangeBlock: ((BottomSheetController, UITraitCollection?) -> Void)?
    
    weak var delegate: BottomSheetControllerDelegate?
        
    private var kElevationSpreadMaskAffordance: CGFloat = 50.0
    
    private(set) var state: SheetState
    
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

    init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        self.transitionController = BottomSheetTransitionController()
        self.state = UIAccessibility.isVoiceOverRunning ? .extended : .preferred
        super.init(nibName: nil, bundle: nil)
        super.transitioningDelegate = transitionController
        super.modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.preservesSuperviewLayoutMargins = true
        contentViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentViewController.view.frame = view.bounds
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bottomSheetPresentationController?.delegate = self
        bottomSheetPresentationController?.dismissOnBackgroundTap = transitionController.dismissOnBackgroundTap
        bottomSheetPresentationController?.dismissOnDraggingDownSheet = transitionController.dismissOnDraggingDownSheet
        
        Swift.print("view.bounds: \(view.bounds)")
        contentViewController.view.frame = view.bounds
        contentViewController.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldFlashScrollIndicatorsOnAppearance {
            trackingScrollView?.flashScrollIndicators()
        }
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
        guard self.dismissOnBackgroundTap else {
            return false
        }
        
        self.dismiss(animated: true) { [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?
                    .bottomSheetControllerDidDismissBottomSheet(strongSelf)
            }
        }
        return true
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        self.presentationController?.preferredContentSizeDidChange(forChildContentContainer: self)
    }
}

extension BottomSheetController: BottomSheetPresentationControllerDelegate {
    
    // MARK: - BottomSheetPresentationControllerDelegate
    
    func bottomSheetPresentationControllerDidDismissBottomSheet(_ bottomSheet: BottomSheetPresentationController) {
        delegate?.bottomSheetControllerDidDismissBottomSheet(self)
    }
    
    func bottomSheetWillChangeState(_ bottomSheet: BottomSheetPresentationController, sheetState: SheetState) {
        state = sheetState
        delegate?.bottomSheetControllerStateChanged(self, state: sheetState)
    }
    
    func bottomSheetDidChangeYOffset(_ bottomSheet: BottomSheetPresentationController, yOffset: CGFloat) {
        delegate?.bottomSheetControllerDidChangeYOffset(self, yOffset: yOffset)
    }
}
