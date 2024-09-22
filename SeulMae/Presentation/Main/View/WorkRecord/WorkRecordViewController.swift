//
//  WorkRecordViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/22/24.
//

import UIKit

final class WorkRecordViewController: UIViewController {
    
    // MARK: - UI
   
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let leftTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let leftTimeOutlet: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let totalMonthlySalaryLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let amountEarnedToday: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    let progressView: UIProgressView = UIProgressView()
    
    private let getOffWorkButton: UIButton = {
        let button = UIButton()
        button.setTitle("퇴근하기", for: .normal)
        return button
    }()
    
    // MARK: - Properties
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    
}
