//
//  DraggableViewDelegate.swift
//  SeulMae
//
//  Created by 조기열 on 6/18/24.
//

import Foundation

protocol DraggableViewDelegate: NSObjectProtocol {
    
    func maximumHeight(for view: DraggableView) -> CGFloat
////    func draggableView(_ view: DraggableView, shouldBeginDraggingWithVelocity velocity: CGPoint) -> Bool
////    func draggableViewBeganDragging(_ view: DraggableView)
////    func draggableView(_ view: DraggableView, draggingEndedWithVelocity velocity: CGPoint)
//    func draggableView(_ view: DraggableView, didPanToOffset offset: CGFloat)
}
