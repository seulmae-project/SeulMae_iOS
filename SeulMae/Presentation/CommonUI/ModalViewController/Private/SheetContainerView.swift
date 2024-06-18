//
//  SheetContainerView.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit

class SheetContainerView: UIView, DraggableViewDelegate {
   
    static var kContentSizeKey: String? = {
        return #selector(getter: UIScrollView.contentSize).description
    }()
    
    static var kContentInsetKey: String? = {
        return #selector(getter: UIScrollView.contentInset).description
    }()

    static var kObservingContext = UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 1)
    static let kSheetBounceBuffer: CGFloat = 150
    
    var animator: UIDynamicAnimator?
    var sheetBehavior: SheetBehavior?
    var isDragging: Bool = false
    var originalPreferredSheetHeight: CGFloat = 0
    var previousAnimatedBounds: CGRect = .zero
    
    weak var delegate: SheetContainerViewDelegate?
    private(set) var sheetState: SheetState = .closed
    var preferredSheetHeight: CGFloat = 0
    var adjustHeightForSafeAreaInsets: Bool = false
    var willBeDismissed: Bool = false
    var ignoreKeyboardHeight: Bool = false
    var dismissOnDraggingDownSheet: Bool = true
    
    private var sheet: DraggableView?
    private var contentView: UIView
    private var scrollView: UIScrollView?
    private var simulateScrollViewBounce: Bool
    
    init(frame: CGRect, contentView: UIView, scrollView: UIScrollView?, simulateScrollViewBounce: Bool) {
        self.contentView = contentView
        self.scrollView = scrollView
        self.simulateScrollViewBounce = simulateScrollViewBounce
        super.init(frame: frame)
        
        addSubview(contentView)
        if let scrollView = scrollView {
            addSubview(scrollView)
        }
    }
    
    init(frame: CGRect, contentView: UIView, scrollView: UIScrollView, simulateScrollViewBounce: Bool) {
        self.simulateScrollViewBounce = simulateScrollViewBounce
        self.sheetState = UIAccessibility.isVoiceOverRunning ? .extended : .preferred
        self.contentView = contentView
        self.sheet = DraggableView(frame: .zero, scrollView: scrollView)
        self.animator = UIDynamicAnimator(referenceView: self)
        
        super.init(frame: frame)
        
        self.willBeDismissed = false
        self.ignoreKeyboardHeight = false
        
        // Configure sheet view
        self.sheet?.simulateScrollViewBounce = self.simulateScrollViewBounce
        self.sheet?.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.sheet?.delegate = self
        self.sheet?.backgroundColor = self.contentView.backgroundColor
        self.sheet?.layer.cornerRadius = self.contentView.layer.cornerRadius
        self.sheet?.layer.maskedCorners = self.contentView.layer.maskedCorners
        
        // Adjust anchor point for sheet view
        self.sheet?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.sheet?.frame = self.bounds
        
        // Configure content view
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add content view to sheet
        self.sheet?.addSubview(self.contentView)
        self.addSubview(self.sheet!)
        
        // Initialize animator
        animator = UIDynamicAnimator(referenceView: self)

        // Add observers for scrollView
        scrollView.addObserver(self, forKeyPath: SheetContainerView.kContentSizeKey!, options: [.new, .old], context: SheetContainerView.kObservingContext)
        scrollView.addObserver(self, forKeyPath: SheetContainerView.kContentInsetKey!, options: [.new, .old], context: SheetContainerView.kObservingContext)
        
        // Add observer for VoiceOver status change
        NotificationCenter.default.addObserver(self, selector: #selector(voiceOverStatusDidChange), name: UIAccessibility.voiceOverStatusDidChangeNotification, object: nil)
        
        // Add keyboard notifications
        let notificationNames = [
            UIResponder.keyboardWillShowNotification,
            UIResponder.keyboardWillHideNotification,
            UIResponder.keyboardWillChangeFrameNotification
        ]
        
        for name in notificationNames {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardStateChanged(with:)), name: name, object: nil)
        }
        
        // Disable contentInsetAdjustmentBehavior
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.preservesSuperviewLayoutMargins = true
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) has been disabled. Use init(frame:contentView:scrollView:simulateScrollViewBounce:) instead.")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let scrollView = sheet?.scrollView {
            scrollView.removeObserver(self, forKeyPath: SheetContainerView.kContentSizeKey!, context: &SheetContainerView.kObservingContext)
            scrollView.removeObserver(self, forKeyPath: SheetContainerView.kContentInsetKey!, context: &SheetContainerView.kObservingContext)
        }
    }

    @objc private func voiceOverStatusDidChange() {
        guard let window = window, UIAccessibility.isVoiceOverRunning else {
            return
        }
        animatePane(withInitialVelocity: .zero)
        updateSheetState()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let window = window {
            if sheetBehavior == nil {
                sheetBehavior = SheetBehavior(item: sheet!, simulateScrollViewBounce: simulateScrollViewBounce)
            }
            animatePane(withInitialVelocity: .zero)
        } else {
            animator!.removeAllBehaviors()
            sheetBehavior = nil
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass else {
            return
        }

        updateSheetFrame()
    }

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()

        guard adjustHeightForSafeAreaInsets else {
            return
        }

        preferredSheetHeight = originalPreferredSheetHeight + safeAreaInsets.bottom

        var contentInset = sheet?.scrollView?.contentInset
        contentInset?.bottom = max(contentInset!.bottom, safeAreaInsets.bottom)
        sheet?.scrollView?.contentInset = contentInset!

        var scrollViewFrame = sheet?.scrollView?.frame.standardized
        scrollViewFrame?.size.height = frame.height
        sheet?.scrollView?.frame = scrollViewFrame!

        updateSheetFrame()
    }
    
    // MARK: - KVO

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if context == SheetContainerView.kObservingContext {
            guard let keyPath = keyPath else { return }
            guard let oldValue = change?[.oldKey] as? NSValue,
                  let newValue = change?[.newKey] as? NSValue else { return }
            
            if window != nil && !isDragging && oldValue != newValue {
                animatePane(withInitialVelocity: .zero)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        if !bounds.equalTo(previousAnimatedBounds) && window != nil {
            animatePane(withInitialVelocity: .zero)
        }
    }

    func updateSheetHeight() {
        var adjustedPreferredSheetHeight = originalPreferredSheetHeight
        if adjustHeightForSafeAreaInsets {
            adjustedPreferredSheetHeight += safeAreaInsets.bottom
        }
        
        guard preferredSheetHeight != adjustedPreferredSheetHeight else {
            return
        }
        preferredSheetHeight = adjustedPreferredSheetHeight
        
        updateSheetFrame()
    }

    func setPreferredSheetHeight(_ preferredSheetHeight: CGFloat) {
        originalPreferredSheetHeight = preferredSheetHeight
        updateSheetHeight()
    }

    func setAdjustHeightForSafeAreaInsets(_ adjustHeightForSafeAreaInsets: Bool) {
        self.adjustHeightForSafeAreaInsets = adjustHeightForSafeAreaInsets
        updateSheetHeight()
    }

    // Slides the sheet position downwards, so the right amount peeks above the bottom of the superview.
    func updateSheetFrame() {
        animator!.removeAllBehaviors()

        var sheetRect = bounds
        sheetRect.origin.y = Double(bounds.maxY - effectiveSheetHeight())
        sheetRect.size.height += SheetContainerView.kSheetBounceBuffer

        sheet?.frame = sheetRect

        var contentFrame = sheet?.bounds
        contentFrame?.size.height -= SheetContainerView.kSheetBounceBuffer
        if sheet?.scrollView == nil {
            contentFrame?.size.height = effectiveSheetHeight()
        }
        contentView.frame = contentFrame!

        // Adjusts the pane to the correct snap point, e.g. after a rotation.
        if window != nil {
            animatePane(withInitialVelocity: .zero)
        }
    }

    func updateSheetState() {
        if UIAccessibility.isVoiceOverRunning {
            sheetState = .extended
        } else {
            let currentSheetHeight = bounds.maxY - sheet!.frame.minY
            sheetState = (currentSheetHeight >= maximumSheetHeight() ? .extended : .preferred)
        }
    }

    // Returns |preferredSheetHeight|, modified as necessary. It will return the full screen height if
    // the content height is taller than the sheet height and the vertical size class is `.compact`.
    // Otherwise, it will return `preferredSheetHeight`, assuming it's shorter than the sheet height.
    func effectiveSheetHeight() -> CGFloat {
        let maxSheetHeight = maximumSheetHeight
        let contentIsTallerThanMaxSheetHeight = scrollViewContentHeight() > maxSheetHeight()
        let isVerticallyCompact = traitCollection.verticalSizeClass == .compact
        if contentIsTallerThanMaxSheetHeight && isVerticallyCompact {
            return maxSheetHeight()
        } else {
            return min(preferredSheetHeight, maxSheetHeight())
        }
    }

    func scrollViewContentHeight() -> CGFloat {
        return (sheet?.scrollView!.contentInset.top)! +
        (sheet?.scrollView!.contentSize.height)! +
        (sheet?.scrollView!.contentInset.bottom)!
    }

    // Returns the maximum allowable height that the sheet can be dragged to.
    func maximumSheetHeight() -> CGFloat {
        var boundsHeight = bounds.height
        boundsHeight -= safeAreaInsets.top
        let contentHeight = scrollViewContentHeight()
        if contentHeight > 0 {
            return min(boundsHeight, contentHeight)
        } else {
            return min(boundsHeight, preferredSheetHeight)
        }
    }
    
    // MARK: - Gesture-driven animation

    func animatePane(withInitialVelocity initialVelocity: CGPoint) {
        previousAnimatedBounds = bounds
        sheetBehavior!.targetPoint = targetPoint()
        sheetBehavior!.velocity = initialVelocity
        sheetBehavior!.action = { [weak self] in
            self?.sheetBehaviorDidUpdate()
        }
        animator!.addBehavior(sheetBehavior!)
    }

    // Calculates the snap-point for the view to spring to.
    func targetPoint() -> CGPoint {
        var bounds = self.bounds
        let midX = bounds.midX
        var bottomY = bounds.maxY
        if !ignoreKeyboardHeight {
            let keyboardOffset = KeyboardWatcher.shared.visibleKeyboardHeight
            bottomY -= keyboardOffset
        }

        var targetPoint: CGPoint
        switch sheetState {
        case .preferred:
            targetPoint = CGPoint(x: midX, y: bottomY - effectiveSheetHeight())
        case .extended:
            targetPoint = CGPoint(x: midX, y: bottomY - maximumSheetHeight())
        case .closed:
            targetPoint = CGPoint(x: midX, y: bottomY)
        }
        delegate?.sheetContainerViewDidChangeYOffset(self, yOffset: targetPoint.y)
        return targetPoint
    }

    func sheetBehaviorDidUpdate() {
        // If sheet has been dragged off the bottom, we can trigger a dismiss.
        if sheetState == .closed && sheet!.frame.minY > bounds.maxY {
            delegate?.sheetContainerViewDidHide(self)

            animator!.removeAllBehaviors()

            // Reset the state to preferred once we are dismissed.
            sheetState = .preferred
        }
    }

    // MARK: - Notifications

    @objc func keyboardStateChanged(with notification: Notification) {
        if window != nil {
            // Only add animation if the view is not set to be dismissed with the new keyboard.
            if !willBeDismissed {
                animatePane(withInitialVelocity: .zero)
            }
        }
    }

    // MARK: - MDCDraggableViewDelegate

    func maximumHeight(for view: DraggableView) -> CGFloat {
        return maximumSheetHeight()
    }

    func draggableView(_ view: DraggableView, shouldBeginDraggingWithVelocity velocity: CGPoint) -> Bool {
        updateSheetState()

        switch sheetState {
        case .preferred:
            return true
        case .extended:
            if let scrollView = sheet?.scrollView {
                let draggingDown = velocity.y >= 0
                // Only allow dragging down if we are scrolled to the top.
                if scrollView.contentOffset.y <= -scrollView.contentInset.top && draggingDown {
                    return true
                } else {
                    // Allow dragging in any direction if the content is not scrollable.
                    let contentHeight = scrollView.contentInset.top + scrollView.contentSize.height +
                                        scrollView.contentInset.bottom
                    return scrollView.bounds.height >= contentHeight
                }
            }
            return true
        case .closed:
            return false
        }
    }

    func draggableView(_ view: DraggableView, draggingEndedWithVelocity velocity: CGPoint) {
        let targetState: SheetState
        if preferredSheetHeight == maximumSheetHeight() {
            // Cannot be extended, only closed.
            targetState = (velocity.y > 0 && dismissOnDraggingDownSheet) ? .closed : .preferred
        } else {
            let currentSheetHeight = bounds.maxY - sheet!.frame.minY
            if currentSheetHeight >= preferredSheetHeight {
                targetState = velocity.y > 0 ? .preferred : .extended
            } else {
                targetState = (velocity.y > 0 && dismissOnDraggingDownSheet) ? .closed : .preferred
            }
        }
        isDragging = false
        sheetState = targetState
        animatePane(withInitialVelocity: velocity)
    }

    func draggableViewBeganDragging(_ view: DraggableView) {
        animator!.removeAllBehaviors()
        isDragging = true
    }

    func draggableView(_ view: DraggableView, didPanToOffset offset: CGFloat) {
        delegate?.sheetContainerViewDidChangeYOffset(self, yOffset: offset)
    }

//    var sheetState: SheetState {
//        didSet {
//            if sheetState != oldValue {
//                delegate?.sheetContainerViewWillChangeState(self, sheetState: sheetState)
//            }
//        }
//    }
}
