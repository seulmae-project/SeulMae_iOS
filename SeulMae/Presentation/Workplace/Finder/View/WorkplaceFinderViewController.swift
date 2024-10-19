//
//  WorkplaceFinderViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WorkplaceFinderViewController: BaseViewController {
    
    // MARK: - Internal Types
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, WorkplaceFinderItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WorkplaceFinderItem>

    enum Section: Int, CaseIterable {
        case reminder, card, workplace, application
    }
    
    // MARK: - UI Properties

    private var leftMenuBarButton: UIBarButtonItem = .init(image: .menu, style: .plain, target: nil, action: nil)
    private var rightBellBarButton: UIBarButtonItem = .init(image: .bell, style: .plain, target: nil, action: nil)

    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = UIColor(hexCode: "F2F3F5")
        return collectionView
    }()

    // MARK: - Properties
    
    private var viewModel: WorkplaceFinderViewModel
    private var dataSource: DataSource!
    private var findRelay = PublishRelay<()>()
    private var createRelay = PublishRelay<()>()
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: WorkplaceFinderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavItem()
        configureHierarchy()
        setupDataSource()
        bindSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map { _ in return () }
            .asSignal()
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                onRefresh: refreshControl.rx.controlEvent(.valueChanged).asSignal(),
                search: findRelay.asSignal(),
                create: createRelay.asSignal()
            )
        )

        output.items
            .drive(with: self, onNext: { (self, items) in
                guard let item = items.first else { return }
                var snapshot = self.dataSource.snapshot()
                let applied = snapshot.itemIdentifiers(inSection: item.section!)
                snapshot.deleteItems(applied)
                snapshot.appendItems(items, toSection: item.section!)
                self.dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)

        output.loading
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Hierarchy

    private func configureNavItem() {
        navigationItem.rightBarButtonItem = rightBellBarButton
        navigationItem.leftBarButtonItem = leftMenuBarButton
        let iconImageView: UIImageView = .common(image: .seulmae)
        // TODO: add action to icon image view
        navigationItem.titleView = iconImageView
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    // MARK: - DataSource
    
    private func setupDataSource() {
        let reminderCellRegistration = createReminderCellRegistiration()
        let cardCellRegistration = createCardCellRegistiration()
        let workplaceCellRegistration = createWorkplaceCellRegistration()
        let submitStateCellRegistration = createApplicationCellRegistration()

        dataSource = DataSource(collectionView: collectionView) { (view, index, item) in
            guard let section = Section(rawValue: index.section) else {
                Swift.fatalError("Unknown section!")
            }

            switch section {
            case .reminder:
                return view.dequeueConfiguredReusableCell(using: reminderCellRegistration, for: index, item: item)
            case .card:
                return view.dequeueConfiguredReusableCell(using: cardCellRegistration, for: index, item: item)
            case .workplace:
                return view.dequeueConfiguredReusableCell(using: workplaceCellRegistration, for: index, item: item)
            case .application:
                return view.dequeueConfiguredReusableCell(using: submitStateCellRegistration, for: index, item: item)
            }
        }
        
//        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
//            return (kind == OutlineSupplementaryView.reuseIdentifier)
//            ? view.dequeueConfiguredReusableSupplementary(
//                using: headerCellRegistration, for: indexPath)
//            : view.dequeueConfiguredReusableSupplementary(using: footerCellRegistration, for: indexPath)
//        }
        
        applyInitialSnapshot()
    }
    
    // MARK: - Snapshot
    
    private func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(WorkplaceFinderItem.cards, toSection: .card)
        snapshot.appendItems([.empty(section: .workplace)], toSection: .workplace)
        snapshot.appendItems([.empty(section: .application)], toSection: .application)
        // TODO: Empty view
        dataSource?.apply(snapshot)
    }
    
    // MARK: - Cell Registration

    private func createReminderCellRegistiration() -> UICollectionView.CellRegistration<UICollectionViewListCell, WorkplaceFinderItem> {
        return .init { cell, indexPath, item in
            guard case .reminder = item.section else { return }
            var content = ReminderCountContentView.Configuration()
            content.remiderCount = item.reminders?.count
            cell.contentConfiguration = content
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = .white
            backgroundConfig.cornerRadius = 8.0
            cell.backgroundConfiguration = backgroundConfig
        }
    }

    private func createCardCellRegistiration() -> UICollectionView.CellRegistration<UICollectionViewListCell, WorkplaceFinderItem> {
        return .init { cell, indexPath, item in
            guard case .card = item.section else { return }
            var content = CardContentView.Configuration()
            content.title = item.title
            content.icon = item.icon
            cell.contentConfiguration = content
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = .white
            backgroundConfig.cornerRadius = 8.0
            cell.backgroundConfiguration = backgroundConfig
        }
    }

    private func createWorkplaceCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, WorkplaceFinderItem> {
        return .init { cell, indexPath, item in
            guard case .workplace = item.section else { return }
            if item.isEmpty {
                var content = EmptyContentView.Configuration()
                content.image = item.image
                content.message = item.message
                cell.contentConfiguration = content
            } else {
                var content = WorkplaceContentView.Configuration()
                // content.imageURL = item.workplace.
                // content. // 영업 중
                // content.workTime // 8:00 - 11:00
                content.name = item.workplace?.name
                content.address = item.workplace?.address?.mainAddress
                content.subAdress = item.workplace?.address?.subAddress
                // content. // 오전 A팀 근무 중
                content.memberList = item.memberList
                cell.contentConfiguration = content
            }
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = .white
            backgroundConfig.cornerRadius = 8.0
            cell.backgroundConfiguration = backgroundConfig
        }
    }

    private func createApplicationCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, WorkplaceFinderItem> {
        return .init { cell, indexPath, item in
            guard case .application = item.section else { return }
            if item.isEmpty {
                var content = EmptyContentView.Configuration()
                content.image = item.image
                content.message = item.message
                cell.contentConfiguration = content
            } else {
                var content = ApplicationContentView.Configuration()
                content.name = item.workplace?.name
                content.address = item.workplace?.mainAddress
                content.subAdress = item.workplace?.subAddress
                cell.contentConfiguration = content
            }
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = .white
            backgroundConfig.cornerRadius = 8.0
            cell.backgroundConfiguration = backgroundConfig
        }
    }

    // MARK: - UICollectionViewLayout

    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 12
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else {
                Swift.fatalError("Unknown section!")
            }

            switch section {
            case .reminder:
                return Self.makeReminderSectionLayout()
            case .card:
                return Self.makeCardSectionLayout()
            case .workplace:
                return Self.makeWorkplaceSectionLayout()
            case .application:
                return Self.makeApplicationSectionLayout()
            }
        }, configuration: config)
    }

    static func makeReminderSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.16))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
    }

    static func makeCardSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
    }

    static func makeWorkplaceSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(230))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(230))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
    }

    static func makeApplicationSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(56))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(56))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
    }
}
