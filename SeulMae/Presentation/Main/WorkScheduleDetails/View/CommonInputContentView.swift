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
        var onChange: ((String) -> Void)?
        
        func makeContentView() -> UIView & UIContentView {
            return CommonInputContentView(self)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        let spacing = UIView()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.font = .pretendard(size: 14, weight: .semibold)
        textField.textColor = .label
        textField.backgroundColor = UIColor(hexCode: "F8F7F5", alpha: 1.0)
        textField.layer.cornerRadius = 12
        textField.layer.cornerCurve = .continuous
        return textField
    }()
    
    var onChange: ((String) -> Void)?
    
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
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let contentStack = UIStackView()
        contentStack.spacing = 4.0
        contentStack.distribution = .equalCentering
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(textField)
        
        addSubview(contentStack)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            textField.widthAnchor.constraint(equalToConstant: 160),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        onChange?(textField.text ?? "")
    }
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        titleLabel.text = config.title
        textField.text = config.text
        onChange = config.onChange
    }
}

extension UICollectionViewCell {
    func commonInputContentConfiguration() -> CommonInputContentView.Configuration {
        return CommonInputContentView.Configuration()
    }
}
