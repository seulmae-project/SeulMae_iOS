//
//  WeekdaySelectionView.swift
//  SeulMae
//
//  Created by 조기열 on 10/24/24.
//

import UIKit

class WeekdaySelectionView: UIView {
    let weekdayLabel: UILabel = Ext.config(
        font: .pretendard(size: 14, weight: .semibold),
        color: UIColor(hexCode: "4C71F5"))

    let checkMarkImageView: UIImageView = Ext.image(
        .checkMarkWeekday, width: 15, height: 15)
    var isSelect = false
    
    convenience init(weekday: String) {
        self.init(frame: .zero)
        
        backgroundColor = .white
        layer.cornerRadius = 8.0
        layer.cornerCurve = .continuous
        
        weekdayLabel.text = weekday
        checkMarkImageView.isHidden = true

        let views = [weekdayLabel, checkMarkImageView]
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            weekdayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            weekdayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),

            checkMarkImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkMarkImageView.topAnchor.constraint(equalTo: weekdayLabel.bottomAnchor, constant: 4.0),
            checkMarkImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
}
