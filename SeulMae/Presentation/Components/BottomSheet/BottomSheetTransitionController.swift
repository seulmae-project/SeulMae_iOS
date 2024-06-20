//
//  BottomSheetTransitionController.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import UIKit

class BottomSheetTransitionController: NSObject {
    
    weak var trackingScrollView: UIScrollView?
    
    var dismissOnBackgroundTap: Bool = true
    
    var dismissOnDraggingDownSheet: Bool = true
    
    var preferredSheetHeight: CGFloat = 0
    
    var adjustHeightForSafeAreaInsets: Bool = true
    
    var ignoreKeyboardHeight: Bool = false
    
    weak var delegate: BottomSheetTransitionControllerDelegate?
    
    private var currentPresentationController: BottomSheetPresentationController?
    
    private let bottomSheetTransitionDuration: TimeInterval = 0.25
    
    // MARK: - Scrim Properties
        
    var scrimColor: UIColor? {
        didSet {
            currentPresentationController?.scrimColor = scrimColor
        }
    }
    
    var isScrimAccessibilityElement: Bool = false {
        didSet {
            currentPresentationController?.isScrimAccessibilityElement = isScrimAccessibilityElement
        }
    }
    
    var scrimAccessibilityLabel: String? {
        didSet {
            currentPresentationController?.scrimAccessibilityLabel = scrimAccessibilityHint
        }
    }
    
    var scrimAccessibilityHint: String? {
        didSet {
            currentPresentationController?.scrimAccessibilityHint = scrimAccessibilityHint
        }
    }
    
    var scrimAccessibilityTraits: UIAccessibilityTraits = .button {
        didSet {
            currentPresentationController?.scrimAccessibilityTraits = scrimAccessibilityTraits
        }
    }
}

extension BottomSheetTransitionController: UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.trackingScrollView = trackingScrollView
        presentationController.dismissOnBackgroundTap = dismissOnBackgroundTap
        presentationController.dismissOnDraggingDownSheet = dismissOnDraggingDownSheet
        presentationController.scrimColor = scrimColor
        presentationController.scrimAccessibilityTraits = scrimAccessibilityTraits
        presentationController.isScrimAccessibilityElement = isScrimAccessibilityElement
        presentationController.scrimAccessibilityHint = scrimAccessibilityHint
        presentationController.scrimAccessibilityLabel = scrimAccessibilityLabel
        presentationController.preferredSheetHeight = preferredSheetHeight
        presentationController.adjustHeightForSafeAreaInsets = adjustHeightForSafeAreaInsets
        presentationController.ignoreKeyboardHeight = ignoreKeyboardHeight
        currentPresentationController = presentationController
        return presentationController
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return bottomSheetTransitionDuration
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let toPresentingViewController = toViewController.presentingViewController
        let presenting = (toPresentingViewController == fromViewController)
        
        let animatingViewController = presenting ? toViewController : fromViewController
        let animatingView = presenting ? toView : fromView
        
        let containerView = transitionContext.containerView
        
        if presenting {
            containerView.addSubview(toView)
        }
        
        let onscreenFrame = frameOfPresentedViewController(animatingViewController, in: containerView)
        let offscreenFrame = onscreenFrame.offsetBy(dx: 0, dy: containerView.frame.size.height)
        
        let initialFrame = presenting ? offscreenFrame : onscreenFrame
        let finalFrame = presenting ? onscreenFrame : offscreenFrame
        
        animatingView.frame = initialFrame
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0.0,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
            animatingView.frame = finalFrame
        }) { (finished) in
            if !presenting {
                fromView.removeFromSuperview()
                self.delegate?.didDismissBottomSheetTransitionController?(self)
            }
            transitionContext.completeTransition(true)
        }
    }
    
    
    func frameOfPresentedViewController(
        _ presentedViewController: UIViewController,
        in containerView: UIView
    ) -> CGRect {
        let containerSize = containerView.frame.size
        let preferredSize = presentedViewController.preferredContentSize
        
        if preferredSize.width > 0 &&
            preferredSize.width < containerSize.width {
            let width = preferredSize.width
            let leftPad = (containerSize.width - width) / 2
            return CGRect(x: leftPad, y: 0, width: width, height: containerSize.height)
        } else {
            return containerView.bounds
        }
    }
}

