//
//  MemberContentView.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import UIKit
import Kingfisher

final class MemberContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var member: Member?
        
        func makeContentView() -> UIView & UIContentView {
            return MemberContentView(self)
        }
    }
    
    private let memberImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .userProfile
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.layer.cornerCurve = .continuous
        return iv
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .star
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var configuration: UIContentConfiguration {
        didSet {
            apply(config: configuration)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
        
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        addSubview(memberImageView)
        addSubview(iconImageView)
        
        let inset = 4.0
        NSLayoutConstraint.activate([
            memberImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            memberImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            memberImageView.topAnchor.constraint(equalTo: topAnchor),
            memberImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            memberImageView.heightAnchor.constraint(equalToConstant: 40),
            memberImageView.widthAnchor.constraint(equalToConstant: 40),
            
            iconImageView.leadingAnchor.constraint(equalTo: memberImageView.leadingAnchor, constant: -inset),
            iconImageView.topAnchor.constraint(equalTo: memberImageView.topAnchor, constant: -inset),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        //            if let imageURL = URL(string: member.imageURL) {
        //                memberImageView.kf.setImage(with: imageURL, options: [
        //                    .onFailureImage(UIImage(systemName: "circle.fill"))
        //                ])
        //            }
        iconImageView.isHidden = !(config.member?.isManager ?? false)
    }
}

