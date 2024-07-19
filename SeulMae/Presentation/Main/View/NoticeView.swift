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
            Swift.print("Did change title to \(title)")
            DispatchQueue.main.async {
                self.titleLabel.text = self.title
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
