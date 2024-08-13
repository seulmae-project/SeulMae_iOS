//
//  WorkplaceContentView.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import UIKit

class WorkplaceContentView: UIView, UIContentView {
    
    // MARK: Internal Types
    
    struct Configuration: UIContentConfiguration {
        var workplaceName: String = ""
        var workplaceAddress: String = ""
        var workplaceContact: String = ""
        var workplaceMananger: String = ""
        
        func makeContentView() -> UIView & UIContentView {
            return WorkplaceContentView(self)
        }
    }
    
    // MARK: - UI Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.layer.cornerCurve = .continuous
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)

        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let managerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .secondaryLabel
        return label
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
        
        backgroundColor = .lightPrimary
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 4.0
        
        addSubview(imageView)
        addSubview(contentStack)
        addSubview(managerLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        managerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            imageView.heightAnchor.constraint(equalToConstant: 56),
            imageView.widthAnchor.constraint(equalToConstant: 56),
            
            contentStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            managerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            managerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    // MARK: - Configuration Methods
        
    func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        Swift.print(#function)
        // imageView = config.imageURL
        nameLabel.text = config.workplaceName
        descriptionLabel.text = config.workplaceAddress + config.workplaceContact
        managerLabel.text = config.workplaceMananger
    }
}
