//
//  CommonInputContentView.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import UIKit

final class CommonInputContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var title: String = ""
        var text: String = ""
        
        func makeContentView() -> UIView & UIContentView {
            return WorkScheduleContentView(self)
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = .pretendard(size: 14, weight: .semibold)
        textField.textColor = .label
        textField.backgroundColor = UIColor(hexCode: "F8F7F5", alpha: 1.0)
        textField.layer.cornerRadius = 12
        textField.layer.cornerCurve = .continuous
        return textField
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
        
        let contentStack = UIStackView()
        contentStack.spacing = 4.0
        contentStack.distribution = .equalCentering
        contentStack.addArrangedSubview(label)
        contentStack.addArrangedSubview(textField)
        
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
        label.text = config.title
        textField.text = config.text
    }
}

extension UICollectionViewCell {
    func commonInputContentConfiguration() -> CommonInputContentView.Configuration {
        return CommonInputContentView.Configuration()
    }
}
