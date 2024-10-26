//
//  ScheduleCustomizationView.swift
//  SeulMae
//
//  Created by 조기열 on 10/24/24.
//

import UIKit

class ScheduleCustomizationView: UIView {
    let nameTextField: UITextField = Ext.small(placeholder: "파트 명", width: 110)
    let _waveLabel: UILabel = Ext.common(
        "~",
        font: .pretendard(size: 20, weight: .medium),
        textColor: UIColor(hexCode: "7F9AFA"))

    let startTimeTextFeild: UITextField = Ext.small(placeholder: "시작시간", width: 88)
    let endTimeTextField: UITextField = Ext.small(placeholder: "종료시간", width: 88)
    let weekdayStack: UIStackView = UIStackView()
    var onChange: (([Int]) -> Void)?

    @objc func onWeekdayTap(_ sender: UITapGestureRecognizer) {
        let weekdayView = sender.view as? WeekdaySelectionView
        var isSelect = weekdayView?.isSelect ?? false
        isSelect.toggle()
        weekdayView?.isSelect = isSelect
        weekdayView?.backgroundColor = isSelect ? UIColor(hexCode: "E4EAFF") : UIColor.white
        weekdayView?.checkMarkImageView.isHidden = !isSelect
        let selected = weekdayStack.arrangedSubviews
            .enumerated()
            .filter { ($1 as? WeekdaySelectionView)?.isSelect ?? false }
            .map(\.offset)
        onChange?(selected)
    }



    convenience init() {
        self.init(frame: .zero)

        backgroundColor = UIColor(hexCode: "F2F5FF")
        layer.cornerRadius = 8.0
        layer.cornerCurve = .continuous

        weekdayStack.spacing = 8.0
        weekdayStack.distribution = .fillEqually
        let weekdays = [ "일", "월", "화", "수", "목", "금", "토"]
            .map(WeekdaySelectionView.init(weekday:))
        weekdays.forEach { weekdayView in
            let tapGesture = UITapGestureRecognizer()
            tapGesture.addTarget(self, action: #selector(onWeekdayTap(_:)))
            weekdayView.addGestureRecognizer(tapGesture)
            weekdayStack.addArrangedSubview(weekdayView)
        }

        let inputStack = UIStackView()
        inputStack.distribution = .equalSpacing
        [nameTextField, startTimeTextFeild, _waveLabel, endTimeTextField]
            .forEach(inputStack.addArrangedSubview(_:))

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 16
        [inputStack, weekdayStack]
            .forEach(contentStack.addArrangedSubview(_:))

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let insets = CGFloat(16)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: insets),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets),
        ])
    }
}
