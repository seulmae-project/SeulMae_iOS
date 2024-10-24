//
//  WeekdayInlet.swift
//  SeulMae
//
//  Created by 조기열 on 10/24/24.
//

import UIKit

class WeekdayInlet: UIView {
    let weekdayOulet: UIButton = Ext.template([
        Ext<Any>.Design.font(.pretendard(size: 14, weight: .semibold)),
        Ext.Design.color(UIColor(hexCode: "4C71F5"))
    ])

    let iconOutlet: UIImageView = Ext.template([
        Ext<Any>.Design.image(.checkMarkWeekday)
    ])

    convenience init() {
        self.init(frame: .zero)
        [weekdayOulet, iconOutlet]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

        NSLayoutConstraint.activate([
            weekdayOulet.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            iconOutlet.topAnchor.constraint(equalTo: weekdayOulet.bottomAnchor, constant: 5.0),
            iconOutlet.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            iconOutlet.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
            iconOutlet.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            iconOutlet.widthAnchor.constraint(equalToConstant: 15),
            iconOutlet.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
}
