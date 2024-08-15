//
//  ShapedShadowLayer.swift
//  SeulMae
//
//  Created by 조기열 on 6/19/24.
//

import UIKit

@available(iOS, deprecated: 12.0, message: """
🤖👀 Use branded UIKit shadows instead.
See go/material-ios-elevation/gm2-migration for more details.
This has go/material-ios-migrations#scriptable-potential 🤖👀.
""")
class ShapedShadowLayer: ShadowLayer {
    
    var shapedBackgroundColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }
    
    var shapedBorderColor: UIColor? {
        didSet {
            updateBorderColor()
        }
    }
    
    var shapedBorderWidth: CGFloat = 0 {
        didSet {
            updateBorderWidth()
        }
    }
    
    var shapeGenerator: ShapeGenerating? {
        didSet {
            setShapePath()
        }
    }
    
    var shapeLayer: CAShapeLayer = CAShapeLayer()
    var colorLayer: CAShapeLayer = CAShapeLayer()
    
    override init() {
        super.init()
        commonMDCShapedShadowLayerInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonMDCShapedShadowLayerInit()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let otherLayer = layer as? ShapedShadowLayer {
            shapeGenerator = otherLayer.shapeGenerator
            colorLayer = otherLayer.colorLayer
        }
    }
    
    private func commonMDCShapedShadowLayerInit() {
        self.backgroundColor = UIColor.clear.cgColor
        colorLayer.delegate = self
        self.addSublayer(colorLayer)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let bounds = self.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        colorLayer.position = center
        colorLayer.bounds = bounds
    }
    
    private func setShapePath() {
        if let shapeGenerator = shapeGenerator {
            let standardizedBounds = bounds.standardized
            self.path = shapeGenerator.path(for: standardizedBounds.size)
        }
    }
    
    var path: CGPath? {
        get {
            colorLayer.path
        }
        set {
            self.shadowPath = newValue
            colorLayer.path = path
            shapeLayer.path = path
            updatePathDependentProperties()
        }
    }
    
    private func updatePathDependentProperties() {
        if let path = path, !path.isEmpty {
            self.backgroundColor = nil
            self.borderColor = nil
            self.borderWidth = 0
            colorLayer.fillColor = shapedBackgroundColor?.cgColor
            colorLayer.strokeColor = shapedBorderColor?.cgColor
            colorLayer.lineWidth = shapedBorderWidth
            generateColorPathGivenLineWidth()
        } else {
            self.backgroundColor = shapedBackgroundColor?.cgColor
            self.borderColor = shapedBorderColor?.cgColor
            self.borderWidth = shapedBorderWidth
            colorLayer.fillColor = nil
            colorLayer.strokeColor = nil
            colorLayer.lineWidth = 0
        }
    }
    
    private func generateColorPathGivenLineWidth() {
        if let path = self.path, !path.isEmpty, colorLayer.lineWidth > 0 {
            let halfOfBorderWidth = shapedBorderWidth / 2.0
            var colorLayerTransform = generateTransform(insetByValue: halfOfBorderWidth)
            if let colorLayerPath = path.copy(using: &colorLayerTransform) {
                colorLayer.path = colorLayerPath
            }
            
            var shapeLayerTransform = generateTransform(insetByValue: shapedBorderWidth)
            if let shapeLayerPath = path.copy(using: &shapeLayerTransform) {
                shapeLayer.path = shapeLayerPath
            }
        } else {
            colorLayer.path = self.shadowPath
            shapeLayer.path = self.shadowPath
        }
    }
    
    private func generateTransform(insetByValue value: CGFloat) -> CGAffineTransform {
        if value < 0.001 {
            return .identity
        }
        
        let pathBoundingBox = shadowPath?.boundingBox ?? .zero
        let standardizedBounds = pathBoundingBox.standardized
        
        if standardizedBounds.width < 0.001 || standardizedBounds.height < 0.001 {
            return .identity
        }
        
        let insetBounds = standardizedBounds.insetBy(dx: value, dy: value)
        let width = standardizedBounds.width
        let height = standardizedBounds.height
        let centerX = standardizedBounds.midX
        let centerY = standardizedBounds.midY
        let shiftWidth = value * 2 / width * centerX
        let shiftHeight = value * 2 / height * centerY
        var transform = CGAffineTransform(translationX: shiftWidth, y: shiftHeight)
        transform = transform.scaledBy(x: insetBounds.width / width, y: insetBounds.height / height)
        return transform
    }
    
    private func updateBackgroundColor() {
        if let view = self.delegate as? UIView {
            shapedBackgroundColor = shapedBackgroundColor?.resolvedColor(with: view.traitCollection)
        }
        
        if path?.isEmpty ?? true {
            self.backgroundColor = shapedBackgroundColor?.cgColor
            colorLayer.fillColor = nil
        } else {
            self.backgroundColor = nil
            colorLayer.fillColor = shapedBackgroundColor?.cgColor
        }
    }
    
    private func updateBorderColor() {
        if let view = self.delegate as? UIView {
            shapedBorderColor = shapedBorderColor?.resolvedColor(with: view.traitCollection)
        }
        
        if path?.isEmpty ?? true {
            self.borderColor = shapedBorderColor?.cgColor
            colorLayer.strokeColor = nil
        } else {
            self.borderColor = nil
            colorLayer.strokeColor = shapedBorderColor?.cgColor
        }
    }
    
    private func updateBorderWidth() {
        if path?.isEmpty ?? true {
            self.borderWidth = shapedBorderWidth
            colorLayer.lineWidth = 0
        } else {
            self.borderWidth = 0
            colorLayer.lineWidth = shapedBorderWidth
            generateColorPathGivenLineWidth()
        }
    }
}
