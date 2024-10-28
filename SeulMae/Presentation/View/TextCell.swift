//
//  TextCell.swift
//  SeulMae
//
//  Created by 조기열 on 7/22/24.
//

import UIKit

class TextCell: UICollectionViewCell {
    
    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        contentView.addSubview(label)
        let insets = CGFloat(16)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: (insets * 3/4)),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(insets * 3/4))
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
