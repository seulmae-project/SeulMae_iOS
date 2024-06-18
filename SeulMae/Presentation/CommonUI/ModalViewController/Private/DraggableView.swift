//
//  DraggableView.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit.UIView

class DraggableView: UIView {
    private func cancelGestureRecognizer(_ gesture: UIGestureRecognizer) {
        if gesture.isEnabled {
            gesture.isEnabled = false
            gesture.isEnabled = true
        }
    }
    
    private var dragRecognizer: UIPanGestureRecognizer!
    
    private(set) var scrollView: UIScrollView?
    
    var simulateScrollViewBounce: Bool = false
    
    weak var delegate: DraggableViewDelegate?
    
    private var mostRecentMinY: CGFloat = 0
    
    init(frame: CGRect, scrollView: UIScrollView?) {
        super.init(frame: frame)
        self.scrollView = scrollView
        if let scrollView = scrollView {
            addSubview(scrollView)
            scrollView.frame = bounds
            scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        dragRecognizer.maximumNumberOfTouches = 1
        dragRecognizer.delegate = self
        addGestureRecognizer(dragRecognizer)
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) has been disabled. Use init(frame:scrollView:) instead.")
    }
    
    // MARK: - Gesture handling
    
    @objc private func didPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            mostRecentMinY = frame.minY
            delegate?.draggableViewBeganDragging(self)
        case .changed:
            var velocity = recognizer.velocity(in: superview)
            let translation = recognizer.translation(in: superview)
            velocity.x = 0
            
            let maxHeight = delegate?.maximumHeight(for: self) ?? 0
            let minimumStableMinY = superview?.bounds.height ?? 0 - maxHeight - MDCKeyboardWatcher.shared.visibleKeyboardHeight
            
            var newMinY = mostRecentMinY + translation.y
            
            if newMinY < minimumStableMinY {
                if scrollView == nil && !simulateScrollViewBounce {
                    velocity = .zero
                    newMinY = minimumStableMinY
                } else {
                    newMinY = minimumStableMinY + (translation.y - (translation.y / 1.2))
                }
            }
            
            let newFrame = CGRect(x: frame.minX, y: newMinY, width: frame.width, height: frame.height)
            frame = newFrame
            
            delegate?.draggableView(self, didPanToOffset: frame.minY)
            
        case .ended, .cancelled:
            let velocity = recognizer.velocity(in: superview)
            delegate?.draggableView(self, draggingEndedWithVelocity: velocity)
        default:
            break
        }
    }
}

extension DraggableView: UIGestureRecognizerDelegate {
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ recognizer: UIPanGestureRecognizer) -> Bool {
        guard recognizer == dragRecognizer else {
            return false
        }
        
        var velocity = recognizer.velocity(in: superview)
        velocity.x = 0
        
        guard let shouldBegin = delegate?.draggableView(self, shouldBeginDraggingWithVelocity: velocity) else {
            return false
        }
        
        cancelGestureRecognizer(scrollView?.panGestureRecognizer ?? UIPanGestureRecognizer())
        return shouldBegin
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer == scrollView?.panGestureRecognizer
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIControl)
    }
}
