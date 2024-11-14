//
//  AttHistoriesSearchBar.swift
//  SeulMae
//
//  Created by 조기열 on 11/14/24.
//

import UIKit

class AttHistoriesSearchBar: UIView {

  let _iconImageView = UIImageView()
    .ext.size(width: 18, height: 18)
    .ext.image(.homeSearch)
  var paddedIcon: UIView!

  let optionButton = UIButton()
    .ext.font(.pretendard(size: 14, weight: .light))
    .ext.title("전체 · 최신순")
    .ext.withImage(.init(systemName: "chevron.down")!.withTintColor(.label, renderingMode: .alwaysOriginal), spacing: 8.0)
    .ext.textColor(.label)

  convenience init() {
    self.init(frame: .zero)

    onLoad()
  }

  override var intrinsicContentSize: CGSize {
    CGSize(width: 0, height: 56)
  }

  func onLoad() {
    backgroundColor = .ext.hex("F2F5FF")
    
    paddedIcon = _iconImageView
      .ext.padding(5)
      .ext.round(radius: 14)
      .ext.bg(.white)

    let contentStack = UIStackView()
    contentStack.alignment = .center
    contentStack.distribution = .equalCentering
    [paddedIcon, optionButton]
      .forEach(contentStack.addArrangedSubview(_:))

    addSubview(contentStack)
    contentStack.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 14),
      contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
    ])  
  }
}


