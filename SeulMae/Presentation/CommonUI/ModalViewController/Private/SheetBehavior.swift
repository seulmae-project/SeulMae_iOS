//
//  SheetBehavior.swift
//  SeulMae
//
//  Created by 조기열 on 6/18/24.
//

import UIKit.UIDynamicBehavior

class SheetBehavior: UIDynamicBehavior {
    
    private let kSimulateScrollViewBounceFrequency: CGFloat = 3.5
    private let kSimulateScrollViewBounceDamping: CGFloat = 0.4
    private let kDisableScrollViewBounceFrequency: CGFloat = 5.5
    private let kDisableScrollViewBounceDamping: CGFloat = 1.0
    
    var targetPoint: CGPoint = .zero {
        didSet {
            attachmentBehavior.anchorPoint = targetPoint
        }
    }
    
    var velocity: CGPoint = .zero {
        didSet {
            let currentVelocity = itemBehavior.linearVelocity(for: item)
            let velocityDelta = CGPoint(x: velocity.x - currentVelocity.x,
                                        y: velocity.y - currentVelocity.y)
            itemBehavior.addLinearVelocity(velocityDelta, for: item)
        }
    }
    
    private var attachmentBehavior: UIAttachmentBehavior!
    private var itemBehavior: UIDynamicItemBehavior!
    private var item: UIDynamicItem
    
    init(item: UIDynamicItem, simulateScrollViewBounce: Bool) {
        self.item = item
        super.init()
        
        attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: .zero)
        if simulateScrollViewBounce {
            attachmentBehavior.frequency = kSimulateScrollViewBounceFrequency
            attachmentBehavior.damping = kSimulateScrollViewBounceDamping
        } else {
            attachmentBehavior.frequency = kDisableScrollViewBounceFrequency
            attachmentBehavior.damping = kDisableScrollViewBounceDamping
        }
        attachmentBehavior.length = 0
        
        // Anchor movement along the y-axis.
        attachmentBehavior.action = { [weak self] in
            guard let strongSelf = self else { return }
            var center = item.center
            center.x = strongSelf.targetPoint.x
            item.center = center
        }
        addChildBehavior(attachmentBehavior)
        
        itemBehavior = UIDynamicItemBehavior(items: [item])
        itemBehavior.density = 100
        itemBehavior.resistance = 10
        addChildBehavior(itemBehavior)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
