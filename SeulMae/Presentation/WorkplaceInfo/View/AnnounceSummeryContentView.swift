//
//  AnnounceSummeryContentView.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import UIKit

final class AnnounceSummeryContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var announce: Announce?
        
        func makeContentView() -> UIView & UIContentView {
            return AnnounceSummeryContentView(self)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .natural
        return label
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
      
        backgroundColor = .border
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous

        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        titleLabel.text = config.announce?.title
    }
}

extension UICollectionViewCell {
    func announceSummeryContentConfiguration() -> AnnounceSummeryContentView.Configuration {
        return AnnounceSummeryContentView.Configuration()
    }
}
