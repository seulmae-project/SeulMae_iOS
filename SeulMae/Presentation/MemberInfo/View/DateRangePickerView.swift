//
//  DateRangePickerView.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import UIKit

final class DateRangePickerView: UIView {
    
    private let _startDateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .label
        l.font = .systemFont(ofSize: 12)
        l.text = AppText.startDate
        return l
    }()
    
    private let _endDateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .label
        l.font = .systemFont(ofSize: 12)
        l.text = AppText.endDate
        return l
    }()
    
    private let startDateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.textColor = .label
        l.text = "10월 26일(금)"
        return l
    }()
    
    private let endDateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.textColor = .label
        l.text = "10월 26일(금)"
        return l
    }()
    
    var startDate: String? {
        didSet {
            startDateLabel.text = startDate
        }
    }
    
    var endDate: String? {
        didSet {
            endDateLabel.text = endDate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        layer.borderColor = UIColor.border.cgColor
        layer.borderWidth = 1.0
        
        let separator = UIView()
        separator.backgroundColor = .border

        let startDateStack = UIStackView(arrangedSubviews: [
            _startDateLabel, startDateLabel
        ])
        startDateStack.axis = .vertical
        startDateStack.spacing = 8.0
        startDateStack.alignment = .leading
        startDateStack.directionalLayoutMargins = .init(top: 8.0, leading: 12, bottom: 8.0, trailing: 12)
        startDateStack.isLayoutMarginsRelativeArrangement = true
        
        let endDateStack = UIStackView(arrangedSubviews: [
            _endDateLabel, endDateLabel
        ])
        endDateStack.axis = .vertical
        endDateStack.spacing = 8.0
        endDateStack.alignment = .leading
        endDateStack.directionalLayoutMargins = .init(top: 8.0, leading: 12, bottom: 8.0, trailing: 12)
        endDateStack.isLayoutMarginsRelativeArrangement = true

        let stack = UIStackView(arrangedSubviews: [
            startDateStack, separator, endDateStack
        ])
        stack.spacing = 16
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            separator.topAnchor.constraint(equalTo: stack.topAnchor),
            separator.widthAnchor.constraint(equalToConstant: 1.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

