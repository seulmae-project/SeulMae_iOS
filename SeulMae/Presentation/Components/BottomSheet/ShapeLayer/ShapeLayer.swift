//
//  ShapeLayer.swift
//  SeulMae
//
//  Created by 조기열 on 6/19/24.
//

import UIKit

private let kShadowElevationDialog: CGFloat = 24.0
private let kKeyShadowOpacity: Float = 0.26
private let kAmbientShadowOpacity: Float = 0.08

@available(iOS, deprecated: 12.0, message: """
🤖👀 Use branded UIKit shadows instead.
See go/material-ios-elevation/gm2-migration for more details.
This has go/material-ios-migrations#scriptable-potential 🤖👀.
""")
class ShadowMetrics: NSObject {
    let topShadowRadius: CGFloat
    let topShadowOffset: CGSize
    let topShadowOpacity: Float
    let bottomShadowRadius: CGFloat
    let bottomShadowOffset: CGSize
    let bottomShadowOpacity: Float
    
    init(elevation: CGFloat) {
        if elevation > 0 {
            self.topShadowRadius = ShadowMetrics.ambientShadowBlur(elevation)
            self.topShadowOffset = .zero
            self.topShadowOpacity = kAmbientShadowOpacity
            self.bottomShadowRadius = ShadowMetrics.keyShadowBlur(elevation)
            self.bottomShadowOffset = CGSize(width: 0.0, height: ShadowMetrics.keyShadowYOff(elevation))
            self.bottomShadowOpacity = kKeyShadowOpacity
        } else {
            self.topShadowRadius = 0.0
            self.topShadowOffset = .zero
            self.topShadowOpacity = 0.0
            self.bottomShadowRadius = 0.0
            self.bottomShadowOffset = .zero
            self.bottomShadowOpacity = 0.0
        }
        super.init()
    }
    
    private override init() {
        self.topShadowRadius = 0.0
        self.topShadowOffset = .zero
        self.topShadowOpacity = 0.0
        self.bottomShadowRadius = 0.0
        self.bottomShadowOffset = .zero
        self.bottomShadowOpacity = 0.0
        super.init()
    }
    
    static func metrics(withElevation elevation: CGFloat) -> ShadowMetrics {
        if elevation > 0 {
            return ShadowMetrics(elevation: elevation)
        } else {
            return ShadowMetrics.emptyShadowMetrics()
        }
    }
    
    private static var emptyShadowMetricsInstance: ShadowMetrics = {
        let instance = ShadowMetrics()
        return instance
    }()
    
    static func emptyShadowMetrics() -> ShadowMetrics {
        return emptyShadowMetricsInstance
    }
    
    static func ambientShadowBlur(_ points: CGFloat) -> CGFloat {
        return 0.889544 * points - 0.003701
    }
    
    static func keyShadowBlur(_ points: CGFloat) -> CGFloat {
        return 0.666920 * points - 0.001648
    }
    
    static func keyShadowYOff(_ points: CGFloat) -> CGFloat {
        return 1.23118 * points - 0.03933
    }
}

class ShadowLayer: CALayer, CALayerDelegate {
    private var topShadow: CAShapeLayer = CAShapeLayer()
    private var bottomShadow: CAShapeLayer = CAShapeLayer()
    private var topShadowMask: CAShapeLayer = CAShapeLayer()
    private var bottomShadowMask: CAShapeLayer = CAShapeLayer()
    private var shadowPathIsInvalid: Bool = true
    
    var elevation: CGFloat = 0 {
        didSet {
            let shadowMetrics = ShadowMetrics.metrics(withElevation: elevation)
            topShadow.shadowOffset = shadowMetrics.topShadowOffset
            topShadow.shadowRadius = shadowMetrics.topShadowRadius
            topShadow.shadowOpacity = shadowMetrics.topShadowOpacity
            bottomShadow.shadowOffset = shadowMetrics.bottomShadowOffset
            bottomShadow.shadowRadius = shadowMetrics.bottomShadowRadius
            bottomShadow.shadowOpacity = shadowMetrics.bottomShadowOpacity
        }
    }

    var shadowMaskEnabled: Bool = true {
        didSet {
            if shadowMaskEnabled {
                configureShadowLayerMask(for: topShadowMask)
                configureShadowLayerMask(for: bottomShadowMask)
                topShadow.mask = topShadowMask
                bottomShadow.mask = bottomShadowMask
            } else {
                topShadow.mask = nil
                bottomShadow.mask = nil
            }
        }
    }
    
    override init() {
        super.init()
        commonMDCShadowLayerInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonMDCShadowLayerInit()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let otherLayer = layer as? ShadowLayer {
            elevation = otherLayer.elevation
            shadowMaskEnabled = otherLayer.shadowMaskEnabled
            bottomShadow = CAShapeLayer(layer: otherLayer.bottomShadow)
            topShadow = CAShapeLayer(layer: otherLayer.topShadow)
            topShadowMask = CAShapeLayer(layer: otherLayer.topShadowMask)
            bottomShadowMask = CAShapeLayer(layer: otherLayer.bottomShadowMask)
            commonMDCShadowLayerInit()
        }
    }
    
    private func commonMDCShadowLayerInit() {
        if bottomShadow.superlayer == nil {
            bottomShadow.backgroundColor = UIColor.clear.cgColor
            bottomShadow.shadowColor = UIColor.black.cgColor
            bottomShadow.delegate = self
            addSublayer(bottomShadow)
        }
        
        if topShadow.superlayer == nil {
            topShadow.backgroundColor = UIColor.clear.cgColor
            topShadow.shadowColor = UIColor.black.cgColor
            topShadow.delegate = self
            addSublayer(topShadow)
        }
        
        // Setup shadow layer state based off elevation and shadowMaskEnabled
        let shadowMetrics = ShadowMetrics.metrics(withElevation: elevation)
        topShadow.shadowOffset = shadowMetrics.topShadowOffset
        topShadow.shadowRadius = shadowMetrics.topShadowRadius
        topShadow.shadowOpacity = shadowMetrics.topShadowOpacity
        bottomShadow.shadowOffset = shadowMetrics.bottomShadowOffset
        bottomShadow.shadowRadius = shadowMetrics.bottomShadowRadius
        bottomShadow.shadowOpacity = shadowMetrics.bottomShadowOpacity
        
        if topShadowMask.superlayer == nil {
            topShadowMask.delegate = self
        }
        if bottomShadowMask.superlayer == nil {
            bottomShadowMask.delegate = self
        }
        
        // TODO: We shouldn't be calling property accessors in an init method.
        if shadowMaskEnabled {
            configureShadowLayerMask(for: topShadowMask)
            configureShadowLayerMask(for: bottomShadowMask)
            topShadow.mask = topShadowMask
            bottomShadow.mask = bottomShadowMask
        }
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        prepareShadowPath()
        commonLayoutSublayers()
    }
    
    override var bounds: CGRect {
        didSet {
            if oldValue.size != bounds.size {
                shadowPathIsInvalid = true
                setNeedsLayout()
            }
        }
    }
    
    func prepareShadowPath() {
        // This method is meant to be overridden by subclasses.
    }
    
    var isShadowMaskEnabled: Bool = true {
        didSet {
            // Implement logic to update shadow mask
        }
    }

    func animateCornerRadius(_ cornerRadius: CGFloat, withTimingFunction timingFunction: CAMediaTimingFunction, duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.toValue = cornerRadius
        animation.timingFunction = timingFunction
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        self.add(animation, forKey: "cornerRadiusAnimation")
    }

    private func configureShadowLayerMask(for maskLayer: CAShapeLayer) {
        let path = outerMaskPath()
        var innerPath: UIBezierPath
        if let shadowPath = self.shadowPath {
            innerPath = UIBezierPath(cgPath: shadowPath)
        } else if cornerRadius > 0 {
            innerPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        } else {
            innerPath = UIBezierPath(rect: bounds)
        }
        path.append(innerPath)
        path.usesEvenOddFillRule = true

        maskLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        maskLayer.bounds = maskRect()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        maskLayer.fillColor = UIColor.black.cgColor
    }

    private func outerMaskPath() -> UIBezierPath {
        return UIBezierPath(rect: maskRect())
    }

    private func maskRect() -> CGRect {
        let shadowSpread = ShadowLayer.shadowSpreadForElevation(elevation: kShadowElevationDialog)
        return bounds.insetBy(dx: -shadowSpread.width * 2, dy: -shadowSpread.height * 2)
    }

    // MARK: CALayerDelegate

    func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event == "path" || event == "shadowPath" {
            let pendingAnim = PendingAnimation()
            pendingAnim.animationSourceLayer = self
            pendingAnim.fromValue = layer.presentation()?.value(forKey: event)
            pendingAnim.toValue = nil
            pendingAnim.keyPath = event
            return pendingAnim
        }
        return nil
    }

    // MARK: Private Methods

    private func commonLayoutSublayers() {
        bottomShadow.position = CGPoint(x: bounds.midX, y: bounds.midY)
        bottomShadow.bounds = bounds
        topShadow.position = CGPoint(x: bounds.midX, y: bounds.midY)
        topShadow.bounds = bounds

        if shadowMaskEnabled {
            configureShadowLayerMask(for: topShadowMask)
            configureShadowLayerMask(for: bottomShadowMask)
        }

        if bottomShadow.shadowPath == nil || shadowPathIsInvalid {
            bottomShadow.shadowPath = shadowPath ?? defaultShadowPath().cgPath
        }
        if topShadow.shadowPath == nil || shadowPathIsInvalid {
            topShadow.shadowPath = shadowPath ?? defaultShadowPath().cgPath
        }
        shadowPathIsInvalid = false
    }

    private func defaultShadowPath() -> UIBezierPath {
        let cornerRadius = self.cornerRadius
        if cornerRadius > 0 {
            return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        }
        return UIBezierPath(rect: bounds)
    }

    static func shadowSpreadForElevation(elevation: CGFloat) -> CGSize {
        let metrics = ShadowMetrics.metrics(withElevation: elevation)
        let maxWidth = max(metrics.topShadowRadius, metrics.bottomShadowRadius) +
            max(abs(metrics.topShadowOffset.width), abs(metrics.bottomShadowOffset.width))
        let maxHeight = max(metrics.topShadowRadius, metrics.bottomShadowRadius) +
            max(abs(metrics.topShadowOffset.height), abs(metrics.bottomShadowOffset.height))
        return CGSize(width: maxWidth, height: maxHeight)
    }

    // MARK: Animations

    func animateCornerRadius(cornerRadius: CGFloat, with timingFunction: CAMediaTimingFunction, duration: TimeInterval) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let currentCornerRadius = self.cornerRadius > 0 ? self.cornerRadius : 0.001
        let newCornerRadius = cornerRadius > 0 ? cornerRadius : 0.001
        let currentLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: currentCornerRadius)
        let newLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: newCornerRadius)

        let currentMaskPath = outerMaskPath()
        currentMaskPath.append(currentLayerPath)
        currentMaskPath.usesEvenOddFillRule = true

        let newMaskPath = outerMaskPath()
        newMaskPath.append(newLayerPath)
        newMaskPath.usesEvenOddFillRule = true

        let shadowPathKey = "shadowPath"
        let topLayerAnimation = CABasicAnimation(keyPath: shadowPathKey)
        topLayerAnimation.fromValue = currentLayerPath.cgPath
        topLayerAnimation.toValue = newLayerPath.cgPath
        topLayerAnimation.duration = duration
        topLayerAnimation.timingFunction = timingFunction
        topShadow.shadowPath = newLayerPath.cgPath
        topShadow.add(topLayerAnimation, forKey: shadowPathKey)

        let bottomLayerAnimation = CABasicAnimation(keyPath: shadowPathKey)
        bottomLayerAnimation.fromValue = currentLayerPath.cgPath
        bottomLayerAnimation.toValue = newLayerPath.cgPath
        bottomLayerAnimation.duration = duration
        bottomLayerAnimation.timingFunction = timingFunction
        bottomShadow.shadowPath = newLayerPath.cgPath
        bottomShadow.add(bottomLayerAnimation, forKey: shadowPathKey)

        if shadowMaskEnabled {
            let pathKey = "path"
            let topMaskLayerAnimation = CABasicAnimation(keyPath: pathKey)
            topMaskLayerAnimation.fromValue = currentMaskPath.cgPath
            topMaskLayerAnimation.toValue = newMaskPath.cgPath
            topMaskLayerAnimation.duration = duration
            topMaskLayerAnimation.timingFunction = timingFunction
            topShadowMask.path = newMaskPath.cgPath
            topShadowMask.add(topMaskLayerAnimation, forKey: pathKey)

            let bottomMaskLayerAnimation = CABasicAnimation(keyPath: pathKey)
            bottomMaskLayerAnimation.fromValue = currentMaskPath.cgPath
            bottomMaskLayerAnimation.toValue = newMaskPath.cgPath
            bottomMaskLayerAnimation.duration = duration
            bottomMaskLayerAnimation.timingFunction = timingFunction
            bottomShadowMask.path = newMaskPath.cgPath
            bottomShadowMask.add(bottomMaskLayerAnimation, forKey: pathKey)
        }

        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.fromValue = currentCornerRadius
        cornerRadiusAnimation.toValue = newCornerRadius
        cornerRadiusAnimation.duration = duration
        cornerRadiusAnimation.timingFunction = timingFunction
        self.cornerRadius = cornerRadius
        add(cornerRadiusAnimation, forKey: "cornerRadius")

        CATransaction.commit()
    }
}

class PendingAnimation: NSObject, CAAction {
    weak var animationSourceLayer: CALayer?
    var keyPath: String?
    var fromValue: Any?
    var toValue: Any?
    
    func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
        if let layer = anObject as? CAShapeLayer {
            guard let animationSourceLayer = animationSourceLayer,
                let boundsAction = animationSourceLayer.animation(forKey: "bounds.size") else {
                    return
            }
            var animation: CABasicAnimation?
            if let basicBoundsAction = boundsAction as? CABasicAnimation {
                animation = basicBoundsAction.copy() as? CABasicAnimation
                animation?.keyPath = keyPath
                animation?.fromValue = fromValue
                animation?.toValue = toValue
            }
            if let animation = animation {
                layer.add(animation, forKey: event)
            }
        }
    }
}
