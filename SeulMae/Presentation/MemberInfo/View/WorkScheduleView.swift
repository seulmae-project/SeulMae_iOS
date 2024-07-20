//
//  WorkScheduleVIew.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import UIKit

final class WorkScheduleView: UIView {
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let activeStateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.backgroundColor = .red
        l.font = .systemFont(ofSize: 12)
        l.layer.cornerRadius = 24
        l.layer.cornerCurve = .continuous
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let weekdayStack: UIStackView = {
        let s = UIStackView()
        s.spacing = 12
        s.distribution = .equalSpacing
        return s
    }()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isActive: Bool = false {
        didSet {
            activeStateLabel.textColor = isActive ? .white : .white
            activeStateLabel.backgroundColor = isActive ? .red : .gray
        }
    }
    
    var weekdays: [Int] = [] {
        didSet {
            for i in 1...7 {
                weekdayStack.addArrangedSubview(
                    createWeekdayLabel(isActive: weekdays.contains(i))
                )
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(titleLabel)
        addSubview(activeStateLabel)
        addSubview(weekdayStack)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            activeStateLabel.topAnchor.constraint(equalTo: topAnchor),
            activeStateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekdayStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            weekdayStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            weekdayStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            weekdayStack.trailingAnchor.constraint(equalTo: activeStateLabel.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createWeekdayLabel(isActive: Bool) -> UILabel {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16)
        l.textColor = isActive ? .white : .systemGray2
        l.backgroundColor = isActive ? .black : .systemGray5
        l.heightAnchor.constraint(equalToConstant: 36).isActive = true
        l.widthAnchor.constraint(equalToConstant: 36).isActive = true
        l.layer.cornerRadius = 18
        l.layer.cornerCurve = .continuous
        return l
    }
}
