//
//  MonthView.swift
//  SeulMae
//
//  Created by 조기열 on 7/1/24.
//

import UIKit

final class MonthView: UIView {
    
    struct CalendarConfiguration {
        struct LabelProperties {
            var textColor: UIColor = .label
            var font: UIFont = .boldSystemFont(ofSize: 16)
        }
        
        struct ButtonProperties {
            var image: UIImage = UIImage()
            var titleColor: UIColor = .label
        }
        
        var monthLabelProperties: LabelProperties = LabelProperties()
        var nextMonthButtonProperties: ButtonProperties = ButtonProperties()
        var previousMonthButtonProperties: ButtonProperties = ButtonProperties()
    }
        
    // MARK: - UI
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = configuration.monthLabelProperties.textColor
        label.textAlignment = .center
        label.font = configuration.monthLabelProperties.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.setTitleColor(configuration.nextMonthButtonProperties.titleColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didButtonSelected(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.setTitleColor(configuration.previousMonthButtonProperties.titleColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didButtonSelected(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var configuration: CalendarConfiguration = CalendarConfiguration()

    private var presentYear: Int = 0
    
    private var presentMonth: Int = 0
    
    private var monthsArr = [
        "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"
    ]
    
//    [
//        "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
//    ]

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        presentMonth = Calendar.current.component(.month, from: Date()) - 1
        presentYear = Calendar.current.component(.year, from: Date())
        
        self.addSubview(monthLabel)
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor),
            monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            monthLabel.widthAnchor.constraint(equalToConstant: 150),
            monthLabel.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        monthLabel.text = monthsArr[presentMonth - 1]
          
        self.addSubview(nextMonthButton)
        NSLayoutConstraint.activate([
            nextMonthButton.topAnchor.constraint(equalTo: topAnchor),
            nextMonthButton.rightAnchor.constraint(equalTo: rightAnchor),
            nextMonthButton.widthAnchor.constraint(equalToConstant: 50),
            nextMonthButton.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        self.addSubview(previousMonthButton)
        NSLayoutConstraint.activate([
            previousMonthButton.topAnchor.constraint(equalTo: topAnchor),
            previousMonthButton.leftAnchor.constraint(equalTo: leftAnchor),
            previousMonthButton.widthAnchor.constraint(equalToConstant: 50),
            previousMonthButton.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handler
    
    @objc func didButtonSelected(_ sender: UIButton) {
        presentMonth += (sender == previousMonthButton) ? 1 : -1

        if presentMonth > 12 {
            presentMonth = 1
            presentYear += 1
        } else if presentMonth < 1 {
            presentMonth = 12
            presentYear -= 1
        }
        
        monthLabel.text = monthsArr[presentMonth - 1]
     }
}
