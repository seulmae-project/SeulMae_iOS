//
//  NotiListViewController.swift
//  SeulMae
//
//  Created by 조기열 on 7/22/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ReminderListViewController: BaseViewController {

    // MARK: - Internal Types
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ReminderListItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ReminderListItem>
    
    enum Section: Int, CaseIterable, Hashable {
        case category
        case list
    }
    
    // MARK: - UI Properties

    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!

    // MARK: - Dependencies
    
    private var viewModel: ReminderListViewModel!
    
    // MARK: - Life Cycle
    
    init(viewModel: ReminderListViewModel) {
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
        configureDataSource()
        bindInternalSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asSignal()
        let onItemTap = collectionView.rx
            .itemSelected
            .compactMap { [unowned self] index in
                return dataSource.itemIdentifier(for: index)
            }
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                onRefresh: refreshControl.rx.controlEvent(.valueChanged).asSignal(),
                onItemTap: onItemTap
            )
        )

        output.items
            .drive(with: self, onNext: { (self, items) in
                var snapshot = self.dataSource.snapshot()
                let applied = snapshot.itemIdentifiers(inSection: .list)
                snapshot.deleteItems(applied)
                snapshot.appendItems(items, toSection: .list)
                self.dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Data Source
    
    private func configureDataSource() {
        let categoryCellRegistration = createCategoryCellRegistiration()
        let reminderCellRegistration = createReminderCellRegistiration()

        dataSource = DataSource(collectionView: collectionView) { (view, index, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: index.section) else { Swift.fatalError("Unknown section") }
            switch section {
            case .category:
                return view.dequeueConfiguredReusableCell(using: categoryCellRegistration, for: index, item: item)
            case .list:
                return view.dequeueConfiguredReusableCell(using: reminderCellRegistration, for: index, item: item)
            }
        }

        applyInitialSnapshot()
    }

    // MARK: - Snapshot

    private func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(ReminderListItem.categories, toSection: .category)
        snapshot.appendItems([ReminderListItem.reminder(nil)], toSection: .list)
        dataSource.apply(snapshot)
    }

    // MARK: - Cell Registration

    private func createCategoryCellRegistiration() -> UICollectionView.CellRegistration<TextCell, ReminderListItem> {
        return .init { cell, indexPath, item in
            guard case .category = item.section else { return }
            cell.label.text = item.category
            cell.label.font = .pretendard(size: 15, weight: .regular)
            cell.label.textAlignment = .center
            cell.layer.cornerRadius = 8.0
            cell.layer.cornerCurve = .circular
            cell.layer.borderColor = UIColor(hexCode: "EEEEEE").cgColor
            cell.layer.borderWidth = 1.0
            cell.backgroundConfiguration = .clear()
        }
    }

    private func createReminderCellRegistiration() -> UICollectionView.CellRegistration<TextCell, ReminderListItem> {
        return .init { cell, indexPath, item in
            guard case .list = item.section else { return }
            var content = ReminderListContentView.Configuration()
            content.type = item.reminder?.type.rawValue
            content.title = item.reminder?.title
            content.message = item.reminder?.message
            content.date = item.reminder?.regDate
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }

    // MARK: - Hierarchy
    
    private func configureNavItem() {
        navigationItem.title = "알림"
    }
    
    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
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
            case .category:
                return Self.makeCategorySectionLayout()
            case .list:
                return Self.makeListSectionLayout()
            }
        }, configuration: config)
    }

    static func makeCategorySectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(56),
            heightDimension: .estimated(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(56),
            heightDimension: .estimated(40))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let insets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
        section.contentInsets = insets
        section.interGroupSpacing = 12
        return section
    }

    static func makeListSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(68))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(68))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        let insets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        section.contentInsets = insets
        return section
    }
}
