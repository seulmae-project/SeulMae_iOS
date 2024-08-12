//
//  DatePickerModalViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/11/24.
//

import UIKit
import RxSwift

class DatePickerModalViewController: UIViewController {
    
    static func create(kind: DatePickerKind) -> UIViewController {
        let vc = DatePickerModalViewController()
        vc.datePickerKind = kind
        return vc
    }
    
    private var datePickerKind: DatePickerKind!

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 20)
        l.text = "\(datePickerKind.description) 선택"
        return l
    }()
    
    private let closeButton: UIButton = {
        let b = UIButton()
        b.setTitle("닫기", for: .normal)
        b.setTitleColor(.label, for: .normal)
        return b
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        return datePicker
    }()
    
    private lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [
            closeButton, titleLabel, datePicker, spacer
        ])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    @objc func handleCloseAction() {
        // animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupConstraints() {
        // Add subviews
        view.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set static constraints
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
