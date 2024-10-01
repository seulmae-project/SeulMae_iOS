//
//  WorkplaceFinderContentView.swift
//  SeulMae
//
//  Created by 조기열 on 10/1/24.
//

import UIKit

final class WorkplaceFinderContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var onSearch: (() -> Void)?
        var onCreate: (() -> Void)?
        
        func makeContentView() -> UIView & UIContentView {
            return WorkplaceFinderContentView(self)
        }
    }
    
    private let searchWorkplaceButton: UIView = CardView(title: "참여할 근무지 검색하기", description: "블라블라", icon: .magnifyingGlass, textColor: .primary, backgroundColor: .lightPrimary)
    private let createWorkplaceButton: UIView = CardView(title: "근무지 만들기", description: "블라블라", icon: .flag, textColor: .white, backgroundColor: .primary)
    
    private var onSearch: (() -> Void)?
    private var onCreate: (() -> Void)?
            
    var configuration: UIContentConfiguration {
        didSet {
            apply(config: configuration)
        }
    }
                
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        searchWorkplaceButton.tag = 0
        createWorkplaceButton.tag = 1
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        searchWorkplaceButton.addGestureRecognizer(tapGesture)
        createWorkplaceButton.addGestureRecognizer(tapGesture)
        // self.isUserInteractionEnabled = true
        
        let contentStack = UIStackView()
        contentStack.axis = .horizontal
        contentStack.spacing = 12
        let contents = [searchWorkplaceButton, createWorkplaceButton]
        contents.forEach(contentStack.addArrangedSubview(_:))
        
        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        let inset = CGFloat(20)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            
            contentStack.heightAnchor.constraint(equalToConstant: 120),
            searchWorkplaceButton.widthAnchor.constraint(equalTo: createWorkplaceButton.widthAnchor, multiplier: 3.0 / 2.0),
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
        onSearch = config.onSearch
        onCreate = config.onCreate
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let isSearch = (gesture.view?.tag == 0)
        isSearch ? onSearch?() : onCreate?()
    }
}
