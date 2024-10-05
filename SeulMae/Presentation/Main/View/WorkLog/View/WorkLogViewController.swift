//
//  WorkLogViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/22/24.
//

import UIKit

final class WorkLogViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    private let titleLabel: UILabel = .title(title: "기록한 정보를 확인해주세요 \nOR 근무 등록")
    private let workLogSummeryView = WorkLogSummaryView()
    private let _workDateLabel: UILabel = .common(title: "근무일", size: 15)
    private lazy var workDatePicker: UIDatePicker = Ext.date
    private let _workTimeLabel: UILabel = .common(title: "근무 시간", size: 15)
    private let workTimePicker: UIDatePicker = Ext.time
    private let _messageLable: UILabel = .common(title: "전달사항", size: 15)
    private let messageTextView: UITextView = Ext.common(placeholder: "전달사항을 입력해주세요")
    private let _memoLable: UILabel = .common(title: "메모", size: 15)
    private let memoTextView: UITextView = Ext.common(placeholder: "메모를 입력해주세요")
    private let requestAttendanceButton: UIButton = .common(title: "저장")
    
    // MARK: - Properties
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    // MARK: - Life Cycle Methods
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let workDate = workDatePicker.rx.controlEvent(.valueChanged)
            .withUnretained(workDatePicker)
            .map(\.0.date)
        
        
        
        
    }
}
