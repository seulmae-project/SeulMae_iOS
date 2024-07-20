//
//  MemberProfileView.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import UIKit
import Kingfisher

final class MemberProfileView: UIView {

    private let memberImageView: UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 64).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 64).isActive = true
        iv.layer.cornerRadius = 32
        iv.layer.cornerCurve = .continuous
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        return l
    }()
    
    private let joinDateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        return l
    }()
    
    private let contactButton: UIButton = {
        let b = UIButton()
        
        return b
    }()
    
    var imageURL: String? {
        didSet {
            if let urlStr = imageURL,
               let imageURL = URL(string: urlStr) {
                memberImageView.kf.setImage(with: imageURL, options: [
                    .onFailureImage(UIImage(systemName: "circle.fill"))
                ])
            }
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var joinDate: Date? {
        didSet {
            joinDateLabel.text = joinDate?.description
        }
    }
    
    var phoneNumber: String? {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0
        
        let labelStack = UIStackView(arrangedSubviews: [
            nameLabel, joinDateLabel
        ])
        labelStack.axis = .vertical
        labelStack.spacing = 4.0
        
        addSubview(memberImageView)
        addSubview(labelStack)
        addSubview(contactButton)
        
        let inset: CGFloat = 14
        
        NSLayoutConstraint.activate([
            memberImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            memberImageView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            memberImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: inset),
            
            labelStack.leadingAnchor.constraint(equalTo: memberImageView.trailingAnchor, constant: inset),
            labelStack.centerYAnchor.constraint(equalTo: memberImageView.centerYAnchor),
            labelStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
            
            // TODO: 연락하기 버튼 디자인, 레이아웃, 로직
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
