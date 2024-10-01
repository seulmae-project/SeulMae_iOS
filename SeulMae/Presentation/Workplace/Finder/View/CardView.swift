//
//  CardView.swift
//  SeulMae
//
//  Created by 조기열 on 10/1/24.
//

import UIKit

class CardView: UIView {
    
    let iconImageView = UIImageView()
    let titlelabel = UILabel()
    let descriptionlabel = UILabel()
    
    convenience init(title: String, description: String, icon: UIImage, textColor: UIColor, backgroundColor: UIColor) {
        self.init(frame: .zero)
        
        iconImageView.image = icon
        titlelabel.ext.setText(title, size: 18, weight: .semibold, color: textColor)
        descriptionlabel.ext.setText(description, size: 14, weight: .regular, color: textColor)
        self.backgroundColor = backgroundColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8.0
        layer.cornerCurve = .continuous
        
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.spacing = 4.0
        let labels = [titlelabel, descriptionlabel]
        labels.forEach(labelStack.addArrangedSubview(_:))
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.distribution = .equalCentering
        contentStack.alignment = .leading
        contentStack.directionalLayoutMargins = .init(top: 8.0, leading: 12, bottom: 8.0, trailing: 12)
        contentStack.isLayoutMarginsRelativeArrangement = true
        let contents = [iconImageView, labelStack]
        contents.forEach(contentStack.addArrangedSubview(_:))
        
        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
      
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
