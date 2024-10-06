//
//  WorkLogSummaryView.swift
//  SeulMae
//
//  Created by 조기열 on 10/5/24.
//

import UIKit

class WorkLogSummaryView: UIView {

    private let workTimeLabel: UILabel = .common(title: "--시간 --분")
    private let baseWageLabel: UILabel = .common(title: "시급 9,900원")
    private let totalWageLabel: UILabel = .common(title: "총 99,000원")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .signinSeparator
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        
        let a = UIStackView()
        a.distribution = .equalCentering
        [workTimeLabel, baseWageLabel]
            .forEach(a.addArrangedSubview(_:))
        
        let b = UIStackView()
        b.axis = .vertical
        b.distribution = .equalCentering
        [a, totalWageLabel]
            .forEach(b.addArrangedSubview(_:))
        
        addSubview(b)
        b.translatesAutoresizingMaskIntoConstraints = false
        
        let inset = CGFloat(16)
        NSLayoutConstraint.activate([
            b.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            b.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            b.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            b.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        workTimeInterval: TimeInterval,
        baseWage: Int
    ) {
        let hours = Int(workTimeInterval) / 3600
        let minutes = (Int(workTimeInterval) % 3600) / 60
        workTimeLabel.text = String(format: "%d시간 %d분", hours, minutes)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: baseWage)) ?? ""
        let totalWage = baseWage * hours
        baseWageLabel.text = "시급 \(formattedNumber)"
        totalWageLabel.text = "총 \(totalWage)"
    }
}
