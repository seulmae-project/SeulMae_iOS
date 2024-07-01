//
//  MainViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    // MARK: - Flow
    
    static func create(viewModel: MainViewModel) -> MainViewController {
        let view = MainViewController()
        view.viewModel = viewModel
        return view
    }
    
    enum Text {
        static let changeWorkplace = "근무지 변경"
        static let workStart = "출근"
        static let workEnd = "퇴근"
        static let addWorkLog = "근무 등록"
    }
    
    // MARK: - Dependency
    
    private var viewModel: MainViewModel!
    
    // MARK: - UI
    
    private let scrollView: UIScrollView = .init()
    private let reminderBarButton: UIBarButtonItem = .init()
    private let memberListView: UIView = UIView()
    
    
    // 근무지 유저 리스트 컬렉션 뷰 ? > 스크롤 뷰 ??
    private let noticeView: UIView = UIView()
    // 공지 뷰 > 커스텀..? 슬라이더 뷰 수정해서 쓰기
    
    private let label: UILabel = .title(title: "이번달\n-- 을 확인해 보세요")
    
    private let calendarView: UIView = UIView()
    
    private let workStatusView: WorkStatusView = WorkStatusView()
    private let workStartButton: UIButton = .common(title: Text.workStart)
    private let addWorkLogButton: UIButton = .common(title: Text.addWorkLog)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavItem()
        configureHierarchy()
    }
    
    private func configureNavItem() {
        // TODO: 인터넷이 연결되어 있지 않아도 기본 근무지 정보를 받아올 수 있도록 처리
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItem = reminderBarButton
    }
    
    private func bindInternalSubviews() {
        let output = viewModel.transform(
            .init(
                showWorkplace: .empty(),
                changeWorkplace: .empty(),
                showRemainders: .empty(),
                showMemberDetail: .empty(),
                showNotices: .empty(),
                workStart: .empty(),
                addWorkLog: .empty()
            )
        )
        
//        Task {
//            for await item in output.item.values {
//                applyItem(item)
//            }
//        }
    }
    
    private func apply(item: MainViewItem) {
        navigationItem.title = item.navItemTitle
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        
        let workButtonHStack = UIStackView(arrangedSubviews: [
            workStartButton,
            addWorkLogButton
        ])
        workButtonHStack.spacing = 12
        workButtonHStack.distribution = .fillEqually
        
        workStatusView.label.text = "남은시간"
        workStatusView.label3.text = "-월 합계 -원"
        workStatusView.label4.text = "-원"
        workStatusView.progressView.progress = 0.5
        
        let modalVStack = UIStackView(arrangedSubviews: [
            workStatusView,
            workButtonHStack
        ])
        modalVStack.axis = .vertical
        modalVStack.spacing = 16
        
        /// - Tag: Hierarchy
        
        let subViews: [UIView] = [
            label,
            calendarView,
            modalVStack
        ]
        subViews.forEach(view.addSubview)
        
        workButtonHStack.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        modalVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalTo(view.snp_bottomMargin).inset(16)
            make.centerX.equalToSuperview()
        }
    }
}

