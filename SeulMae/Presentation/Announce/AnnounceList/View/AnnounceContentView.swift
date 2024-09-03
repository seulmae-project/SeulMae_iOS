//
//  AnnounceContentView.swift
//  SeulMae
//
//  Created by 조기열 on 7/22/24.
//

import UIKit
import Kingfisher

final class AnnounceContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var announceType: String? = ""
        var title: String? = ""
        var createdDate: Date? = Date()
        
        func makeContentView() -> UIView & UIContentView {
            return AnnounceContentView(self)
        }
    }
    
    private let announceTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 15, weight: .bold)
        label.textColor = .blue
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 15, weight: .bold)
        return label
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 11, weight: .regular)
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("버튼", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
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
        
        let titleStack = UIStackView()
        titleStack.alignment = .center
        titleStack.spacing = 4.0
        
        titleStack.addArrangedSubview(announceTypeLabel)
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(moreButton)
        
        titleLabel.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        
        let body = UIView()
        // body

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 4.0
        contentStack.directionalLayoutMargins = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        contentStack.isLayoutMarginsRelativeArrangement = true
        
        contentStack.addArrangedSubview(titleStack)
        contentStack.addArrangedSubview(body)
        contentStack.addArrangedSubview(createdDateLabel)
        
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        announceTypeLabel.text = config.announceType
        titleLabel.text = config.title
        if let date = config.createdDate {
            createdDateLabel.text = dateFormatter.string(from: date)
        }
    }
}

