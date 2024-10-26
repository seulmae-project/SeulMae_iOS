//
//  MemberEmptyView.swift
//  SeulMae
//
//  Created by 조기열 on 10/25/24.
//

import UIKit

class MemberEmptyView: UIView {
    let iconImageView: UIImageView = Ext.image(.person, width: 36, height: 36)
    let messageLabel: UILabel = Ext.common("등록 된 근무자가 없습니다", 
                                           font: .pretendard(size: 14, weight: .semibold),
                                           textColor:  UIColor(hexCode: "BCC7DD"))
    let inviteMemberButton: UIButton = Ext.small(title: "+ 근무자 초대")

    convenience init() {
        self.init(frame: .zero)

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 8.0
        [iconImageView, messageLabel, inviteMemberButton]
            .forEach(contentStack.addArrangedSubview(_:))

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let insets = CGFloat(20)
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -insets * 3),
        ])
    }
}
