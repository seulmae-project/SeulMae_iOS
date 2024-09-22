//
//  CurrentStatusView.swift
//  SeulMae
//
//  Created by 조기열 on 8/5/24.
//

import UIKit

extension UIView {
    func bubbled(
        color: UIColor,
        horizontal h: CGFloat = 8.0,
        vertical v: CGFloat = 4.0
    ) -> UIView {
        let bubble = UIStackView()
        bubble.backgroundColor = color
        bubble.addArrangedSubview(self)
        let insets = NSDirectionalEdgeInsets(top: v, leading: h, bottom: v, trailing: h)
        bubble.directionalLayoutMargins = insets
        bubble.isLayoutMarginsRelativeArrangement = true
        bubble.layer.cornerRadius = 8.0
        bubble.layer.cornerCurve = .continuous
        return bubble
    }
}

final class CurrentStatusView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "금일의\n근무를 확인해주세요"
        label.numberOfLines = 2
        // label.font = .pretendard(size: , weight: )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "미완료"
        // label.font = .pretendard(size: , weight: )
        label.textColor = .primary
        return label
    }()
    
    private let progressCountLabel: UILabel = {
        let label = UILabel()
        label.text = "1개"
        // label.font = .pretendard(size: , weight: )
        label.textColor = .primary
        return label
    }()
    
    private let completedLabel: UILabel = {
        let label = UILabel()
        label.text = "완료"
        // label.font = .pretendard(size: , weight: )
        label.textColor = .white
        return label
    }()
    
    private let completedCountLabel: UILabel = {
        let label = UILabel()
        label.text = "2개"
        // label.font = .pretendard(size: , weight: )
        label.textColor = .primary
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let progressStack = UIStackView(arrangedSubviews: [
            progressLabel.bubbled(color: .lightPrimary),
            progressCountLabel
        ])
        progressStack.axis = .vertical
        progressStack.spacing = 8.0
        progressStack.alignment = .center
        progressStack.translatesAutoresizingMaskIntoConstraints = false
        
        let completedStack = UIStackView(arrangedSubviews: [
            completedLabel.bubbled(color: .primary),
            completedCountLabel
        ])
        completedStack.axis = .vertical
        completedStack.spacing = 8.0
        completedStack.alignment = .center
        completedStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(progressStack)
        addSubview(completedStack)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: progressStack.leadingAnchor, constant: -16),
            
            progressStack.centerYAnchor.constraint(equalTo: completedStack.centerYAnchor),
            progressStack.trailingAnchor.constraint(equalTo: completedStack.leadingAnchor, constant: -16),
            
            completedStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            completedStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
