//
//  CalendarControl.swift
//  SeulMae
//
//  Created by 조기열 on 7/1/24.
//

import UIKit

final class CalendarControl: UIView {
        
    // MARK: - UI
    
    private lazy var previousMonthButton: UIButton = {
        let b = UIButton()
        b.setImage(.caretLeft, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(didButtonSelected(_:)), for: .touchUpInside)
        return b
    }()
    
    private lazy var monthLabel: UILabel = {
        let l = UILabel()
        l.text = monthsArr[currentMonth - 1]
        l.textColor = .graphite
        l.textAlignment = .center
        l.font = .boldSystemFont(ofSize: 24)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var nextMonthButton: UIButton = {
        let b = UIButton()
        b.setImage(.caretRight, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(didButtonSelected(_:)), for: .touchUpInside)
        return b
    }()
    
    // MARK: - Properties
    
    var currentYear = 0
    
    var currentMonth = 0 {
        didSet {
            monthLabel.text = monthsArr[currentMonth - 1]
            onChange?(currentMonth)
        }
    }
    
    private var monthsArr = [
        "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"
    ]
    
    var onChange: ((_ month: Int) -> ())?
    
    // MARK: - Life Cycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let now = Date.ext.now
        currentYear = Calendar.current.component(.year, from: now)
        currentMonth = Calendar.current.component(.month, from: now)
        
        self.addSubview(previousMonthButton)
        self.addSubview(monthLabel)
        self.addSubview(nextMonthButton)
                
        let inset: CGFloat = 8.0
        NSLayoutConstraint.activate([
            previousMonthButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            previousMonthButton.topAnchor.constraint(lessThanOrEqualTo: topAnchor),
            previousMonthButton.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
            previousMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            monthLabel.leadingAnchor.constraint(equalTo: previousMonthButton.trailingAnchor, constant: inset),
            monthLabel.topAnchor.constraint(lessThanOrEqualTo: topAnchor),
            monthLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            monthLabel.widthAnchor.constraint(equalToConstant: 48),
        
            nextMonthButton.leadingAnchor.constraint(equalTo: monthLabel.trailingAnchor, constant: inset),
            nextMonthButton.topAnchor.constraint(lessThanOrEqualTo: topAnchor),
            nextMonthButton.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
            nextMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            nextMonthButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handler Methods
    
    @objc func didButtonSelected(_ sender: UIButton) {
        if (currentMonth == 12 && sender == nextMonthButton) {
            currentMonth = 1
            currentYear += 1
        } else if (currentMonth == 1 && sender == previousMonthButton) {
            currentMonth = 12
            currentYear -= 1
        } else {
            currentMonth += (sender == nextMonthButton) ? 1 : -1
        }
    }
}
