//
//  NoticeView.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import UIKit

final class NoticeView: UIView {
    
    var titleLabel = UILabel()
    
    var title: String = "" {
        didSet {
            titleLabel.text = self.title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .border
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .natural
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
        self.addSubview(titleLabel)
        
        let inset: CGFloat = 16
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: inset),
            titleLabel.topAnchor.constraint(lessThanOrEqualTo: topAnchor, constant: inset),
            titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -inset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -inset),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
