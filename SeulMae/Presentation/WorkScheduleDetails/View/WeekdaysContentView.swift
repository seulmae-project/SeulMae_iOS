//
//  WeekdaysContentView.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import UIKit

final class WeekdaysContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var title: String = ""
        var weekdays: [Int] = []
        var onChange: (([Int]) -> Void)?
        
        func makeContentView() -> UIView & UIContentView {
            return WeekdaysContentView(self)
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
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private var weekdays = [
        "일", "월", "화", "수", "목", "금", "토"
    ]
    
    private var _weekdays: [Int] {
        var retval: [Int] = []
        guard let buttons = weekdayStack.subviews as? [UIButton] else {
            return []
        }

        for (index, button) in buttons.enumerated() {
            if button.isSelected {
                retval.append(index)
            }
        }
        
        return retval
    }
    
    private var onChange: (([Int]) -> Void)?
    
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
            let button = createWeekdayButton(weekday)
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
            
            weekdayStack.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    @objc private func didButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.backgroundColor = sender.isSelected ? .primary : .lightPrimary
        onChange?(_weekdays)
    }
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration,
              let buttons = weekdayStack.subviews as? [UIButton] else { return }
        titleLabel.text = config.title
        buttons.forEach { $0.isSelected = false }
        config.weekdays.forEach { index in
            buttons[index].isSelected = true
            buttons[index].backgroundColor = .primary
        }
        onChange = config.onChange
    }
    
    private func createWeekdayButton(_ weekday: String) -> UIButton {
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
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }
}

extension UICollectionViewCell {
    func weekdaysContentConfiguration() -> WeekdaysContentView.Configuration {
        return WeekdaysContentView.Configuration()
    }
}
