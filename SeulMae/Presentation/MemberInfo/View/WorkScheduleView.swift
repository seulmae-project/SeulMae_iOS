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
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "오전 파트 (9: 00 ~ 12: 00)"
        return l
    }()
    
    private let activeStateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = .systemFont(ofSize: 12)
        l.text = "활성화"
        return l
    }()
    
    private let activeStateBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .primary
        v.layer.cornerRadius = 8.0
        v.layer.cornerCurve = .continuous
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let weekdayStack: UIStackView = {
        let s = UIStackView()
        s.spacing = 12
        s.distribution = .equalSpacing
        s.translatesAutoresizingMaskIntoConstraints = false
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
                guard let weekdayView = weekdayStack.arrangedSubviews[i - 1] as? WeekdayView else { return }
                weekdayView.isActive = weekdays.contains(i)
            }
        }
    }
    
    private var _weekdays = [
        "월", "화", "수", "목", "금", "토", "일"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let activeStateBackground = UIStackView(arrangedSubviews: [activeStateLabel])
        activeStateBackground.backgroundColor = .primary
        activeStateBackground.layer.cornerRadius = 8.0
        activeStateBackground.layer.cornerCurve = .continuous
        activeStateBackground.translatesAutoresizingMaskIntoConstraints = false
        activeStateBackground.directionalLayoutMargins = .init(top: 4.0, leading: 8.0, bottom: 4.0, trailing: 8.0)
        activeStateBackground.isLayoutMarginsRelativeArrangement = true
        
        addSubview(titleLabel)
        addSubview(activeStateBackground)
        addSubview(weekdayStack)
        
        for i in 1...7 {
            let weekdayView = WeekdayView()
            weekdayView.weekday = _weekdays[i - 1]
            weekdayView.isActive = weekdays.contains(i)
            weekdayStack.addArrangedSubview(weekdayView)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            activeStateBackground.topAnchor.constraint(equalTo: topAnchor),
            activeStateBackground.trailingAnchor.constraint(equalTo: trailingAnchor),

            weekdayStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            weekdayStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            weekdayStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            weekdayStack.trailingAnchor.constraint(equalTo: activeStateBackground.trailingAnchor),
            weekdayStack.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class WeekdayView: UIView {
    
    private let weekdayLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var weekday: String? {
        didSet {
            weekdayLabel.text = weekday
        }
    }
    
    var isActive: Bool = false {
        didSet {
            weekdayLabel.textColor = isActive ? .white : .systemGray2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = isActive ? .black : .systemGray5
        layer.cornerRadius = 18
        layer.cornerCurve = .continuous
        
        addSubview(weekdayLabel)
        
        NSLayoutConstraint.activate([
            weekdayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            weekdayLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            widthAnchor.constraint(equalToConstant: 36),
            heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
