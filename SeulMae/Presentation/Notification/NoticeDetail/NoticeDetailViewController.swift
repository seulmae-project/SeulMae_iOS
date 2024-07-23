//
//  NoticeDetailViewController.swift
//  SeulMae
//
//  Created by 조기열 on 7/23/24.
//

import UIKit

final class NoticeDetailViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: NoticeDetailViewModel) -> NoticeDetailViewController {
        let vc = NoticeDetailViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    // MARK: - UI
    
    private let _noticeKindLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.text = "구분"
        return l
    }()
    
    private let noticeKindSegment: UISegmentedControl = {
        let sg = UISegmentedControl()
        
        return sg
    }()
    
    private let _titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.text = "제목"
        return l
    }()
    
    private let titleTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .textView
        tv.heightAnchor.constraint(equalToConstant: 100)
            .isActive = true
        // tv. "제목을 입력해주세요"
        tv.layer.cornerRadius = 16
        tv.layer.cornerCurve = .continuous
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()
    
    private let _contentLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.text = "제목"
        return l
    }()
    
    private let contentTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .textView
        tv.heightAnchor.constraint(equalToConstant: 100)
            .isActive = true
        tv.layer.cornerRadius = 16
        tv.layer.cornerCurve = .continuous
        tv.font = .systemFont(ofSize: 16)
        // tv. "공지사항 내용을 입력해주세요"
        return tv
    }()
    
    private let saveButton = UIButton.common(title: "저장")
    
    // MARK: - Dependencies
    
    private var viewModel: NoticeDetailViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSubviews()
        
    }
    
    // MARK: - Layout Subviews
    
    func layoutSubviews() {
        view.backgroundColor = .systemBackground
        
        let kindStack = UIStackView(arrangedSubviews: [
            _noticeKindLabel, noticeKindSegment
        ])
        kindStack.distribution = .equalCentering
        
        let separator = UIView()
        separator.backgroundColor = .border
        separator.heightAnchor
            .constraint(equalToConstant: 1.0)
            .isActive = true
        
        let stack = UIStackView(arrangedSubviews: [
            kindStack,
            separator,
            _titleLabel,
            titleTextView,
            _contentLabel,
            contentTextView
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.setCustomSpacing(20, after: separator)
        stack.setCustomSpacing(20, after: titleTextView)

        view.addSubview(stack)
        view.addSubview(saveButton)
        
        let inset = CGFloat(16)
        stack.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin)
                .inset(inset)
            make.leading.trailing.equalToSuperview()
                .inset(inset)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp_bottomMargin).inset(24)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
        }
    }
    
    func bindSubviews() {
        
    }
}


