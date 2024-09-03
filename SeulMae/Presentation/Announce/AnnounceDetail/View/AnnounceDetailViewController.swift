//
//  AnnounceDetailViewController.swift
//  SeulMae
//
//  Created by 조기열 on 7/23/24.
//

import UIKit

final class AnnounceDetailViewController: UIViewController {
    
    // MARK: - UI
    
    private let announceKindLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: .bold)
        label.text = "구분"
        return label
    }()
    
    private let announceKindSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        
        return segmentedControl
    }()
    
    private let announceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: .bold)
        label.text = "제목"
        return label
    }()
    
    private let announceTitleTextView: UITextView = {
        let textView = _TextView()
        textView.backgroundColor = .textView
        textView.placeholder = "제목을 입력해주세요"
        textView.layer.cornerRadius = 12
        textView.layer.cornerCurve = .continuous
        textView.font = .pretendard(size: 16, weight: .regular)
        return textView
    }()
    
    private let announceContentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: .bold)
        label.text = "내용"
        return label
    }()
    
    private let announceContentTextView: UITextView = {
        let textView = _TextView()
        textView.backgroundColor = .textView
        textView.placeholder = "공지사항 내용을 입력해주세요"
        textView.layer.cornerRadius = 12
        textView.layer.cornerCurve = .continuous
        textView.font = .pretendard(size: 16, weight: .regular)
        return textView
    }()
    
    private let saveButton = UIButton.common(title: "저장")
    
    // MARK: - Dependencies
    
    private var viewModel: AnnounceDetailViewModel!
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: AnnounceDetailViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        bindSubviews()
    }
    
    private func bindSubviews() {
        let isMustRead = announceKindSegment.rx
            .selectedSegmentIndex
            .map { $0 == 1 }
            .asDriver()
        
        let output = viewModel.transform(
            .init(
                isMustRead: isMustRead,
                title: announceTitleTextView.rx.text.orEmpty.asDriver(),
                content: announceContentTextView.rx.text.orEmpty.asDriver(),
                saveAnnounce: saveButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await item in output.item.values {
                
            }
        }
    }
    
    // MARK: - Hierarchy
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        let announceKindStack = UIStackView()
        announceKindStack.distribution = .equalCentering
        announceKindStack.addArrangedSubview(announceKindLabel)
        announceKindStack.addArrangedSubview(announceKindSegment)
        
        let announceTitleStack = UIStackView()
        announceTitleStack.axis = .vertical
        announceTitleStack.spacing = 4.0
        announceTitleStack.addArrangedSubview(announceTitleLabel)
        announceTitleStack.addArrangedSubview(announceTitleTextView)
        
        let announceContentStack = UIStackView()
        announceContentStack.axis = .vertical
        announceContentStack.spacing = 4.0
        announceContentStack.addArrangedSubview(announceContentLabel)
        announceContentStack.addArrangedSubview(announceContentTextView)
        
        let contentStack = UIStackView()
        announceContentStack.axis = .vertical
        announceContentStack.spacing = 8.0
        announceContentStack.addArrangedSubview(announceKindStack)
        announceContentStack.addArrangedSubview(announceTitleStack)
        announceContentStack.addArrangedSubview(announceContentStack)
        
        view.addSubview(contentStack)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            saveButton.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            saveButton.centerXAnchor.constraint(equalTo: contentStack.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            
        ])
    }
}


