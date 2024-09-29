//
//  WorkplaceContentView.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import UIKit
import Kingfisher

class WorkplaceContentView: UIView, UIContentView {
    
    // MARK: Internal Types
    
    struct Configuration: UIContentConfiguration {
        var imageUrl: String = ""
        var name: String = ""
        var mainAddress: String = ""
        var contact: String = ""
        var manager: String = ""
        var showsSeparator: Bool = true
        
        func makeContentView() -> UIView & UIContentView {
            return WorkplaceContentView(self)
        }
    }
    
    // MARK: - UI Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4.0
        imageView.layer.cornerCurve = .continuous
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(hexCode: "EEEEEE")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "EEEEEE")
        return view
    }()
    
    // MARK: - Properties
        
    var configuration: UIContentConfiguration {
        didSet {
            apply(config: configuration)
        }
    }
    
    // MARK: Life Cycle Methods
            
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(separatorView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let inset = CGFloat(20)
        NSLayoutConstraint.activate([
            // imageView
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            imageView.heightAnchor.constraint(equalToConstant: 56),
            imageView.widthAnchor.constraint(equalToConstant: 84),
            
            // nameLabel
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: inset),
            nameLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            
            // descriptionLabel
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            
            // separatorView
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    // MARK: - Configuration Methods
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        if let imageURL = URL(string: config.imageUrl) {
            imageView.kf.setImage(
                with: imageURL,
                options: [
                   .onFailureImage(UIImage(systemName: "circle.fill")),
                   .cacheOriginalImage
               ])
        }
        nameLabel.ext
            .setText(config.name, size: 16, weight: .regular)
        descriptionLabel.ext
            .setText(config.mainAddress, size: 14, weight: .regular)
        separatorView.isHidden = !config.showsSeparator
    }
}
