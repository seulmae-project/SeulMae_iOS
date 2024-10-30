//
//  PlaceFinderViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PlaceFinderViewController: BaseViewController {
    
    // MARK: - Internal Types

    typealias DataSource = UICollectionViewDiffableDataSource<PlaceFinderSection, WorkplaceFinderItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PlaceFinderSection, WorkplaceFinderItem>
   
    // MARK: - UI Properties

    private var leftMenuBarButton = UIBarButtonItem(image: .menu, style: .plain, target: nil, action: nil)
    private var rightBellBarButton = UIBarButtonItem(image: .bell, style: .plain, target: nil, action: nil)
    private lazy var collectionView: UICollectionView = Ext.common(frame: view.bounds, layout: createLayout(), backgroundColor: UIColor(hexCode: "F2F3F5"), refreshControl: refreshControl)

    // MARK: - Properties

    private var viewModel: WorkplaceFinderViewModel!
    private var dataSource: DataSource!
    private var findRelay = PublishRelay<()>()
    private var createRelay = PublishRelay<()>()
    
    // MARK: - Life Cycle Methods
    
    convenience init(viewModel: WorkplaceFinderViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavItem()
        configureHierarchy()
        configureDataSource()
        bindInternalSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
        let onItemTap = collectionView.rx.itemSelected.asSignal()
        let onReminderTap = onItemTap
            .asSignal()
            .filter { $0.section == 0 }
            .map { _ in () }
        let onCardTap = onItemTap
            .filter { $0.section == 1 }
            .map { $0.item }

        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                onRefresh: onRefresh,
                showMenu: leftMenuBarButton.rx.tap.asSignal(),
                showReminders: rightBellBarButton.rx.tap.asSignal(),
                onReminderTap: onReminderTap,
                onCardTap: onCardTap,
                search: findRelay.asSignal(),
                create: createRelay.asSignal()
            )
        )

        output.items
            .drive(with: self, onNext: { (self, items) in
                guard let item = items.first else { return }
                if (item.section == .reminder) && (item.notifications?.isEmpty ?? true) {
                    var snapshot = self.dataSource.snapshot()
                    let items = snapshot.itemIdentifiers(inSection: .reminder)
                    if !(items.isEmpty) {
                        snapshot.deleteItems(items)
                        self.dataSource.apply(snapshot)
                    }
                    return
                }
                var snapshot = self.dataSource.snapshot()
                let applied = snapshot.itemIdentifiers(inSection: item.section!)
                snapshot.deleteItems(applied)
                snapshot.appendItems(items, toSection: item.section!)
                self.dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)

        output.loading.drive(loadingIndicator.ext.isAnimating)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Hierarchy

    private func configureNavItem() {
        navigationItem.rightBarButtonItem = rightBellBarButton
        navigationItem.leftBarButtonItem = leftMenuBarButton
        let iconImageView: UIImageView = .common(image: .signinAppIcon)
        // TODO: add action to icon image view
        navigationItem.titleView = iconImageView
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    // MARK: - DataSource
    
    private func configureDataSource() {
        let headerCellRegistration = createHeaderCellRegistration()
        let reminderCellRegistration = createReminderCellRegistiration()
        let cardCellRegistration = createCardCellRegistiration()
        let workplaceCellRegistration = createWorkplaceCellRegistration()
        let submitStateCellRegistration = createApplicationCellRegistration()

        dataSource = DataSource(collectionView: collectionView) { (view, index, item) in
            guard let section = PlaceFinderSection(rawValue: index.section) else { Swift.fatalError("Unknown section!") }
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
        
        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
            return view.dequeueConfiguredReusableSupplementary(
                using: headerCellRegistration, for: indexPath)
        }
        
        applyInitialSnapshot()
    }
    
    // MARK: - Snapshot
    
    private func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(PlaceFinderSection.allCases)
        snapshot.appendItems(WorkplaceFinderItem.cards, toSection: .card)
        // TODO: Empty view
        dataSource?.apply(snapshot)
    }
    
    // MARK: - Cell Registration

    func createHeaderCellRegistration() -> UICollectionView.SupplementaryRegistration<OutlineSupplementaryView> {
        return .init(elementKind: OutlineSupplementaryView.reuseIdentifier) { supplementaryView, elementKind, indexPath in
            guard let section = PlaceFinderSection(rawValue: indexPath.section) else { Swift.fatalError("Unknown section!") }
            supplementaryView.titleLabel.text = section.title
            supplementaryView.descriptionLabel.text = section.description
        }
    }

    private func createReminderCellRegistiration() -> UICollectionView.CellRegistration<UICollectionViewListCell, WorkplaceFinderItem> {
        return .init { cell, indexPath, item in
            guard case .reminder = item.section else { return }
            var content = ReminderCountContentView.Configuration()
            content.remiderCount = item.notifications?.count
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
            var content = PlaceInfoDetailsContentView.Configuration()
            content.workplace = item.workplace
            content.memberList = item.memberList
            cell.contentConfiguration = content
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = .white
            backgroundConfig.cornerRadius = 8.0
            cell.backgroundConfiguration = backgroundConfig
        }
    }

    private func createApplicationCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, WorkplaceFinderItem> {
        return .init { cell, indexPath, item in
            guard case .application = item.section else { return }
            var content = PlaceInfoContentView.Configuration()
            content.workplace = item.workplace
            cell.contentConfiguration = content
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
            guard let section = PlaceFinderSection(rawValue: sectionIndex) else { Swift.fatalError("Unknown section!") }
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
            heightDimension: .fractionalWidth(0.18))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
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
            heightDimension: .estimated(177))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .estimated(177))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: OutlineSupplementaryView.reuseIdentifier,
            alignment: .top)// , absoluteOffset: .init(x: 0, y: -12))
        section.boundarySupplementaryItems = [sectionHeader]
        // PLay with some animation and scrollOffest
//        section.visibleItemsInvalidationHandler = { items, offset, environment in
//            let _itmes = items.filter { $0.indexPath.section == Section.workplace.rawValue }
//            _itmes.forEach { item in
//                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
//                let minScale: CGFloat = 0.8
//                let maxScale: CGFloat = 1.0
//                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
//                item.transform = CGAffineTransform(scaleX: scale, y: scale)
//            }
//        }
        return section
    }

    static func makeApplicationSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(104))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(104))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: OutlineSupplementaryView.reuseIdentifier,
            alignment: .top)// , absoluteOffset: .init(x: 0, y: -12))
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}
