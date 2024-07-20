//
//  WorkLogsSummaryView.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import UIKit

final class WorkLogsSummaryView: UIView {
    
    private let baseWageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .gray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let totalHoursLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .gray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let totalWageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 24, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var baseWage: Int? {
        didSet {
            guard let baseWage else { return }
            baseWageLabel.text = "총 합계 (\(baseWage))"
        }
    }
    
    var totalHours: Int? {
        didSet {
            guard let totalHours else { return }
            totalHoursLabel.text = "\(totalHours) 시간"
        }
    }
    
    var totalWage: Int? {
        didSet {
            guard let totalWage else { return }
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let formatted = numberFormatter.string(from: totalWage as NSNumber) {
                totalWageLabel.text = "\(formatted)원"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray
        
        addSubview(baseWageLabel)
        addSubview(totalHoursLabel)
        addSubview(totalWageLabel)
        
        let inset: CGFloat = 16
        
        NSLayoutConstraint.activate([
            baseWageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            baseWageLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            
            totalHoursLabel.topAnchor.constraint(equalTo: baseWageLabel.topAnchor),
            totalHoursLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            totalWageLabel.topAnchor.constraint(equalTo: totalHoursLabel.bottomAnchor),
            totalWageLabel.trailingAnchor.constraint(equalTo: totalHoursLabel.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
