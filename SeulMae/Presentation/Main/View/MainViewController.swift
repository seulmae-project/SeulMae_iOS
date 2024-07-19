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
    
    // MARK: - Flow Methods
    
    static func create(viewModel: MainViewModel) -> MainViewController {
        let view = MainViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: - Internal Types
    
    typealias MemberDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias MemberSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, Hashable, CaseIterable {
        case list
    }
    
    struct Item: Hashable {
        let imageURL: String
        let isManager: Bool
    }
    
    enum Text {
        static let changeWorkplace = "근무지 변경"
        static let workStart = "출근"
        static let workEnd = "퇴근"
        static let addWorkLog = "근무 등록"
    }
    
    // MARK: - UI Properties
    
    private let scrollView: UIScrollView = .init()
    
    private let reminderBarButton: UIBarButtonItem = .init()
    
    private let memberSliderView = SliderView<MemberView>()
    
    private let noticeSliderView = SliderView<NoticeView>()
    
    private let label: UILabel = .title(title: "이번달\n-- 을 확인해 보세요")
    
    private let calendarView: UIView = UIView()
    
    private let workStatusView: WorkStatusView = WorkStatusView()
    
    private let workStartButton: UIButton = .common(title: Text.workStart)
    
    private let addWorkLogButton: UIButton = .common(title: Text.addWorkLog)
    
    // MARK: - Properties
    
    
    // MARK: - Dependencies
    
    private var viewModel: MainViewModel!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavItem()
        configureHierarchy()
        bindInternalSubviews()
    }
    
    // MARK: - Nav Item
    
    private func configureNavItem() {
        // TODO: 인터넷이 연결되어 있지 않아도 기본 근무지 정보를 받아올 수 있도록 처리
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItem = reminderBarButton
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
    
        let output = viewModel.transform(
            .init(
                showWorkplace: .empty(),
                changeWorkplace: .empty(),
                showRemainders: .empty(),
                showMemberDetail: .empty(),
                showNotices: .empty(),
                workStart: workStartButton.rx.tap.asSignal(),
                addWorkLog: addWorkLogButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await members in output.members.values {
                Swift.print(#fileID, "(MainVC) Did received members: \(members)")
                memberSliderView.items = members.map { member in
                    let view = MemberView()
                    view.member = member
                    return view
                }
            }
        }
        
        Task {
            for await remainders in output.notices.values {
                // 알림 겟수 필요함
                Swift.print(#fileID, "(MainVC) Did received remainders: \(remainders)")
            }
        }
        
        Task {
            for await notices in output.notices.values {
                Swift.print(#fileID, "(MainVC) Did received notices: \(notices)")
                noticeSliderView.items = notices.map { notice in
                    let view = NoticeView()
                    view.title = notice.title
                    return view
                }
            }
        }
        
        //        Task {
        //            for await item in output.item.values {
        //                applyItem(item)
        //            }
        //        }
    }
    
    private func apply(item: MainViewItem) {
        navigationItem.title = item.navItemTitle
    }
    
    // MARK: - Hierarchy
    
    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        
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
        
        memberSliderView.itemSize = 44
        // inset + margin 줄 수 있게끔
        
        /// - Tag: Hierarchy
        let stack = UIStackView(arrangedSubviews: [
            memberSliderView,
            noticeSliderView,
            separator,
            label
        ])
        
        stack.axis = .vertical
        stack.spacing = 16

        let subViews: [UIView] = [
            stack,
            calendarView,
            modalVStack
        ]
        subViews.forEach(view.addSubview)
        
        memberSliderView.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        noticeSliderView.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
        
        stack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.snp_topMargin).inset(16)
            make.centerX.equalToSuperview()
        }
        
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

