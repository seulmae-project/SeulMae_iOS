//
//  LeftScheduleView.swift
//  SeulMae
//
//  Created by 조기열 on 9/28/24.
//

import UIKit

final class LeftScheduleView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .pretendard(size: 18, weight: .regular)
        return label
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
