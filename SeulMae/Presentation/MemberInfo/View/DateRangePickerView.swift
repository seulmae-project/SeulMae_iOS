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
        l.font = .systemFont(ofSize: 12)
        return l
    }()
    
    private let _endDateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        return l
    }()
    
    private let startDateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        return l
    }()
    
    private let endDateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
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
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0
        
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.heightAnchor
            .constraint(equalToConstant: 1.0)
            .isActive = true
        
        let startDateStack = UIStackView(arrangedSubviews: [
            _startDateLabel, startDateLabel
        ])
        startDateStack.axis = .vertical
        startDateStack.spacing = 8.0
        startDateStack.alignment = .leading
        
        let endDateStack = UIStackView(arrangedSubviews: [
            _endDateLabel, endDateLabel
        ])
        endDateStack.axis = .vertical
        endDateStack.spacing = 8.0
        endDateStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [
            startDateStack, separator, endDateStack
        ])
        stack.spacing = 16
        stack.distribution = .equalSpacing
        stack.alignment = .center
        separator.topAnchor
            .constraint(equalTo: stack.topAnchor)
            .isActive = true
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

