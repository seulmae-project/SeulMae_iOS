//
//  BottomSheetAnimationTransition.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import UIKit

class BottomSheetAnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let bottomSheetTransitionDuration: TimeInterval = 0.25

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        bottomSheetTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let fromView = transitionContext.view(forKey: .from) ?? fromViewController.view,
              let toViewController = transitionContext.viewController(forKey: .to),
              let toView = transitionContext.view(forKey: .to) ?? toViewController.view else {
            transitionContext.completeTransition(false)
            return
        }
        
        let toPresentingViewController = toViewController.presentingViewController
        let isPresenting = (toPresentingViewController == fromViewController)

        // let animatingViewController = isPresenting ? toViewController : fromViewController
        let animatingView = isPresenting ? toView : fromView
        let containerView = transitionContext.containerView
        
        if isPresenting {
            containerView.addSubview(toView)
        }

        let onscreenFrame = containerView.bounds
        let offscreenFrame = onscreenFrame.offsetBy(dx: 0, dy: containerView.frame.size.height)
         // (0.0, 852.0, 393.0, 852.0)
        // (0.0, 0.0, 393.0, 852.0)
        
        let initialFrame = isPresenting ? offscreenFrame : onscreenFrame
        print("initialFrame: \(initialFrame)") // (0.0, 852.0, 393.0, 852.0)
        let finalFrame = isPresenting ? onscreenFrame : offscreenFrame
        print("finalFrame: \(finalFrame)") // (0.0, 0.0, 393.0, 852.0)
        animatingView.frame = initialFrame
        
        // animatingView.backgroundColor = .blue.withAlphaComponent(0.5)
        // animatingView == containerView.presntedView =  sheet content view
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0.0,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
            animatingView.frame = finalFrame
        }) { (finished) in
            if !isPresenting {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        }
    }
}

