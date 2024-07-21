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
        iv.layer.cornerRadius = 32
        iv.layer.cornerCurve = .continuous
        iv.image = .userProfile
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.textColor = .label
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.text = "name"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let joinDateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .label
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.text = "join_date"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let contactButton: UIButton = {
        let b = UIButton()
        
        b.translatesAutoresizingMaskIntoConstraints = false
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
        layer.borderColor = UIColor.border.cgColor
        layer.borderWidth = 1.0
        
        let labelStack = UIStackView(arrangedSubviews: [
            nameLabel, joinDateLabel
        ])
        labelStack.axis = .vertical
        labelStack.spacing = 4.0
        labelStack.alignment = .leading
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(memberImageView)
        addSubview(labelStack)
        // addSubview(contactButton)
        
        let inset: CGFloat = 16
        
        NSLayoutConstraint.activate([
            memberImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            memberImageView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            memberImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            memberImageView.widthAnchor.constraint(equalToConstant: 64),
            memberImageView.heightAnchor.constraint(equalToConstant: 64),
            
            labelStack.leadingAnchor.constraint(equalTo: memberImageView.trailingAnchor, constant: inset),
            labelStack.centerYAnchor.constraint(equalTo: memberImageView.centerYAnchor),
            labelStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            // TODO: 연락하기 버튼 디자인, 레이아웃, 로직
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
