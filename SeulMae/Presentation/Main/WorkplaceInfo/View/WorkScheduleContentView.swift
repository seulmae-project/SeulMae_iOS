//
//  WorkScheduleContentView.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import UIKit

final class WorkScheduleContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var workSchedule: WorkSchedule?
        
        func makeContentView() -> UIView & UIContentView {
            return WorkScheduleContentView(self)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .natural
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .natural
        return label
    }()
    
    private let memberCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .natural
        return label
    }()
    
    private let weekdayStackView: UIStackView = {
        let stack = UIStackView()
        
        return stack
    }()
    
    private let memberStackView: UIStackView = {
        let stack = UIStackView()
        
        return stack
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
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4.0
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(timeLabel)
        
        let stack2 = UIStackView()
        stack.distribution = .equalCentering
        stack.addArrangedSubview(stack)
        stack.addArrangedSubview(memberCountLabel)
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 4.0
        contentStack.addArrangedSubview(stack2)
        contentStack.addArrangedSubview(weekdayStackView)
        contentStack.addArrangedSubview(memberStackView)
        
        addSubview(contentStack)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        // config.workSchedule
    }
}

extension UICollectionViewCell {
    func workScheduleContentConfiguration() -> WorkScheduleContentView.Configuration {
        return WorkScheduleContentView.Configuration()
    }
}
