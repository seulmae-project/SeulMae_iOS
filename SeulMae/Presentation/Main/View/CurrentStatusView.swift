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
        let l = UILabel()
        l.textColor = .black
        l.text = "금일의\n근무를 확인해주세요"
        l.numberOfLines = 2
        l.font = .systemFont(ofSize: 24, weight: .bold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let progressLabel: UILabel = {
        let l = UILabel()
        l.text = "미완료"
        l.font = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .primary
        return l
    }()
    
    private let progressCountLabel: UILabel = {
        let l = UILabel()
        l.text = "1개"
        l.font = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .primary
        return l
    }()
    
    private let completedLabel: UILabel = {
        let l = UILabel()
        l.text = "완료"
        l.font = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .white
        return l
    }()
    
    private let completedCountLabel: UILabel = {
        let l = UILabel()
        l.text = "2개"
        l.font = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .primary
        return l
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
