//
//  ScheduleInlet.swift
//  SeulMae
//
//  Created by 조기열 on 10/24/24.
//

import UIKit

class ScheduleInlet: UIView {
    let nameInlet: UITextField = Ext.template(style: .one)
    let _waveOutlet: UILabel = UILabel()
    let startTimeInlet: UITextField = Ext.template(style: .one)
    let endTimeInlet: UITextField = Ext.template(style: .one)
    let weekdayStack: UIStackView = UIStackView()

    convenience init() {
        self.init(frame: .zero)
        let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
            .map { weekday in
                let inlet = WeekdayInlet()
                inlet.weekdayOulet.setTitle(weekday, for: .normal)
                return inlet
            }
        weekdays.forEach(weekdayStack.addArrangedSubview(_:))

        let hStack = UIStackView()
        [nameInlet, startTimeInlet, _waveOutlet, endTimeInlet]
            .forEach(hStack.addArrangedSubview(_:))

        let cStack = UIStackView()
        cStack.axis = .vertical
        [hStack, weekdayStack]
            .forEach(cStack.addArrangedSubview(_:))

        addSubview(cStack)
        cStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cStack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            cStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
        ])
    }
}
