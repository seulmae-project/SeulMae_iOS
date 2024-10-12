//
//  CalendarControl.swift
//  SeulMae
//
//  Created by 조기열 on 7/1/24.
//

import UIKit

final class CalendarControl: UIView {
    
    lazy var selectDateButton: UIButton = {
        let button = UIButton()
        button.setImage(.caretDown, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(didButtonSelected(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        if #available(iOS 17.4, *) {
            datePicker.datePickerMode = .yearAndMonth
        } else {
            datePicker.datePickerMode = .date
        }
        var dateComponents = DateComponents()
        dateComponents.year = 2000
        let calendar = Calendar.current
        datePicker.minimumDate = calendar.date(from: dateComponents)!
        datePicker.maximumDate = .ext.now
        datePicker.setDate(.ext.now, animated: false)
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.addTarget(self, action: #selector(didDateChanged), for: .valueChanged)
        return datePicker
    }()
    
    // MARK: - Properties
    
    var currentYear = 0
    var currentMonth = 0
    
    var onChange: ((_ date: Date) -> ())?
    
    // MARK: - Life Cycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let now = Date.ext.now
        setButtonTitle(for: now)
        
        addSubview(selectDateButton)
        selectDateButton.translatesAutoresizingMaskIntoConstraints = false
                
        let inset = CGFloat(8.0)
        NSLayoutConstraint.activate([
            selectDateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            selectDateButton.topAnchor.constraint(lessThanOrEqualTo: topAnchor),
            selectDateButton.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
            selectDateButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setButtonTitle(for date: Date) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)

        let title = "\(year)년 \(month)월"
        let attributedString = NSMutableAttributedString(string: title)
        
        let boldFont = UIFont.pretendard(size: 20, weight: .bold)
        let regularFont = UIFont.pretendard(size: 15, weight: .regular)

        let yearRange = (title as NSString).range(of: "\(year)")
        attributedString.addAttribute(.font, value: boldFont, range: yearRange)
        let monthRange = (title as NSString).range(of: "\(month)")
        attributedString.addAttribute(.font, value: boldFont, range: monthRange)

        let yearLabelRange = (title as NSString).range(of: "년")
        attributedString.addAttribute(.font, value: regularFont, range: yearLabelRange)
        let monthLabelRange = (title as NSString).range(of: "월")
        attributedString.addAttribute(.font, value: regularFont, range: monthLabelRange)

        selectDateButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    // MARK: - Handler Methods
    
    @objc func didButtonSelected(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "완료", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        let vc = UIViewController()
        vc.view = datePicker
        alert.setValue(vc, forKey: "contentViewController")
        let rootViewController = UIApplication.shared.keyWindow!.rootViewController! as! UINavigationController
        rootViewController.topViewController!.present(alert, animated: true)
    }
    
    @objc func didDateChanged(_ sender: UIDatePicker) {
        NSLog("Date: \(sender.date)")
        onChange?(sender.date)
    }
}
