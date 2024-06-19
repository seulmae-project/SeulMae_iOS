//
//  BottomSheetPresentationController.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit
import WebKit

func BottomSheetGetPrimaryScrollView(viewController: UIViewController) -> UIScrollView? {
    var viewController = viewController
    var scrollView: UIScrollView? = nil
    
    if !viewController.isViewLoaded {
        _ = viewController.view
    }
    
    if let bottomSheetController = viewController as? BottomSheetController {
        viewController = bottomSheetController.contentViewController
    }
    
    if let view = viewController.view as? UIScrollView {
        scrollView = view
    } else if let webView = viewController.view as? WKWebView {
        scrollView = webView.scrollView
    } else if let collectionViewController = viewController as? UICollectionViewController {
        scrollView = collectionViewController.collectionView
    }
    return scrollView
}


class BottomSheetPresentationController: UIPresentationController, SheetContainerViewDelegate {
    
    private var sheetView: SheetContainerView?
    private var dimmingView: UIView?
    
    weak var trackingScrollView: UIScrollView?
    var simulateScrollViewBounce: Bool = true
    var dismissOnBackgroundTap: Bool = true
    var shouldPropagateSafeAreaInsetsToPresentedViewController: Bool = false
    
    // MARK: - Properties
    
    var scrimColor: UIColor? {
        didSet {
            dimmingView?.backgroundColor = scrimColor
        }
    }
    
    var isScrimAccessibilityElement: Bool = false {
        didSet {
            dimmingView?.isAccessibilityElement = isScrimAccessibilityElement
        }
    }
    
    var scrimAccessibilityLabel: String? {
        didSet {
            dimmingView?.accessibilityLabel = scrimAccessibilityLabel
        }
    }
    
    var scrimAccessibilityHint: String? {
        didSet {
            dimmingView?.accessibilityHint = scrimAccessibilityHint
        }
    }
    
    var scrimAccessibilityTraits: UIAccessibilityTraits = [] {
        didSet {
            dimmingView?.accessibilityTraits = scrimAccessibilityTraits
        }
    }
    
    var preferredSheetHeight: CGFloat = 0 {
        didSet {
            updatePreferredSheetHeight()
        }
    }
    
    var adjustHeightForSafeAreaInsets: Bool = true {
        didSet {
            sheetView?.adjustHeightForSafeAreaInsets = adjustHeightForSafeAreaInsets
        }
    }
    
    var ignoreKeyboardHeight: Bool = false {
        didSet {
            sheetView?.ignoreKeyboardHeight = ignoreKeyboardHeight
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollectionDidChangeBlock?(self, previousTraitCollection)
    }
    
    var dismissOnDraggingDownSheet: Bool = true {
        didSet {
            sheetView?.dismissOnDraggingDownSheet = dismissOnDraggingDownSheet
        }
    }
    
    var traitCollectionDidChangeBlock: ((BottomSheetPresentationController, UITraitCollection?) -> Void)?
        
    override init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?
    ) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var presentedView: UIView? {
        return sheetView
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        let containerSize = containerView.frame.size
        let preferredSize = presentedViewController.preferredContentSize
        
        if preferredSize.width > 0 && preferredSize.width < containerSize.width {
            // We only customize the width and not the height here. MDCSheetContainerView lays out the
            // presentedView taking the preferred height into account.
            let width = preferredSize.width
            let leftPad = (containerSize.width - width) / 2
            return CGRect(x: leftPad, y: 0, width: width, height: containerSize.height)
        } else {
            return super.frameOfPresentedViewInContainerView
        }
    }
    
    override func presentationTransitionWillBegin() {
        if let strongDelegate = delegate as? BottomSheetPresentationControllerDelegate {
            strongDelegate.prepareForBottomSheetPresentation?(self)
        }
        
        guard let containerView = self.containerView else { return }
        
        dimmingView = UIView(frame: containerView.bounds)
        dimmingView?.backgroundColor = scrimColor ?? UIColor(white: 0, alpha: 0.4)
        dimmingView?.translatesAutoresizingMaskIntoConstraints = false
        dimmingView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimmingView?.accessibilityTraits.insert(.button)
        dimmingView?.isAccessibilityElement = isScrimAccessibilityElement
        dimmingView?.accessibilityTraits = scrimAccessibilityTraits
        dimmingView?.accessibilityLabel = scrimAccessibilityLabel
        dimmingView?.accessibilityHint = scrimAccessibilityHint
        
        let scrollView = trackingScrollView ?? BottomSheetGetPrimaryScrollView(viewController: presentedViewController)
        let sheetFrame = frameOfPresentedViewInContainerView
        if shouldPropagateSafeAreaInsetsToPresentedViewController {
            presentedViewController.additionalSafeAreaInsets = presentingViewController.view.safeAreaInsets
        }
        sheetView = SheetContainerView(frame: sheetFrame, contentView: presentedViewController.view, scrollView: scrollView!, simulateScrollViewBounce: simulateScrollViewBounce)
        sheetView?.delegate = self
        sheetView?.autoresizingMask = .flexibleHeight
        sheetView?.dismissOnDraggingDownSheet = dismissOnDraggingDownSheet
        sheetView?.adjustHeightForSafeAreaInsets = adjustHeightForSafeAreaInsets
        sheetView?.ignoreKeyboardHeight = ignoreKeyboardHeight
        
        containerView.addSubview(dimmingView!)
        containerView.addSubview(sheetView!)
        
        updatePreferredSheetHeight()
        
        // Add tap handler to dismiss the sheet.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPresentedControllerIfNecessary(_:)))
        tapGesture.cancelsTouchesInView = false
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tapGesture)
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            // Fade in the dimming view during the transition.
            dimmingView?.alpha = 0.0
            transitionCoordinator.animate(alongsideTransition: { _ in
                self.dimmingView?.alpha = 1.0
            }, completion: nil)
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView?.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                self.dimmingView?.alpha = 0.0
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView?.removeFromSuperview()
        }
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        sheetView?.frame = frameOfPresentedViewInContainerView
        sheetView?.layoutIfNeeded()
        updatePreferredSheetHeight()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.sheetView?.frame = self.frameOfPresentedViewInContainerView
            self.sheetView?.layoutIfNeeded()
            self.updatePreferredSheetHeight()
        }, completion: nil)
    }
    
    func updatePreferredSheetHeight() {
        // If |preferredSheetHeight| has not been specified, use half of the current height.
        var preferredSheetHeight: CGFloat
        if self.preferredSheetHeight > 0 {
            preferredSheetHeight = self.preferredSheetHeight
        } else {
            preferredSheetHeight = self.presentedViewController.preferredContentSize.height
        }
        
        if preferredSheetHeight == 0 {
            preferredSheetHeight = round((self.sheetView?.frame.height ?? .zero) / 2)
        }
        self.sheetView?.preferredSheetHeight = preferredSheetHeight
    }
    
    @objc func dismissPresentedControllerIfNecessary(_ tapRecognizer: UITapGestureRecognizer) {
        if !dismissOnBackgroundTap {
            return
        }
        // Only dismiss if the tap is outside of the presented view.
        guard let contentView = presentedViewController.view else { return }
        let pointInContentView = tapRecognizer.location(in: contentView)
        if contentView.point(inside: pointInContentView, with: nil) {
            return
        }
        
        sheetView?.willBeDismissed = true
        if let strongDelegate = delegate as? BottomSheetPresentationControllerDelegate {
            presentingViewController.dismiss(animated: true) {
                if strongDelegate.responds(to: #selector(BottomSheetPresentationControllerDelegate.bottomSheetPresentationControllerDismissalAnimationCompleted(_:))) {
                    strongDelegate.bottomSheetPresentationControllerDismissalAnimationCompleted?(self)
                }
            }
            
            if strongDelegate.responds(to: #selector(BottomSheetPresentationControllerDelegate.bottomSheetPresentationControllerDidDismissBottomSheet(_:))) {
                strongDelegate.bottomSheetPresentationControllerDidDismissBottomSheet?(self)
            }
        }
    }
    
    // MARK: - MDCSheetContainerViewDelegate

    func sheetContainerViewDidHide(_ containerView: SheetContainerView) {
        guard let strongDelegate = delegate as? BottomSheetPresentationControllerDelegate else { return }
        presentingViewController.dismiss(animated: true) {
            if strongDelegate.responds(to: #selector(BottomSheetPresentationControllerDelegate.bottomSheetPresentationControllerDismissalAnimationCompleted(_:))) {
                strongDelegate.bottomSheetPresentationControllerDismissalAnimationCompleted?(self)
            }
        }

        if strongDelegate.responds(to: #selector(BottomSheetPresentationControllerDelegate.bottomSheetPresentationControllerDidDismissBottomSheet(_:))) {
            strongDelegate.bottomSheetPresentationControllerDidDismissBottomSheet?(self)
        }
    }

    func sheetContainerViewWillChangeState(_ containerView: SheetContainerView, sheetState: SheetState) {
        guard let strongDelegate = delegate as? BottomSheetPresentationControllerDelegate else { return }
        if strongDelegate.responds(to: #selector(BottomSheetPresentationControllerDelegate.bottomSheetWillChangeState(_:sheetState:))) {
            strongDelegate.bottomSheetWillChangeState?(self, sheetState: sheetState)
        }
    }

    func sheetContainerViewDidChangeYOffset(_ containerView: SheetContainerView, yOffset: CGFloat) {
        guard let strongDelegate = delegate as? BottomSheetPresentationControllerDelegate else { return }
        if strongDelegate.responds(to: #selector(BottomSheetPresentationControllerDelegate.bottomSheetDidChangeYOffset(_:yOffset:))) {
            strongDelegate.bottomSheetDidChangeYOffset?(self, yOffset: yOffset)
        }
    }
}
