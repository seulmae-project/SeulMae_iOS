//
//  BottomSheetPresentationController.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit
import WebKit

class BottomSheetPresentationController: UIPresentationController {
    
    // MARK: - UI Properties
    
    private var sheetView: SheetContainerView?
    private var dimmingView: UIView?
    weak var trackingScrollView: UIScrollView?

    // MARK: - Properties
   
    private var shouldPropagateSafeAreaInsets: Bool = false
    var simulateScrollViewBounce: Bool = true
    var dismissOnBackgroundTap: Bool = true
    var dismissOnDraggingDownSheet: Bool = true
    var preferredSheetHeight: CGFloat = 0

    // MARK: - Life Cycle Methods
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var presentedView: UIView? {
        return sheetView
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.sheetView?.frame = self.frameOfPresentedViewInContainerView
            self.sheetView?.layoutIfNeeded()
            self.updatePreferredSheetHeight()
        }, completion: nil)
    }
    
    // MARK: - Presentation Transition
    
    override func presentationTransitionWillBegin() {
        guard let containerView else { return }
        
        if shouldPropagateSafeAreaInsets {
            presentedViewController.additionalSafeAreaInsets = presentingViewController.view.safeAreaInsets
        }
        
        dimmingView = UIView(frame: containerView.bounds)
        dimmingView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimmingView?.translatesAutoresizingMaskIntoConstraints = false
        dimmingView?.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        sheetView = SheetContainerView(
            frame: frameOfPresentedViewInContainerView,
            contentView: presentedViewController.view,
            scrollView: trackingScrollView,
            simulateScrollViewBounce: simulateScrollViewBounce)
        sheetView?.autoresizingMask = .flexibleHeight
                
        containerView.addSubview(dimmingView!)
        containerView.addSubview(sheetView!)
        
        updatePreferredSheetHeight()
        
        // Add tap handler to dismiss the sheet.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPresentedControllerIfNecessary(_:)))
        tapGesture.cancelsTouchesInView = false
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tapGesture)
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
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
    
    // MARK: - Dismissal Transition
    
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
    
    // MARK: - Private Methods
    
    private func updatePreferredSheetHeight() {
        var _preferredSheetHeight: CGFloat = preferredSheetHeight
        if (preferredSheetHeight < 0) {
            _preferredSheetHeight = self.presentedViewController.preferredContentSize.height;
         }
        
        if (_preferredSheetHeight == 0) {
            _preferredSheetHeight = round((sheetView?.frame.height ?? 0) / 2)
        }
        
        self.sheetView?.preferredSheetHeight = _preferredSheetHeight
    }
    
    @objc private func dismissPresentedControllerIfNecessary(_ tapRecognizer: UITapGestureRecognizer) {
        guard dismissOnBackgroundTap else { return }
        
        // Only dismiss if the tap is outside of the presented view.
        guard let contentView = presentedViewController.view else {
            return
        }
        
        let pointInContentView = tapRecognizer.location(in: contentView)
        if contentView.point(inside: pointInContentView, with: nil) {
            return
        }
        
        sheetView?.willBeDismissed = true
        presentingViewController.dismiss(animated: true)
    }
}
