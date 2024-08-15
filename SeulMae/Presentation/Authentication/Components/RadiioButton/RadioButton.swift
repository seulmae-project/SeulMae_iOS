//
//  RadioButton.swift
//  SeulMae
//
//  Created by 조기열 on 6/12/24.
//

import UIKit

class RadioButton: UIButton {
    
    struct IconConfiguration {
        public enum IconStyle {
            case round, square
        }
        
        public enum IconPosition {
            case leading, trailing
        }
        
        var iconStyle: IconStyle = .round
        var iconPosition: IconPosition = .leading
        var iconColor: UIColor?
        var indicatorColor: UIColor?
        var iconSize: CGFloat = 26
        var iconStrokeWidth: CGFloat = 0.5
        var indicatorSize: CGFloat = 26 * 0.5
        var marginWidth: CGFloat = 8.0
    }
    
    private static let accessibilityIdentifier = "radio-button-accessibility-identifier"
        
    private let _lock = NSRecursiveLock()

    // MARK: - For Custom

    public var iconConfiguration = IconConfiguration()

    public var icon: UIImage? {
        didSet {
            self.setImage(icon, for: .normal)
        }
    }
        
    public var selectedIcon: UIImage? {
        didSet {
            self.setImage(selectedIcon, for: .selected)
        }
    }
    
    public var animationDuration: CFTimeInterval = 0.3 {
        didSet {
            _lock.lock(); defer { _lock.unlock() }
            for button in associatedButtons {
                button.animationDuration = animationDuration
            }
        }
    }
    
    // MARK: - Multiple Selection
    
    public var allowsMultipleSelection: Bool = false {
        didSet {
            _lock.lock(); defer { _lock.unlock() }
            for button in associatedButtons {
                button.allowsMultipleSelection = allowsMultipleSelection
            }
        }
    }
    
    public var selectedButtons: [RadioButton] {
        associatedButtons.filter(\.isSelected)
    }
    
    @WeakArray
    public var associatedButtons: [RadioButton] = [] {
        didSet {
            _lock.lock(); defer { _lock.unlock() }
            for other in associatedButtons {
                var buttons = associatedButtons // [m]
                buttons.append(self) // [m, f]
                if let index = buttons.firstIndex(of: other) {
                    buttons.remove(at: index)
                    // [f] m을 지움
                }
                
                // for block stack overflow
                if !(other.associatedButtons == buttons) {
                    other.associatedButtons = buttons
                    // m.associatedButtons = [f]
                }
            }
        }
    }

    public func deselectAssociatedButtons() {
        associatedButtons.forEach { $0.isSelected = false }
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(handleRadioButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addTarget(self, action: #selector(handleRadioButtonTapped), for: .touchUpInside)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureRadioButton()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        addTarget(self, action: #selector(handleRadioButtonTapped), for: .touchUpInside)
        configureRadioButton()
    }
    
    override var isSelected: Bool {
        didSet {
            let isAnimate: Bool = animationDuration > 0.0
            let isIconExist = icon?.accessibilityIdentifier == RadioButton.accessibilityIdentifier && selectedIcon?.accessibilityIdentifier == RadioButton.accessibilityIdentifier
            let isStatusChanged = isSelected != oldValue

            if isAnimate && isStatusChanged && isIconExist {
                let animation = CABasicAnimation(keyPath: "contents")
                animation.duration = animationDuration
                animation.fromValue = isSelected ? selectedIcon?.cgImage : icon?.cgImage
                animation.toValue = isSelected ? icon?.cgImage : selectedIcon?.cgImage
                imageView?.layer.add(animation, forKey: "icon")
            }
            
            super.isSelected = isSelected
            if !allowsMultipleSelection && isSelected {
                deselectAssociatedButtons()
            }
        }
    }
    
    // MARK: - Handler
   
    @objc func handleRadioButtonTapped(_ sender: UIButton) {
        if allowsMultipleSelection {
            sender.isSelected.toggle()
        } else {
            sender.isSelected = true
        }
    }
    
    // MARK: - Configure
    
    private func configureRadioButton() {
        if icon == nil || icon?.accessibilityIdentifier == RadioButton.accessibilityIdentifier {
            icon = createIconImage(isSelected: false)
        }
        
        if selectedIcon == nil || selectedIcon?.accessibilityIdentifier == RadioButton.accessibilityIdentifier {
            selectedIcon = createIconImage(isSelected: true)
        }
        
        let spacing = iconConfiguration.marginWidth
        if iconConfiguration.iconPosition == .trailing {
            let iconWidth = (icon?.size.width ?? 0)
            let textWidth  = frame.size.width - iconWidth
            self.imageEdgeInsets = .init(top: 0, left: textWidth, bottom: 0, right: 0)
            self.titleEdgeInsets = .init(top: 0, left: -iconWidth, bottom: 0, right: iconWidth)
        }
        
        let half = spacing / 2
        contentEdgeInsets = .init(top: 0, left: half, bottom: 0, right: half)
        imageEdgeInsets = .init(top: 0, left: -half, bottom: 0, right: half)
        titleEdgeInsets = .init(top: 0, left: half, bottom: 0, right: -half)
    }
       
    private func createIconImage(isSelected: Bool) -> UIImage? {
        let defaultColor = isSelected ? titleColor(for: .selected) ?? .black : titleColor(for: .normal) ?? .black
        let iconColor = iconConfiguration.iconColor ?? defaultColor
        let indicatorColor = iconConfiguration.indicatorColor ?? defaultColor
    
        let size = CGSize(width: iconConfiguration.iconSize, height: iconConfiguration.iconSize)
        let iconRect = CGRect(x: iconConfiguration.iconStrokeWidth / 2, y: iconConfiguration.iconStrokeWidth / 2, width: iconConfiguration.iconSize - iconConfiguration.iconStrokeWidth, height: iconConfiguration.iconSize - iconConfiguration.iconStrokeWidth)
        let indicatorRect = CGRect(x: (iconConfiguration.iconSize - iconConfiguration.indicatorSize) / 2, y: (iconConfiguration.iconSize - iconConfiguration.indicatorSize) / 2, width: iconConfiguration.indicatorSize, height: iconConfiguration.indicatorSize)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let isRound = iconConfiguration.iconStyle == .round
        let iconPath: UIBezierPath = isRound ? UIBezierPath(ovalIn: iconRect) : UIBezierPath(rect: iconRect)
        iconPath.lineWidth = iconConfiguration.iconStrokeWidth
        iconColor.setStroke()
        iconPath.stroke()
        
        if isSelected {
            let indicatorPath = isRound ? UIBezierPath(ovalIn: indicatorRect) : UIBezierPath(rect: indicatorRect)
            indicatorColor.setFill()
            indicatorPath.fill()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image?.accessibilityIdentifier = RadioButton.accessibilityIdentifier
        return image
    }
}
