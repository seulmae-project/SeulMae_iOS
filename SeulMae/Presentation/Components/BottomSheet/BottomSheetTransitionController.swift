//
//  BottomSheetTransitionController.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import UIKit

private let MDCBottomSheetTransitionDuration: TimeInterval = 0.25

class BottomSheetTransitionController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    weak var trackingScrollView: UIScrollView?
    
    var dismissOnBackgroundTap: Bool = true
    
    var dismissOnDraggingDownSheet: Bool = true
    
    var preferredSheetHeight: CGFloat = 0
    
    var adjustHeightForSafeAreaInsets: Bool = true
    
    var ignoreKeyboardHeight: Bool = false
    
    weak var delegate: BottomSheetTransitionControllerDelegate?
    
    private var currentPresentationController: BottomSheetPresentationController?
    
    // MARK: - Scrim Properties
    
    private var _scrimColor: UIColor?
    
    private var _isScrimAccessibilityElement = false
    
    private var _scrimAccessibilityLabel: String?
    
    private var _scrimAccessibilityHint: String?
    
    private var _scrimAccessibilityTraits: UIAccessibilityTraits = .button
    
    var scrimColor: UIColor? {
        get { return _scrimColor }
        set {
            _scrimColor = newValue
            currentPresentationController?.scrimColor = newValue
        }
    }
    
    var isScrimAccessibilityElement: Bool {
        get { return _isScrimAccessibilityElement }
        set {
            _isScrimAccessibilityElement = newValue
            currentPresentationController?.isScrimAccessibilityElement = newValue
        }
    }
    
    var scrimAccessibilityLabel: String? {
        get { return _scrimAccessibilityLabel }
        set {
            _scrimAccessibilityLabel = newValue
            currentPresentationController?.scrimAccessibilityLabel = newValue
        }
    }
    
    var scrimAccessibilityHint: String? {
        get { return _scrimAccessibilityHint }
        set {
            _scrimAccessibilityHint = newValue
            currentPresentationController?.scrimAccessibilityHint = newValue
        }
    }
    
    var scrimAccessibilityTraits: UIAccessibilityTraits {
        get { return _scrimAccessibilityTraits }
        set {
            _scrimAccessibilityTraits = newValue
            currentPresentationController?.scrimAccessibilityTraits = newValue
        }
    }
}

extension BottomSheetTransitionController {
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.trackingScrollView = trackingScrollView
        presentationController.dismissOnBackgroundTap = dismissOnBackgroundTap
        presentationController.dismissOnDraggingDownSheet = dismissOnDraggingDownSheet
        presentationController.scrimColor = _scrimColor
        presentationController.scrimAccessibilityTraits = _scrimAccessibilityTraits
        presentationController.isScrimAccessibilityElement = _isScrimAccessibilityElement
        presentationController.scrimAccessibilityHint = _scrimAccessibilityHint
        presentationController.scrimAccessibilityLabel = _scrimAccessibilityLabel
        presentationController.preferredSheetHeight = preferredSheetHeight
        presentationController.adjustHeightForSafeAreaInsets = adjustHeightForSafeAreaInsets
        presentationController.ignoreKeyboardHeight = ignoreKeyboardHeight
        currentPresentationController = presentationController
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return MDCBottomSheetTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        let toPresentingViewController = toViewController.presentingViewController
        let presenting = (toPresentingViewController == fromViewController)
        
        let animatingViewController = presenting ? toViewController : fromViewController
        let animatingView = presenting ? toView : fromView
        
        let containerView = transitionContext.containerView
//            transitionContext.completeTransition(false)
//            return
        
        if presenting {
            containerView.addSubview(toView!)
        }
        
        let onscreenFrame = frameOfPresentedViewController(animatingViewController, in: containerView)
        let offscreenFrame = onscreenFrame.offsetBy(dx: 0, dy: containerView.frame.size.height)
        
        let initialFrame = presenting ? offscreenFrame : onscreenFrame
        let finalFrame = presenting ? onscreenFrame : offscreenFrame
        
        animatingView?.frame = initialFrame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            animatingView?.frame = finalFrame
        }) { (finished) in
            if !presenting {
                fromView?.removeFromSuperview()
                self.delegate?.didDismissBottomSheetTransitionController?(self)
            }
            transitionContext.completeTransition(true)
        }
    }
    
    func frameOfPresentedViewController(_ presentedViewController: UIViewController, in containerView: UIView) -> CGRect {
        let containerSize = containerView.frame.size
        let preferredSize = presentedViewController.preferredContentSize
        
        if preferredSize.width > 0 && preferredSize.width < containerSize.width {
            let width = preferredSize.width
            let leftPad = (containerSize.width - width) / 2
            return CGRect(x: leftPad, y: 0, width: width, height: containerSize.height)
        } else {
            return containerView.bounds
        }
    }
}

