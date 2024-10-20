//
//  SearchWorkplaceViewController.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchWorkplaceViewController: BaseViewController {

    // MARK: - Internal Types

    typealias DataSource = UICollectionViewDiffableDataSource<Section, SearchWorkplaceItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SearchWorkplaceItem>

    enum Section: Int, Hashable, CaseIterable {
        case history
        case list
    }
    
    // MARK: - UI Properties
    
    private let searchBar = SearchBarView()

    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout(isEmpty: true))
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - Dependencies

    private var viewModel: SearchWorkplaceViewModel
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: SearchWorkplaceViewModel) {
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

        let selectedItem = collectionView.rx
            .itemSelected
            .compactMap { [weak self] index in
                self?.dataSource?.itemIdentifier(for: index)
            }
            .asSignal()

        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                onRefresh: refreshControl.rx.controlEvent(.valueChanged).asSignal(),
                query: searchBar.textField.rx.text.orEmpty.asDriver(),
                onSearch: .empty(),
                onItemTap: selectedItem
            )
        )

        output.items
            .drive(with: self, onNext: { (self, items) in
                guard let item = items.first else { return }
                var snapshot = self.dataSource.snapshot()
                let applied = snapshot.itemIdentifiers(inSection: item.section!)
                snapshot.deleteItems(applied)
                self.dataSource.apply(snapshot)
                snapshot.appendItems(items, toSection: item.section!)
                if (applied.first?.isEmpty ?? false) {
                    let layout = self.createLayout(isEmpty: false)
                    self.collectionView.setCollectionViewLayout(layout, animated: true)
                }
                self.dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)

        output.loading
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Nav Item
    
    private func configureNavItem() {
        navigationItem.title = "근무지 검색"
    }
    
    // MARK: - Hierarchy

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        view.addSubview(searchBar)
        view.addSubview(collectionView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let insets = CGFloat(20)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets),
            searchBar.heightAnchor.constraint(equalToConstant: 56),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    // MARK: - DataSource
    
    private func configureDataSource() {
        let categoryCellRegistration = createCategoryCellRegistration()
        let queryCellRegistration = createQueryCellRegistration()
        let listEmptyCellRegistration = createListEmptyCellRegistration()

        dataSource = DataSource(collectionView: collectionView) { (view, index, item) in
            guard let section = Section(rawValue: index.section) else { Swift.fatalError("Unknown section") }
            switch section {
            case .history:
                return view.dequeueConfiguredReusableCell(using: categoryCellRegistration, for: index, item: item)
            case .list:
                return (!item.isEmpty) ?
                view.dequeueConfiguredReusableCell(using: queryCellRegistration, for: index, item: item) 
                : view.dequeueConfiguredReusableCell(using: listEmptyCellRegistration, for: index, item: item)
            }
        }

        applyInitialSnapshot()
    }
    
    // MARK: - Snapshot
    
    private func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(SearchWorkplaceItem.categories, toSection: .history)
        snapshot.appendItems(SearchWorkplaceItem.emtpy, toSection: .list)
        dataSource.apply(snapshot)
    }
    
    // MARK: - Cell Registration
    
    private func createCategoryCellRegistration() -> UICollectionView.CellRegistration<TextCell, SearchWorkplaceItem> {
        return .init(handler: { cell, indexPath, item in
            cell.label.text = item.category
            cell.label.font = .pretendard(size: 13, weight: .medium)
            cell.label.textAlignment = .center
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = UIColor(hexCode: "4C71F5")
            backgroundConfig.cornerRadius = 12
            cell.backgroundConfiguration = backgroundConfig
        })
    }

    private func createQueryCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, SearchWorkplaceItem> {
        return .init(handler: { cell, indexPath, item in
            var content = SearchedQueryContentView.Configuration()
            content.query = item.query
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        })
    }

    private func createListEmptyCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, SearchWorkplaceItem> {
        return .init(handler: { cell, indexPath, item in
            var content = EmptyContentView.Configuration()
            content.image = .warning
            content.message = item.emptyMessage
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        })
    }

    // MARK: - UICollectionViewLayout

    func createLayout(isEmpty: Bool) -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 12
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { Swift.fatalError("Unknown section!") }
            switch section {
            case .history:
                return Self.makeCategorySectionLayout()
            case .list:
                return !isEmpty
                ? Self.makeListSectionLayout()
                : Self.makeListEmptySectionLayout()
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
            heightDimension: .estimated(52))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(52))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        let insets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        section.contentInsets = insets
        return section
    }

    static func makeListEmptySectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let insets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        section.contentInsets = insets
        return section
    }

}
