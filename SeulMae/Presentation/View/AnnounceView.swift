//
//  AnnounceView.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import UIKit

final class AnnounceView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .natural
        return label
    }()
    
    var title: String = "" {
        didSet {
            titleLabel.text = self.title
        }
    }
    var announceId: Announce.ID = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .border
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
    
        self.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(lessThanOrEqualTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
