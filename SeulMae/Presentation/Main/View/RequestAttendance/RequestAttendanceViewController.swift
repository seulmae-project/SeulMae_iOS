//
//  RequestAttendanceViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/22/24.
//

import UIKit

final class RequestAttendanceViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let workRecordSummeryStack: UIStackView = {
        let stack = UIStackView()
        
        return stack
    }()
    
    private let workDateLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var workDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.addTarget(self, action: #selector(didDatePickerValueChange), for: .valueChanged)
        return picker
    }()
    
    @objc func didDatePickerValueChange(_ picker: UIDatePicker) {
        // onChange?(picker.date)
    }
    
    private let messageLable: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let messageTextView: UITextView = {
        let textView = UITextView()
        
        return textView
    }()
    
    private let memoLable: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let memoTextView: UITextView = {
        let textView = UITextView()
        
        return textView
    }()
    
    private let requestAttendanceButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        return button
    }()
    
    // MARK: - Properties
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
}
