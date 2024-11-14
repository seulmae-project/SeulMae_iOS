//
//  UIButton+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/24/24.
//

import UIKit
import RxSwift
import RxCocoa

extension Ext where ExtendedType == UIButton {
  static func config(font: UIFont, color: UIColor = .label) -> UIButton {
    let button = UIButton()
    button.titleLabel?.font = font
    button.setTitleColor(color, for: .normal)
    return button
  }
  
  static func image(_ image: UIImage) -> UIButton {
    let button = UIButton()
    button.setImage(image, for: .normal)
    button.contentVerticalAlignment = .fill
    button.contentHorizontalAlignment = .fill
    button.adjustsImageWhenHighlighted = false
    return button
  }
  
  static func common(title: String) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = .pretendard(size: 16, weight: .bold)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = UIColor(hexCode: "4C71F5")
    button.layer.cornerRadius = 8.0
    button.layer.cornerCurve = .continuous
    button.heightAnchor.constraint(equalToConstant: 52).isActive = true
    return button
  }
  
  static func text(_ title: String) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(.label, for: .normal)
    return button
  }
  
  @discardableResult
  func title(_ title: String) -> ExtendedType {
    type.setTitle(title, for: .normal)
    return type
  }

  @discardableResult
  func textColor(_ color: UIColor) -> ExtendedType {
    type.setTitleColor(color, for: .normal)
    return type
  }

  @discardableResult
  func font(_ font: UIFont) -> ExtendedType {
    type.titleLabel?.font = font
    return type
  }
  
  @discardableResult
  func withImage(
    _ image: UIImage,
    spacing: CGFloat? = nil,
    direction: UISemanticContentAttribute = .forceRightToLeft
  ) -> ExtendedType {
    type.setImage(image, for: .normal)
    type.adjustsImageWhenHighlighted = false
    if let spacing {
      let half = (spacing / 2)
      type.contentEdgeInsets = .init(top: 0, left: half, bottom: 0, right: half)
      if direction == .forceRightToLeft {
        type.imageEdgeInsets = .init(top: 0, left: half, bottom: 0, right: -half)
        type.titleEdgeInsets = .init(top: 0, left: -half, bottom: 0, right: half)
      } else {
        type.imageEdgeInsets = .init(top: 0, left: -half, bottom: 0, right: half)
        type.titleEdgeInsets = .init(top: 0, left: half, bottom: 0, right: -half)
      }
    }
    type.semanticContentAttribute = direction
    return type
  }
  
  @discardableResult
  func config(textColor: UIColor, backgroundColor: UIColor) -> UIButton {
    type.setTitleColor(textColor, for: .normal)
    type.backgroundColor = backgroundColor
    return type
  }
  
  static func small(title: String, font: UIFont = .pretendard(size: 16, weight: .bold)) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = font
    button.setTitleColor(UIColor(hexCode: "4C71F5"), for: .normal)
    button.backgroundColor = UIColor(hexCode: "F2F5FF")
    button.layer.cornerRadius = 8.0
    button.layer.cornerCurve = .continuous
    let insets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    button.contentEdgeInsets = insets
    return button
  }
  
  
  
  // will delete
  func setEnabled(_ isEnabled: Bool) {
    type.isEnabled = isEnabled
    type.backgroundColor = isEnabled ? .primary : .cloudy
    type.setTitleColor(isEnabled ? .cloudy : .graphite, for: .normal)
  }
  
  // MARK: - RxCocoa Binder
  
  var isEnabled: Binder<Bool> {
    Binder<Bool>(type, binding: { button, isEnabled in
      button.isEnabled = isEnabled
      button.backgroundColor = isEnabled ? .primary : .cloudy
      button.setTitleColor(isEnabled ? .cloudy : .graphite, for: .normal)
    })
  }
}
