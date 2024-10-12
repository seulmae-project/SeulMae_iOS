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
    
    weak var trackingScrollView: UIScrollView?
    
    var simulateScrollViewBounce: Bool = true
    
    var dismissOnBackgroundTap: Bool = true
    
    var dismissOnDraggingDownSheet: Bool = true
    
    var preferredSheetHeight: CGFloat = 0
    
    // MARK: - Life Cycle Methods

    init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
        super.transitioningDelegate = self
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
        
        contentViewController.view.frame = view.bounds
        contentViewController.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        trackingScrollView?.flashScrollIndicators()
    }
}

extension BottomSheetController: UIViewControllerTransitioningDelegate {
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.trackingScrollView = trackingScrollView
        presentationController.dismissOnBackgroundTap = dismissOnBackgroundTap
        presentationController.preferredSheetHeight = preferredSheetHeight
     
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetAnimationTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetAnimationTransition()
    }
}
