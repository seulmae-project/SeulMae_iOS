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
    
    private lazy var memberCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let noticeView: UIView = UIView()
    // 공지 뷰 > 커스텀..? 슬라이더 뷰 수정해서 쓰기
    
    private let label: UILabel = .title(title: "이번달\n-- 을 확인해 보세요")
    
    private let calendarView: UIView = UIView()
    
    private let workStatusView: WorkStatusView = WorkStatusView()
    
    private let workStartButton: UIButton = .common(title: Text.workStart)
    
    private let addWorkLogButton: UIButton = .common(title: Text.addWorkLog)
    
    // MARK: - Properties
    
    private var memberDataSource: MemberDataSource!
    
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
            for await item in output.members.values {
                Swift.print(#fileID, "(MainVC) Did received members")
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
    
    // MARK: - DataSource
    
    private func configureDataSource() {
        let memberCellRegistration = createMemberCellRegistration()
        
        memberDataSource = MemberDataSource(collectionView: memberCollectionView) { (view, index, item) in
            view.dequeueConfiguredReusableCell(using: memberCellRegistration, for: index, item: item)
        }
    }
    
    // MARK: - Snapshot
    
    private func applySnapshot(items: [Item]) {
        var snapshot = MemberSnapshot()
        let sections = Section.allCases
        snapshot.appendSections(sections)
        snapshot.appendItems(items, toSection: .list)
        memberDataSource.apply(snapshot)
    }
    
    // MARK: - Cell Registration
    
    private func createMemberCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, index, item in
            var content = MemberContentView.Configuration()
            content.imageURL = item.imageURL
            content.isManager = item.isManager
        }
    }
    
    // MARK: - UICollectionViewLayout
    
    func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.28), heightDimension: .fractionalWidth(0.2)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

