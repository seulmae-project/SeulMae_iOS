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
    
    // MARK: - Flow
    
    static func create(viewModel: MainViewModel) -> MainViewController {
        let view = MainViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: - Internal Types
    
    typealias MemberListSnapshot = NSDiffableDataSourceSnapshot<MemberListSection, MemberListItem>
    typealias MemberListDataSource = UICollectionViewDiffableDataSource<MemberListSection, MemberListItem>
    
    enum MemberListSection: Hashable {
        case row
    }
    
    struct MemberListItem: Hashable {
        var member: Member
        var isManager: Bool
        var imageURL: String
        
        init(member: Member) {
            self.member = member
            self.isManager = member.isManager
            self.imageURL = member.imageURL
        }
    }
    
    // MARK: - UI
    
    private let reminderBarButton = UIBarButtonItem(image: .bell, style: .plain, target: nil, action: nil)
    
    private lazy var memberCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createMemberListLayout())
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.clipsToBounds = false
        return cv
    }()
    
    private let noticeSliderView = SliderView<NoticeView>()
    
    private let _mainTitleLabel = UILabel.title(title: AppText.mainTitle)
    
    private let currentStatusView = CurrentStatusView()
    
    private let calendarView = CalendarView()
    
    // MARK: - Properties
    
    private var memberListDataSource: MemberListDataSource!
    
    // MARK: - Dependencies
    
    private var viewModel: MainViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onLoad()
        setDataSource()
        setHierarchy()
        bindSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Swift.print(#fileID, "🐶🐶🐶 - view will appear")
    }
    
    func onLoad() {
        let appearance = UINavigationBarAppearance()
        appearance.titlePositionAdjustment = UIOffset(horizontal: -(view.frame.width / 2), vertical: 0)
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.red
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        let workplace = WorkplaceTable.get().first
        navigationItem.title = workplace?.workplaceName ?? "근무지 이름"
        navigationItem.rightBarButtonItem = reminderBarButton
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let onMemberTap = memberCollectionView.rx
            .itemSelected
            .compactMap { [unowned self] index in
                return memberListDataSource.itemIdentifier(for: index)?
                    .member
            }
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                showWorkplace: .empty(),
                changeWorkplace: .empty(),
                showRemainders: .empty(),
                onMemberTap: onMemberTap,
                onBarButtonTap: reminderBarButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await members in output.members.values {
                Swift.print(#fileID, "🐡🐡🐡 Did received members: \(members)")
                applyMemberSnapshot(members)
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
    }
    
    // MARK: - Data Source
    
    private func setDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MemberListItem> { (cell, indexPath, item) in
            var content = MemberContentView.Configuration()
            content.member = item.member
            cell.contentConfiguration = content
        }
        
        memberListDataSource = MemberListDataSource(collectionView: memberCollectionView) { (view, index, item) -> UICollectionViewCell? in
            return view.dequeueConfiguredReusableCell(using: cellRegistration, for: index, item: item)
        }
    }
    
    private func applyMemberSnapshot(_ members: [Member]) {
        let items = members.map(MemberListItem.init)
        var snapshot = MemberListSnapshot()
        snapshot.appendSections([.row])
        snapshot.appendItems(items, toSection: .row)
        memberListDataSource.apply(snapshot)
    }
    
    // MARK: - Hierarchy
    
    func layoutSubviews() {
        
    }
    
    private func setHierarchy() {
        view.backgroundColor = .systemBackground
        
        let stack = UIStackView(arrangedSubviews: [
            memberCollectionView,
            .separator,
            noticeSliderView,
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
        
        noticeSliderView.snp.makeConstraints { make in
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
}

