//
//  AnnouncementContentView.swift
//  SeulMae
//
//  Created by 조기열 on 7/22/24.
//

import UIKit
import Kingfisher

final class AnnouncementContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var icon: UIImage?
        var title: String?
        var body: String?
        
        func makeContentView() -> UIView & UIContentView {
            return AnnouncementContentView(self)
        }
    }
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 22
        iv.layer.cornerCurve = .continuous
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        return l
    }()
    
    private let bodyLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 16)
        return l
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
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(bodyLabel)
        
        let inset = 8.0
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 44),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: inset * 2.0),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: inset),
            
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: inset * 2.0),
            bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            bodyLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -inset * 2.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        iconImageView.image = config.icon
        titleLabel.text = config.title
        bodyLabel.text = config.body
    }
}

