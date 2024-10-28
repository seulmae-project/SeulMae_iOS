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
        label.text = "title"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.textAlignment = .natural
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "time"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .natural
        return label
    }()
    
    private let memberCountLabel: UILabel = {
        let label = UILabel()
        label.text = "2명"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .natural
        return label
    }()
    
    private let weekdayStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 4.0
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
        stack2.distribution = .equalCentering
        stack2.addArrangedSubview(stack)
        stack2.addArrangedSubview(memberCountLabel)
        
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
            
            weekdayStackView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let weekdays = [
        "일", "월", "화", "수", "목", "금", "토"
    ]
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        Swift.print("title: \(config.workSchedule?.title ?? "" )")
        titleLabel.text = config.workSchedule?.title
        timeLabel.text = (config.workSchedule?.startTime ?? "") + " ~ " + (config.workSchedule?.endTime ?? "")
        weekdayStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        config.workSchedule?.days.forEach {
            let label = UILabel()
            label.text = weekdays[$0]
            label.font = .pretendard(size: 16, weight: .bold)
            label.textAlignment = .center
            label.textColor = .primary
            label.backgroundColor = .lightPrimary
            label.layer.cornerRadius = 22
            label.layer.cornerCurve = .continuous
            label.layer.masksToBounds = true
            label.widthAnchor.constraint(equalToConstant: 44).isActive = true
            weekdayStackView.addArrangedSubview(label)
        }
        weekdayStackView.addArrangedSubview(UIView())
    }
}

extension UICollectionViewCell {
    func workScheduleContentConfiguration() -> WorkScheduleContentView.Configuration {
        return WorkScheduleContentView.Configuration()
    }
}
