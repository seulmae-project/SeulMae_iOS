//
//  SheetContainerView.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit

class SheetContainerView: UIView {
     
    // MARK: - Constants
    
    static let kContentSizeKeyPath: String = NSExpression(forKeyPath: \UIScrollView.contentSize).keyPath
    static let kContentInsetKeyPath: String = NSExpression(forKeyPath: \UIScrollView.contentInset).keyPath
    static var kObservingContext = 0
    static let kSheetBounceBuffer: CGFloat = 150
    
    // MARK: - UI Properties
    
    private var sheet: DraggableView
    private var contentView: UIView
    private var detent: UIView
    
    // MARK: - Properties
    
    struct SheetViewProperties {
        var adjustHeightForSafeAreaInsets: Bool = true
        var ignoreKeyboardHeight: Bool = false
        var dismissOnDraggingDownSheet: Bool = true
    }
    
    var properties: SheetViewProperties = SheetViewProperties()
    
    private var originalPreferredSheetHeight: CGFloat = 0
    private var _preferredSheetHeight: CGFloat = 0
    var preferredSheetHeight: CGFloat {
        get { _preferredSheetHeight }
        set { 
            originalPreferredSheetHeight = newValue
            updateSheetHeight()
        }
    }
    
    var willBeDismissed: Bool = false
    
    
    
    private var sheetBehavior: SheetBehavior?
    private var animator: UIDynamicAnimator?
    
    private var isDragging: Bool = false
    private var previousAnimatedBounds: CGRect = .zero
    private var simulateScrollViewBounce: Bool
    
    // MARK: - Initializer Methods
    
    init(
        frame: CGRect,
        contentView: UIView,
        scrollView: UIScrollView?,
        simulateScrollViewBounce: Bool
    ) {
        self.sheet = DraggableView(frame: .zero, scrollView: scrollView)
        self.simulateScrollViewBounce = simulateScrollViewBounce
        self.contentView = contentView
        self.detent = UIView(frame: .zero)
        super.init(frame: frame)
        
        // Configure sheet view
        sheet.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        sheet.backgroundColor = contentView.backgroundColor
        sheet.delegate = self;
        sheet.layer.cornerRadius = 14
        sheet.layer.cornerCurve = .continuous
        sheet.layer.edgeAntialiasingMask  = [.layerTopEdge]
        
        // Adjust anchor point for sheet view
        sheet.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        sheet.frame = bounds
        
        // Configure detent
        detent.backgroundColor = .ext.detent
        detent.layer.cornerRadius = 2.5
        detent.layer.cornerCurve = .continuous
        
        // Configure content view
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add content view to sheet
        sheet.addSubview(contentView)
        sheet.addSubview(detent)
        addSubview(sheet)
        
        animator = UIDynamicAnimator(referenceView: self)
        
        // Add observers for scrollView
        scrollView?.addObserver(
            self,
            forKeyPath: SheetContainerView.kContentSizeKeyPath,
            options: [.new, .old],
            context: &SheetContainerView.kObservingContext
        )
        
        scrollView?.addObserver(
            self,
            forKeyPath: SheetContainerView.kContentInsetKeyPath,
            options: [.new, .old],
            context: &SheetContainerView.kObservingContext
        )
        
        backgroundColor = .red.withAlphaComponent(0.5)
        sheet.backgroundColor = .yellow.withAlphaComponent(0.5)
        contentView.backgroundColor = .green.withAlphaComponent(0.5)
        
        
        // Add keyboard notifications
        //        let notificationNames = [
        //            UIResponder.keyboardWillShowNotification,
        //            UIResponder.keyboardWillHideNotification,
        //            UIResponder.keyboardWillChangeFrameNotification
        //        ]
        //
        //        for name in notificationNames {
        //            NotificationCenter.default
        //                .addObserver(
        //                    self,
        //                    selector: #selector(keyboardStateChanged(with:)),
        //                    name: name,
        //                    object: nil
        //                )
        //        }
        
        // Disable contentInsetAdjustmentBehavior
        scrollView?.contentInsetAdjustmentBehavior = .never
        scrollView?.preservesSuperviewLayoutMargins = true
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) has been disabled. Use init(frame:contentView:scrollView:simulateScrollViewBounce:) instead.")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    deinit {
    //        if let scrollView = sheet.scrollView {
    //            scrollView.removeObserver(
    //                self,
    //                forKeyPath: SheetContainerView.kContentSizeKeyPath,
    //                context: &SheetContainerView.kObservingContext
    //            )
    //
    //            scrollView.removeObserver(
    //                self,
    //                forKeyPath: SheetContainerView.kContentInsetKeyPath,
    //                context: &SheetContainerView.kObservingContext
    //            )
    //        }
    //
    //        let notificationNames = [
    //            UIResponder.keyboardWillShowNotification,
    //            UIResponder.keyboardWillHideNotification,
    //            UIResponder.keyboardWillChangeFrameNotification
    //        ]
    //
    //        for name in notificationNames {
    //            NotificationCenter.default.removeObserver(self, name: name, object: nil)
    //        }
    //    }
    //
    //    override func didMoveToWindow() {
    //        super.didMoveToWindow()
    //        if let _ = window {
    //            if (sheetBehavior == nil) {
    //                sheetBehavior = SheetBehavior(item: sheet, simulateScrollViewBounce: simulateScrollViewBounce)
    //            }
    //            animatePane(withInitialVelocity: .zero)
    //        } else {
    //            animator?.removeAllBehaviors()
    //            sheetBehavior = nil
    //        }
    //    }
    
    // MARK: - KVO
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if context == &SheetContainerView.kObservingContext {
            guard keyPath != nil else { return }
            guard let oldValue = change?[.oldKey] as? NSValue,
                  let newValue = change?[.newKey] as? NSValue else { return }
            
            if window != nil && !isDragging && oldValue != newValue {
                // animatePane(withInitialVelocity: .zero)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !bounds.equalTo(previousAnimatedBounds) && window != nil {
            // animatePane(withInitialVelocity: .zero)
        }
    }
    
    private func updateSheetHeight() {
        var adjustedPreferredSheetHeight = originalPreferredSheetHeight
        if properties.adjustHeightForSafeAreaInsets {
            adjustedPreferredSheetHeight += safeAreaInsets.bottom
        }
        
        if (_preferredSheetHeight == adjustedPreferredSheetHeight) {
            return
        }
        
        _preferredSheetHeight = adjustedPreferredSheetHeight
        updateSheetFrame()
    }
    
    // Slides the sheet position downwards, so the right amount peeks above the bottom of the superview.
    private func updateSheetFrame() {
        // animator?.removeAllBehaviors()
        
        var sheetRect = bounds
        sheetRect.origin.y = bounds.maxY - maximumSheetHeight()
        sheetRect.size.height += SheetContainerView.kSheetBounceBuffer
        // 여기서 sheetRect 의 높이를 설정해줘야함
        sheet.frame = sheetRect
     
        let detentFrame = CGRect(
            x: ((sheet.bounds.width / 2) - (18)),
            y: 6,
            width: 36,
            height: 5)
        detent.frame = detentFrame
        
        var contentFrame = sheet.bounds
        contentFrame.size.height -= SheetContainerView.kSheetBounceBuffer
        if (sheet.scrollView == nil) {
            contentFrame.size.height = maximumSheetHeight()
        }
        
        Swift.print("contentFrame: \(contentFrame)")
        // origin    CGPoint    (x = 0, y = 0)
        // size    CGSize    (width = 393, height = 852)
        contentView.frame = contentFrame
        
        // Adjusts the pane to the correct snap point, e.g. after a rotation.
        if window != nil {
            // animatePane(withInitialVelocity: .zero)
        }
    }
    
    //    func updateSheetState() {
    //        let currentSheetHeight = bounds.maxY - sheet.frame.minY
    //        sheetState = (currentSheetHeight >= maximumSheetHeight() ? .extended : .preferred)
    //    }
    
    private func scrollViewContentHeight() -> CGFloat {
        guard let scrollView = sheet.scrollView else { return 0 }
        return scrollView.contentInset.top + scrollView.contentSize.height + scrollView.contentInset.bottom
    }
    
    // Returns the maximum allowable height that the sheet can be dragged to.
    private func maximumSheetHeight() -> CGFloat {
        var boundsHeight = bounds.height
        boundsHeight -= safeAreaInsets.top
        let contentHeight = scrollViewContentHeight()
        if contentHeight > 0 {
            Swift.print("[SheetContainerView] boundsHeight: \(boundsHeight), contentHeight: \(contentHeight)")
            return min(boundsHeight, contentHeight)
        } else {
            return min(boundsHeight, preferredSheetHeight)
        }
    }
    
    // MARK: - Gesture-driven animation
    //
    //    private func animatePane(withInitialVelocity initialVelocity: CGPoint) {
    //        guard let sheetBehavior else { return }
    //        previousAnimatedBounds = bounds
    //        sheetBehavior.targetPoint = targetPoint()
    //        sheetBehavior.velocity = initialVelocity
    //        sheetBehavior.action = { [weak self] in
    //            self?.sheetBehaviorDidUpdate()
    //        }
    //        animator?.addBehavior(sheetBehavior)
    //    }
    //
    //    // Calculates the snap-point for the view to spring to.
    //    private func targetPoint() -> CGPoint {
    //        let bounds = self.bounds
    //        let midX = bounds.midX
    //        var bottomY = bounds.maxY
    //        if !properties.ignoreKeyboardHeight {
    //            let keyboardOffset = KeyboardWatcher.shared.visibleKeyboardHeight
    //            bottomY -= keyboardOffset
    //        }
    //
    //        var targetPoint: CGPoint
    //        switch sheetState {
    //        case .preferred:
    //            targetPoint = CGPoint(x: midX, y: bottomY - effectiveSheetHeight())
    //        case .extended:
    //            targetPoint = CGPoint(x: midX, y: bottomY - maximumSheetHeight())
    //        case .closed:
    //            targetPoint = CGPoint(x: midX, y: bottomY)
    //        }
    //        delegate?.sheetContainerViewDidChangeYOffset(self, yOffset: targetPoint.y)
    //        return targetPoint
    //    }
    //
    //    private func sheetBehaviorDidUpdate() {
    //        // If sheet has been dragged off the bottom, we can trigger a dismiss.
    //        if sheetState == .closed && sheet.frame.minY > bounds.maxY {
    //            delegate?.sheetContainerViewDidHide(self)
    //
    //            animator?.removeAllBehaviors()
    //
    //            // Reset the state to preferred once we are dismissed.
    //            sheetState = .preferred
    //        }
    //    }
    
    // MARK: - Notifications
    //
    //    @objc private func keyboardStateChanged(with notification: Notification) {
    //        if window != nil {
    //            // Only add animation if the view is not set to be dismissed with the new keyboard.
    //            if !willBeDismissed {
    //                animatePane(withInitialVelocity: .zero)
    //            }
    //        }
    //    }
}

extension SheetContainerView: DraggableViewDelegate {
    
    // MARK: - DraggableViewDelegate
    
    func maximumHeight(for view: DraggableView) -> CGFloat {
        return maximumSheetHeight()
    }
    //
//    func draggableView(_ view: DraggableView, shouldBeginDraggingWithVelocity velocity: CGPoint) -> Bool {
//        updateSheetState()
//
//        switch sheetState {
//        case .preferred:
//            return true
//        case .extended:
//            if let scrollView = sheet.scrollView {
//                let draggingDown = velocity.y >= 0
//                // Only allow dragging down if we are scrolled to the top.
//                if scrollView.contentOffset.y <= -scrollView.contentInset.top && draggingDown {
//                    return true
//                } else {
//                    // Allow dragging in any direction if the content is not scrollable.
//                    let contentHeight = scrollView.contentInset.top + scrollView.contentSize.height +
//                                        scrollView.contentInset.bottom
//                    return scrollView.bounds.height >= contentHeight
//                }
//            }
//            return true
//        case .closed:
//            return false
//        }
//    }
//
//    func draggableView(_ view: DraggableView, draggingEndedWithVelocity velocity: CGPoint) {
//        let targetState: SheetState
//        if preferredSheetHeight == maximumSheetHeight() {
//            // Cannot be extended, only closed.
//            targetState = (velocity.y > 0 && properties.dismissOnDraggingDownSheet) ? .closed : .preferred
//        } else {
//            let currentSheetHeight = bounds.maxY - sheet.frame.minY
//            if currentSheetHeight >= preferredSheetHeight {
//                targetState = velocity.y > 0 ? .preferred : .extended
//            } else {
//                targetState = (velocity.y > 0 && properties.dismissOnDraggingDownSheet) ? .closed : .preferred
//            }
//        }
//        isDragging = false
//        // sheetState = targetState
//        animatePane(withInitialVelocity: velocity)
//    }
//
//    func draggableViewBeganDragging(_ view: DraggableView) {
//        animator?.removeAllBehaviors()
//        isDragging = true
//    }
}
