//
//  PlaceInfoDetailsContentView.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import UIKit
import Kingfisher

class PlaceInfoDetailsContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var workplace: Workplace?
        var memberList: [Member]?

        func makeContentView() -> UIView & UIContentView {
            return PlaceInfoDetailsContentView(self)
        }
    }
    
    // MARK: - UI Properties
    
    private let placeInfoView = PlaceInfoView()
    private let memberStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 12
        return stack
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

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 12
        [placeInfoView, memberStackView]
            .forEach(contentStack.addArrangedSubview(_:))

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let insets = CGFloat(20)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: insets),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets),
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
        placeInfoView.updateInfo(config.workplace)
        updateMemberList(members: config.memberList ?? [])
        memberStackView.addArrangedSubview(UIView())
    }

    private func updateMemberList(members: [Member]) {
        memberStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        members.map(createMemberView(_:))
            .forEach(memberStackView.addArrangedSubview(_:))
        let spacer = UIView()
        memberStackView.addArrangedSubview(spacer)
    }

    private func createMemberView(_ member: Member) -> UIView {
        let memberStack = UIStackView()
        memberStack.axis = .vertical
        memberStack.spacing = 4.0
        let imageView = UIImageView.user()
        let nameLabel = UILabel.common(title: member.name, size: 14, weight: .medium)
        [imageView, nameLabel]
            .forEach(memberStack.addArrangedSubview(_:))
        return memberStack
    }
}
