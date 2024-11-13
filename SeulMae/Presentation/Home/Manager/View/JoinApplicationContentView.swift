//
//  JoinApplicationContentView.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import UIKit
import Kingfisher

final class JoinApplicationContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var application: JoinApplication?

        func makeContentView() -> UIView & UIContentView {
            return JoinApplicationContentView(self)
        }
    }

    private let approvalLabel: UILabel = .ext
        .common("가입 완료", font: .pretendard(size: 14, weight: .bold), textColor: .white)
    private let userImageView = UIImageView.ext.user()
    private let usernameLabel = UILabel.ext.config(font: .pretendard(size: 14, weight: .medium))

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
        backgroundColor = .ext.hex("F2F5FF")
        ext.round(radius: 8.0)

        approvalLabel.textAlignment = .center
        let bubbled = approvalLabel.ext
            .padding(leading: 8.0, trailing: -8.0, top: 4.0, bottom: -4.0)
            .ext.round(radius: 4.0)

        bubbled.backgroundColor = .ext.hex("64C591")
        [bubbled, userImageView, usernameLabel]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

        let insets = CGFloat(4.0)
        NSLayoutConstraint.activate([
            bubbled.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            bubbled.centerXAnchor.constraint(equalTo: centerXAnchor),
            bubbled.topAnchor.constraint(equalTo: topAnchor, constant: insets),
            
            userImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            userImageView.topAnchor.constraint(equalTo: bubbled.bottomAnchor, constant: 10.5),

            usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 8.0),
            usernameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11.5),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        // userImageView
        usernameLabel.text = config.application?.username
    }
}

