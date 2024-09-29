//
//  WorkplaceViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WorkplaceViewController: UIViewController {
    
    // MARK: - Internal Types
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WorkplaceListItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, WorkplaceListItem>
    
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case members, announceList, workSchedules
        
        var description: String {
            switch self {
            case .members: return ""
            case .announceList: return "공지사항"
            case .workSchedules: return "근무일정"
            }
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // collectionView.showsHorizontalScrollIndicator = false
        // collectionView.showsVerticalScrollIndicator = false
        //  collectionView.directionalLayoutMargins = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        // collectionView.contentInset = .init(top: 20, left: 20, bottom: 40, right: -40)
        return collectionView
    }()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    private var showAnnounceListRelay = PublishSubject<()>()
    private var showScheduleListRelay = PublishSubject<()>()
    
    // MARK: - Dependencies
    
    private var viewModel: WorkplaceViewModel
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: WorkplaceViewModel) {
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
        setupDataSource()
        bindSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let showMemberDetails = collectionView.rx
            .itemSelected
            .compactMap { [weak self] indexPath in
                self?.dataSource?
                    .itemIdentifier(for: indexPath)?
                    .member
            }
            .asSignal()
        
        let showAnnounceDetails = collectionView.rx
            .itemSelected
            .compactMap { [weak self] indexPath in
                self?.dataSource?
                    .itemIdentifier(for: indexPath)?
                    .announce?
                    .id
            }
            .asSignal()
        
        let showWorkScheduleDetails = collectionView.rx
            .itemSelected
            .compactMap { [weak self] indexPath in
                self?.dataSource?
                    .itemIdentifier(for: indexPath)?
                    .workSchedule?
                    .id
            }
            .asSignal()
        
        let a = showAnnounceListRelay.asSignal()
        Task {
            for await _ in a.values {
                Swift.print(" show list !")
            }
        }
        let output = viewModel.transform(
            .init(
                showMemberDetails: showMemberDetails,
                showAnnounceList: a,
                showAnnounceDetails: showAnnounceDetails,
                showWorkScheduleList: showScheduleListRelay.asSignal(),
                showWorkScheduleDetails: showWorkScheduleDetails
            )
        )
        
        Task {
            for await loading in output.loading.values {
                
            }
        }
        
        Task {
            for await items in output.listItems.values {
                guard let item = items.first else { return }
                var snapshot = dataSource.snapshot()
                switch item.itemType {
                case .member:
                    let oldItems = snapshot.itemIdentifiers(inSection: .members)
                    snapshot.deleteItems(oldItems)
                    snapshot.appendItems(items, toSection: .members)
                case .announce:
                    let oldItems = snapshot.itemIdentifiers(inSection: .announceList)
                    snapshot.deleteItems(oldItems)
                    snapshot.appendItems(items, toSection: .announceList)
                case .workSchedule:
                    let oldItems = snapshot.itemIdentifiers(inSection: .workSchedules)
                    snapshot.deleteItems(oldItems)
                    snapshot.appendItems(items, toSection: .workSchedules)
                }
                dataSource.apply(snapshot)
            }
        }
    }
    
    // MARK: - Hierarchy
    
    private func setupConstraints() {
        view.addSubview(collectionView)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - DataSource
    
    private func setupDataSource() {
        let headerCellRegistration = createHeaderCellRegistration()
        let memberCellRegistration = createMemberCellRegistration()
        let announceCellRegistration = createAnnounceCellRegistration()
        let workScheduleCellRegistration = createWorkScheduleCellRegistration()
        
        dataSource = DataSource(collectionView: collectionView) { (view, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { Swift.fatalError("Unknown section") }
            switch section {
            case .members:
                return view.dequeueConfiguredReusableCell(using: memberCellRegistration, for: indexPath, item: item)
            case .announceList:
                return view.dequeueConfiguredReusableCell(using: announceCellRegistration, for: indexPath, item: item)
            case .workSchedules:
                return view.dequeueConfiguredReusableCell(using: workScheduleCellRegistration, for: indexPath, item: item)
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
            return view.dequeueConfiguredReusableSupplementary(
                using: headerCellRegistration, for: indexPath)
        }
        
        // initial data
        let sections = Section.allCases
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - CellRegistration
    
    func createHeaderCellRegistration() -> UICollectionView.SupplementaryRegistration<TitleSupplementaryView> {
        return UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: "section-header-element-kind") {
            (supplementaryView, string, indexPath) in
            let section = Section(rawValue: indexPath.section)
            supplementaryView.label.text = section?.description ?? ""
            supplementaryView.label.font = .pretendard(size: 14, weight: .regular)
            supplementaryView.label.textColor = .secondaryLabel
            guard let section else { return }
            switch section {
            case .members:
                supplementaryView.button.isHidden = true
            case .announceList:
                supplementaryView.button.setTitle("전체", for: .normal)
                supplementaryView.button.titleLabel?.font = .pretendard(size: 14, weight: .regular)
                supplementaryView.button.setTitleColor(.secondaryLabel, for: .normal)
                Task {
                    for await _ in supplementaryView.button.rx.tap.asSignal().values {
                        self.showAnnounceListRelay.onNext(())
                    }
                }
//                supplementaryView.button.rx.tap.bind(to: self.showAnnounceListRelay).dispose()
            case .workSchedules:
                supplementaryView.button.setTitle("전체", for: .normal)
                supplementaryView.button.titleLabel?.font = .pretendard(size: 14, weight: .regular)
                supplementaryView.button.setTitleColor(.secondaryLabel, for: .normal)
                supplementaryView.button.rx.tap.bind(to: self.showScheduleListRelay)
                    .disposed(by: self.disposeBag) // DisposeBag() 생성시 안됌
                // dispoase 도 안됌 ㅇ??
            }
        }
    }
    
    func createMemberCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem>  {
        return UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem> { (cell, indexPath, item) in
            var content = cell.memberContentConfiguration()
            guard case .member = item.itemType,
                  let member = item.member else { return }
            content.member = member
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    func createAnnounceCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem>  {
        return UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem> { (cell, indexPath, item) in
            var content = cell.announceSummeryContentConfiguration()
            guard case .announce = item.itemType,
                  let announce = item.announce else { return }
            content.announce = announce
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    func createWorkScheduleCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem>  {
        return UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem> { (cell, indexPath, item) in
            var content = cell.workScheduleContentConfiguration()
            guard case .workSchedule = item.itemType,
                  let workSchedule = item.workSchedule else { return }
            content.workSchedule = workSchedule
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { Swift.fatalError("Unknown section!") }
            let section: NSCollectionLayoutSection
            switch sectionKind {
            case .members:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0 / 7.0),
                                      heightDimension: .estimated(44)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .estimated(44)),
                    subitems: [item])
                group.interItemSpacing = .fixed(12)
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.interGroupSpacing = 12
            case .announceList:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .absolute(64)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(0.9),
                                      heightDimension: .absolute(64)),
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.interGroupSpacing = 20
            case .workSchedules:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .absolute(180)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .absolute(180)),
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 12
            }
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: "section-header-element-kind",
                alignment: .top, absoluteOffset: .init(x: 0, y: -12))
            section.boundarySupplementaryItems = [sectionHeader]
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
}
