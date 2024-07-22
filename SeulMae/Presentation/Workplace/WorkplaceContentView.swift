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
        var placeName: String = ""
        var placeAddress: String = ""
        var placeTel: String = ""
        var placeMananger: String = ""
        
        func makeContentView() -> UIView & UIContentView {
            return WorkplaceContentView(self)
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
        setupInternalViews()
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
        // memberImageView. = config.imageURL
        // iconImageView.isHidden = !config.isManager
    }
    
    private func setupInternalViews() {
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
}
