//
//  DraggableView.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit.UIView

class DraggableView: UIView {
    
    // MARK: - UI Properties
    
    private(set) var scrollView: UIScrollView?
    
    // MARK: - Properties
    
    private var dragRecognizer: UIPanGestureRecognizer!
    
    var simulateScrollViewBounce: Bool = false
    weak var delegate: DraggableViewDelegate?
    private var mostRecentMinY: CGFloat = 0
    
    // MARK: - Initializer Methods
    
    init(frame: CGRect, scrollView: UIScrollView?) {
        super.init(frame: frame)
        self.scrollView = scrollView
        
        // Configure drag recognizer
        dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        dragRecognizer.maximumNumberOfTouches = 1
        dragRecognizer.delegate = self
        addGestureRecognizer(dragRecognizer)
        
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        Swift.fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        Swift.fatalError("init(frame:) has been disabled. Use init(frame:scrollView:) instead.")
    }
    
    // MARK: - Private Methods
    
    private func cancelGestureRecognizer(_ gesture: UIGestureRecognizer) {
        if gesture.isEnabled {
            gesture.isEnabled = false
            gesture.isEnabled = true
        }
    }
    
    // MARK: - Gesture handling Methods
    
    @objc private func didPan(_ recognizer: UIPanGestureRecognizer) {
        if case .began = recognizer.state {
            mostRecentMinY = frame.minY
            // delegate?.draggableViewBeganDragging(self)
            return
        }
        
        var velocity = recognizer.velocity(in: superview)
        let translation = recognizer.translation(in: superview)
        velocity.x = 0
        
        let maxHeight = delegate?.maximumHeight(for: self) ?? 0
        let minimumStableMinY = (superview?.bounds.height ?? 0) - maxHeight - KeyboardWatcher.shared.visibleKeyboardHeight
        
        print("maxHeight: \(maxHeight), minimumStableMinY: \(minimumStableMinY)")
        
        var _newMinY = mostRecentMinY + translation.y
        var newMinY = mostRecentMinY + translation.y
        if newMinY < minimumStableMinY {
            if scrollView == nil && !simulateScrollViewBounce {
                velocity = .zero
                newMinY = minimumStableMinY
            } else {
                newMinY = minimumStableMinY + (translation.y - (translation.y / 1.2))
            }
        }
        
        switch recognizer.state {
        case .changed:
            let newFrame = CGRect(x: frame.minX, y: _newMinY, width: frame.width, height: frame.height)
            Swift.print("newFrame: \(newFrame)")
            frame = newFrame
            // delegate?.draggableView(self, didPanToOffset: frame.minY)
        case .ended:
            break
            // delegate?.draggableView(self, draggingEndedWithVelocity: velocity)
        case .cancelled:
            break
            // delegate?.draggableView(self, draggingEndedWithVelocity: .zero)
        default:
            break
        }
    }
}

extension DraggableView: UIGestureRecognizerDelegate {
    
    // MARK: - UIGestureRecognizerDelegate
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        Swift.print("+++++++++++++++")
        
        guard gestureRecognizer == dragRecognizer,
              let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        var velocity = panGestureRecognizer.velocity(in: superview)
        velocity.x = 0
        
        // guard let shouldBegin = delegate?.draggableView(self, shouldBeginDraggingWithVelocity: velocity) else { return false }
        // if let scrollViewGesture = scrollView?.panGestureRecognizer {
        //     cancelGestureRecognizer(scrollViewGesture)
        // }
        
        return  true // shouldBegin
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return (otherGestureRecognizer == scrollView?.panGestureRecognizer)
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        
        let a = !(touch.view is UIControl)
        print("a: \(a)")
        // 버튼과 같은 UIControl이 선택되지 않은 경우
        return !(touch.view is UIControl)
    }
}
