//
//  MainViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import RxSwift
import RxCocoa

enum UserKind {
    case manager
    case member
}

class MainViewController: UIViewController {
    
    // MARK: - Internal Types
    
    typealias MemberListSnapshot = NSDiffableDataSourceSnapshot<MemberListSection, MemberListItem>
    typealias MemberDataSource = UICollectionViewDiffableDataSource<MemberListSection, MemberListItem>
    typealias AttendanceListShanpshot = NSDiffableDataSourceSnapshot<AttendanceListSection, AttendanceListItem>
    typealias AttendanceDataSource = UICollectionViewDiffableDataSource<AttendanceListSection, AttendanceListItem>
        
    // MARK: - UI
    
    private let reminderBarButton = UIBarButtonItem(image: .bell, style: .plain, target: nil, action: nil)
    private let changeWorkplaceBarButton = UIBarButtonItem(title: "근무지 변경", style: .plain, target: nil, action: nil)
    
    private lazy var attendanceCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createMemberListLayout())
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.clipsToBounds = false
        return cv
    }()
    
    private lazy var memberCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createMemberListLayout())
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.clipsToBounds = false
        return cv
    }()
    
    private let showAnnounceListButton: UIButton = {
        let button = UIButton()
        button.setTitle("공지 리스트", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let announceSliderView = SliderView<AnnounceView>()
    private let _mainTitleLabel = UILabel.title(title: AppText.mainTitle)
    private let currentStatusView = AttendRequestStatusView()
    private let calendarView = CalendarView()
    
    // MARK: - Properties
    
    private var attendanceDataSource: AttendanceDataSource!
    private var memberDataSource: MemberDataSource!
    private var announceRelay = PublishRelay<Announce.ID>()
    
    // MARK: - Dependencies
    
    private var viewModel: MainViewModel!
    
    // MARK: - Life Cycle
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavItem()
        setupView()
        setupDataSource()
        setupConstraints()
        bindSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Swift.print(#line, "😁😁😁😁😁😁")
        Swift.print(#fileID, "🐶🐶🐶 - view will appear")
    }
    
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let onMemberTap = memberCollectionView.rx
            .itemSelected
            .compactMap { [unowned self] index in
                return memberDataSource.itemIdentifier(for: index)?
                    .member
            }
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                changeWorkplace: changeWorkplaceBarButton.rx.tap.asSignal(),
                showWorkplace: .empty(),
                
                showNotiList: .empty(),
                showAnnouceList: showAnnounceListButton.rx.tap.asSignal(),
                showAnnouceDetails: announceRelay.asSignal(),
                
                attedanceDate: .empty(),
                onMemberTap: onMemberTap,
                onBarButtonTap: reminderBarButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await item in output.item.values {
                navigationItem.title = item.navItemTitle
                Swift.print("isManager: \(item.isManager)")
            }
        }
        
        Task {
            for await members in output.members.values {
                Swift.print(#fileID, "🐡🐡🐡 Did received members: \(members)")
                applyMemberSnapshot(members)
            }
        }
        
        Task {
            for await annouceList in output.announceList.values {
                announceSliderView.items = annouceList.map { annouce in
                    let view = AnnounceView()
                    view.title = annouce.title
                    view.announceId = annouce.id
                    return view
                }
                
                announceSliderView.onItemTap = { view in
                    view.announceId
                }
            }
        }
        
        Task {
            for await items in output.attendanceListItems.values {
                Swift.print(#line, "attendance requests count: \(items.count)")
                applyAttendanceSnapshot(items: items)
            }
        }
        Task {
            for await appNotis in output.appNotis.values {
                Swift.print(#line, "App notis count: \(appNotis.count)")
            }
        }
    }
    
    // MARK: - Data Source
    
    private func setupDataSource() {
        let memberCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MemberListItem> { (cell, indexPath, item) in
            var content = MemberContentView.Configuration()
            content.member = item.member
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
        
        memberDataSource = MemberDataSource(collectionView: memberCollectionView) { (view, index, item) -> UICollectionViewCell? in
            return view.dequeueConfiguredReusableCell(using: memberCellRegistration, for: index, item: item)
        }
        
        let attendanceCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, AttendanceListItem> { (cell, indexPath, item) in
            var content = JoinApplicationContentView.Configuration()
//            content.imageURL = item.imageURL
//            content.name = item.name
//            content.isApprove item.
//            content.totalWorkTime
//            content.workStartDate
//            content.workEndDate
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
        
        attendanceDataSource = AttendanceDataSource(collectionView: attendanceCollectionView) { (view, index, item) -> UICollectionViewCell? in
                return view.dequeueConfiguredReusableCell(using: attendanceCellRegistration, for: index, item: item)
        }
    }
    
    private func applyMemberSnapshot(_ members: [Member]) {
        let items = members.map(MemberListItem.init)
        var snapshot = MemberListSnapshot()
        snapshot.appendSections([.row])
        snapshot.appendItems(items, toSection: .row)
        memberDataSource.apply(snapshot)
    }
    
    private func applyAttendanceSnapshot(items: [AttendanceListItem]) {
        var snapshot = AttendanceListShanpshot()
        snapshot.appendSections([.list])
        snapshot.appendItems(items, toSection: .list)
        attendanceDataSource.apply(snapshot)
    }
    
    // MARK: - Hierarchy
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavItem() {
        // navigationController?.navigationBar.standardAppearance.titlePositionAdjustment = UIOffset(horizontal: -(view.frame.width / 2), vertical: 0)
        navigationItem.rightBarButtonItems = [reminderBarButton, changeWorkplaceBarButton]
    }
    
    private func setupConstraints() {
        
        let stack = UIStackView(arrangedSubviews: [
            memberCollectionView,
            .separator,
            showAnnounceListButton,
            announceSliderView,
            .separator,
            _mainTitleLabel,
            currentStatusView,
            calendarView
        ])
        
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.snp_topMargin).inset(20)
            make.centerX.equalToSuperview()
        }
        
        memberCollectionView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        announceSliderView.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
        
        calendarView.snp.makeConstraints { make in
            // 1대 1말고 사이즈를 자동으로 계산했으면 하는데..?
            // width 고정되어 있음
            // 자동으로 사이즈를 계산해야함
            make.height.equalTo(450)
        }
    }
    
    // MARK: - CollectionView Layout
    
    private func createMemberListLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0 / 7.0),
                heightDimension: .estimated(44)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)),
            subitems: [item])
        group.interItemSpacing = .fixed(12)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createAttendanceListLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0 / 7.0),
                heightDimension: .estimated(44)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)),
            subitems: [item])
        group.interItemSpacing = .fixed(12)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return UICollectionViewCompositionalLayout(section: section)
    }
}

