//
//  DailyWorkView.swift
//  SeulMae
//
//  Created by 조기열 on 10/12/24.
//

import UIKit

class DailyWorkView: UIView {
    /// 근무일 D+234
    var dayCountLabel: UILabel = .common(title: "D+234", size:12, weight: .bold, color: .white)
    
    /// 근무지 이름
    var nameLabel: UILabel = .common(title: "팀슬매", size: 22, weight: .semibold, color: .white)

    // Today | 10월 06일
    /// Today
    private var _todayLabel: UILabel = .common(title: "Today", size: 12, weight: .medium, color: .white)
    
    /// |
    private var _dividerLabel: UILabel = .common(title: "|", size: 12, weight: .medium, color: .white)
    
    /// 10월 06일
    var todayLabel: UILabel = .common(title: "10월 06일", size: 12, weight: .medium, color: .white)
    
    var attendanceButton: UIButton = .common(
        title: "출근하기",
        size: 20,
        weight: .extraBold,
        color: UIColor(hexCode: "4C71F5"),
        backgroundColor: .white,
        cornerRadius: 23,
        layoutMargins: .init(top: 7, left: 31.5, bottom: 7, right: 31.5)
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hexCode: "4C71F5")
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
                
        let bubbled = dayCountLabel.bubbled(color: UIColor(hexCode: "7298F8"), horizontal: 10, vertical: 1.0)

        let todayStack = UIStackView()
        todayStack.spacing = 8.0
        
        todayStack.addArrangedSubview(_todayLabel)
        todayStack.addArrangedSubview(_dividerLabel)
        todayStack.addArrangedSubview(todayLabel)
//
//        [_todayLabel, _dividerLabel, todayLabel]
//            .forEach(todayStack.addArrangedSubview(_:))
//        
        [bubbled, todayStack, nameLabel, attendanceButton]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            bubbled.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            bubbled.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            
            todayStack.topAnchor.constraint(equalTo: topAnchor, constant: 9.0),
            todayStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28),
            
            attendanceButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            attendanceButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21),
            
            attendanceButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
