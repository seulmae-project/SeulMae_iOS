//
//  ShapeView.swift
//  SeulMae
//
//  Created by 조기열 on 6/19/24.
//

import UIKit

class ShapedView: UIView {
    
    private var shapedShadowLayer: ShapedShadowLayer {
        return self.layer as! ShapedShadowLayer
    }
    
    private(set) var pathSize: CGSize = .zero
    
    var elevation: CGFloat {
        get {
            return self.shapedShadowLayer.elevation
        }
        set {
            self.shapedShadowLayer.elevation = newValue
        }
    }
    
    var shapeGenerator: ShapeGenerating? {
        get {
            return self.shapedShadowLayer.shapeGenerator
        }
        set {
            self.shapedShadowLayer.shapeGenerator = newValue
        }
    }
    
    var shapedBorderColor: UIColor? {
        get {
            return self.shapedShadowLayer.shapedBorderColor
        }
        set {
            self.shapedShadowLayer.shapedBorderColor = newValue
        }
    }
    
    var shapedBorderWidth: CGFloat {
        get {
            return self.shapedShadowLayer.shapedBorderWidth
        }
        set {
            self.shapedShadowLayer.shapedBorderWidth = newValue
        }
    }
    
    override var backgroundColor: UIColor? {
        get {
            return self.shapedShadowLayer.shapedBackgroundColor
        }
        set {
            self.shapedShadowLayer.shapedBackgroundColor = newValue
        }
    }
    
    override class var layerClass: AnyClass {
        return ShapedShadowLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.shapedShadowLayer.shapeGenerator = nil
    }
    
    init(frame: CGRect, shapeGenerator: ShapeGenerating?) {
        super.init(frame: frame)
        self.shapedShadowLayer.shapeGenerator = shapeGenerator
    }
}
