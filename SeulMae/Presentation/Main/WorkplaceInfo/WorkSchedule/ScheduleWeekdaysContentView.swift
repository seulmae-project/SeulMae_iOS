//
//  ScheduleWeekdaysContentView.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import UIKit

final class ScheduleWeekdaysContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var title: String = ""
        var weekdays: [Int] = []
        
        func makeContentView() -> UIView & UIContentView {
            return WorkScheduleContentView(self)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let weekdayStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4.0
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var weekdays = [
        "월", "화", "수", "목", "금", "토", "일"
    ]
    
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
        
        weekdays.forEach { weekday in
            let button = createWeekday(weekday)
            weekdayStack.addArrangedSubview(button)
        }
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 4.0
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(weekdayStack)
        
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
    
    // MARK: - Private
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration,
              let buttons = weekdayStack.subviews as? [UIButton] else { return }
        buttons.forEach { $0.isSelected = false }
        config.weekdays.forEach { weekday in
            var index = (weekday - 1)
            if (index == -1) { index = 6 }
            buttons[index].isSelected = true
        }
    }
    
    private func createWeekday(_ weekday: String) -> UIButton {
        let button = UIButton()
        button.setTitle(weekday, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weight: .bold)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.primary, for: .normal)
        button.backgroundColor = .lightPrimary
        button.layer.cornerRadius = 22
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }
    
    private func applyWeekdayOnOff(_ weekdays: [Int]) {

    }
}

extension UICollectionViewCell {
    func scheduleWeekdaysContentConfiguration() -> ScheduleWeekdaysContentView.Configuration {
        return ScheduleWeekdaysContentView.Configuration()
    }
}
