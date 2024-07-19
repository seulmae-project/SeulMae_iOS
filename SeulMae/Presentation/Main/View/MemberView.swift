//
//  MemberView.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import UIKit
import Kingfisher

final class MemberView: UIView {
    
    var member: Member? {
        didSet {
            guard let member else { return }
            if let imageURL = URL(string: member.imageURL) {
                memberImageView.kf.setImage(with: imageURL, options: [
                    .onFailureImage(UIImage(systemName: "circle.fill"))
                ])
            }
            iconImageView.isHidden = !(member.isManager)
        }
    }
    
    // MARK: - UI Properties
    
    private let memberImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8.0
        imageView.layer.cornerCurve = .continuous
        return imageView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8.0
        imageView.layer.cornerCurve = .continuous
        return imageView
    }()
    
    // MARK: Life Cycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(memberImageView)
        NSLayoutConstraint.activate([
            memberImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            memberImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            memberImageView.topAnchor.constraint(equalTo: topAnchor),
            memberImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(iconImageView)
        let inset = 4.0
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: memberImageView.leadingAnchor, constant: -inset),
            iconImageView.topAnchor.constraint(equalTo: memberImageView.topAnchor, constant: -inset)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func apply(config: UIContentConfiguration) {
        
    }
    
    private func setupInternalViews() {
        
    }
}
