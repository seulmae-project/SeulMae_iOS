//
//  DateSelectView.swift
//  SeulMae
//
//  Created by 조기열 on 8/11/24.
//

import UIKit

class DateSelectView: UIView {
    
    // MARK: - UI
    
    private lazy var yearButton: UIButton = {
        let b = UIButton()
        b.setTitle("년", for: .normal)
        b.setTitleColor(.label, for: .normal)
        b.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return b
    }()
    
    private lazy var monthButton: UIButton = {
        let b = UIButton()
        b.setTitle("달", for: .normal)
        b.setTitleColor(.label, for: .normal)
        return b
    }()
    
    private lazy var dayButton: UIButton = {
        let b = UIButton()
        b.setTitle("일", for: .normal)
        b.setTitleColor(.label, for: .normal)
        return b
    }()
    
    // MARK: - Properties
    
   
    
    var currentYear: Int = 0
    var currentMonth: Int = 0
    var currentDay: Int = 0
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        let now = Date()
        let calendar = Calendar.current
//        endYear = calendar.component(.year, from: now)
//        currentYear = endYear
        currentMonth = calendar.component(.month, from: now)
        currentDay = calendar.component(.day, from: now)
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [
            yearButton, monthButton, dayButton
        ])
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func handleButtonTapped(_ sender: UIButton) {
        let bottomSheet = BottomSheetController(contentViewController: DatePickerModalViewController.create(kind: .month))
        bottomSheet.bottomSheetPresentationController?.preferredSheetHeight = 200
        let rootViewController = UIApplication.shared.keyWindow!.rootViewController! as! UINavigationController
        rootViewController.topViewController!.present(bottomSheet, animated: true)
    }
}



