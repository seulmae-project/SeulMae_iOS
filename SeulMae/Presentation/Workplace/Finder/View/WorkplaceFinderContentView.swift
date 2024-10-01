//
//  WorkplaceFinderContentView.swift
//  SeulMae
//
//  Created by 조기열 on 10/1/24.
//

import UIKit

final class WorkplaceFinderContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var onFind: (() -> Void)?
        var onCreate: (() -> Void)?
        
        func makeContentView() -> UIView & UIContentView {
            return WorkplaceFinderContentView(self)
        }
    }
        
    private let _descriptionLabel: UILabel = .common(title: "참여하거나 새로운 근무지를 만들어요", size: 16, weight: .regular, color: .secondaryLabel)
    private let _titleLabel: UILabel = .common(title: "근무지 참여하기", size: 24, weight: .semibold)
    // private let searchWorkplaceButton: UIView = BigButton
    // private let createWorkplaceButton: UIView = BigButton
            
    var configuration: UIContentConfiguration {
        didSet {
            apply(config: configuration)
        }
    }
                
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.spacing = 4.0
        let labels = [_descriptionLabel, _titleLabel]
        labels.forEach(labelStack.addArrangedSubview(_:))
        
        let buttonStack = UIStackView()
        buttonStack.spacing = 12
        // let buttons = []
        // buttons.forEach(buttonStack.addArrangedSubview(_:))
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 20
        let contents = [labelStack, buttonStack]
        contents.forEach(contentStack.addArrangedSubview(_:))
        
        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        let inset = CGFloat(20)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: inset),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: inset),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        
    }
}
