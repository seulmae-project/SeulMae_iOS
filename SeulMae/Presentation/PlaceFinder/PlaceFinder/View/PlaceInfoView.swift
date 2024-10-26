//
//  PlaceInfoView.swift
//  SeulMae
//
//  Created by 조기열 on 10/26/24.
//

import UIKit

class PlaceInfoView: UIView {
    private let _pendingimageView: UIImageView = Ext.image(.placeFinderPending, width: 54, height: 20)
    private let imageView: UIImageView = Ext.config(width: 84, height: 64, cornerRadius: 4.0)
    private let nameLabel: UILabel = .common(size: 20, weight: .semibold)
    private let addressLabel: UILabel = .common(size: 12, weight: .regular, color: UIColor(hexCode: "BDBEC0"))
    private let managerNameLabel: UILabel = .common(size: 12, weight: .regular, color: UIColor(hexCode: "4C71F5"))
    private let phoneIconImageView: UIImageView = Ext.image(.placeFinderPhone, width: 13, height: 13)
    private let contactLabel: UILabel = .common(size: 12, weight: .regular, color: UIColor(hexCode: "636872"))

    convenience init() {
        self.init(frame: .zero)

        let descriptionStack = UIStackView()
        descriptionStack.spacing = 8.0
        [managerNameLabel, phoneIconImageView, contactLabel]
            .forEach(descriptionStack.addArrangedSubview(_:))

        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.spacing = 6.0
        labelStack.alignment = .leading
        [nameLabel, descriptionStack] // addressLabel
            .forEach(labelStack.addArrangedSubview(_:))

        let contentStack = UIStackView()
        contentStack.spacing = 12
        contentStack.alignment = .center
        [imageView, labelStack]
            .forEach(contentStack.addArrangedSubview(_:))
        
        [contentStack, _pendingimageView]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

        let insets = CGFloat(0)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: insets),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets),

            _pendingimageView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            _pendingimageView.topAnchor.constraint(equalTo: imageView.topAnchor)
        ])
    }
    
    func updateInfo(_ workplace: Workplace?, isShowPending: Bool = false) {
        nameLabel.text = workplace?.name
        managerNameLabel.text = workplace?.manager
        contactLabel.text = workplace?.contact
        addressLabel.text = "\(workplace?.mainAddress ?? "") \(workplace?.subAddress ?? "")"
        _pendingimageView.isHidden = !isShowPending
    }
}
