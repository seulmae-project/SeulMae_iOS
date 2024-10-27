//
//  PlaceSearchViewController.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PlaceSearchViewController: BaseViewController {

    // MARK: - Internal Types

    typealias DataSource = UICollectionViewDiffableDataSource<Section, PlaceSearchItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PlaceSearchItem>

    enum Section: Int, Hashable, CaseIterable {
        case results
    }
    
    // MARK: - UI Properties
    
    private let searchBar = SearchBarView()
    private var emptyView = EmptyView(message: "해당하는 근무지를 찾을 수 없어요")
    private lazy var collectionView: UICollectionView = Ext.common(layout: createLayout(isEmpty: true), emptyView: emptyView, refreshControl: refreshControl)

    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - Dependencies

    private var viewModel: PlaceSearchViewModel!

    // MARK: - Life Cycle Methods
    
    convenience init(viewModel: PlaceSearchViewModel) {
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
        let selectedItem = collectionView.rx
            .itemSelected
            .withUnretained(self)
            .compactMap { (self, index) in
                self.dataSource.itemIdentifier(for: index)
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
                self.emptyView.isHidden = !(items.isEmpty)
                var snapshot = self.dataSource.snapshot()
                let applied = snapshot.itemIdentifiers(inSection: item.section!)
                snapshot.deleteItems(applied)
                self.dataSource.apply(snapshot)
                snapshot.appendItems(items, toSection: item.section!)
                self.dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)

        output.loading
            .drive(with: self, onNext: { (self, loading) in
                self.loadingIndicator.ext.bind(loading)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Nav Item
    
    private func configureNavItem() {
        navigationItem.title = "근무지 검색"
    }
    
    // MARK: - Hierarchy

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        
        let views = [searchBar, collectionView]
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let insets = CGFloat(20)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: insets),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    // MARK: - DataSource
    
    private func configureDataSource() {
        let queryCellRegistration = createPlaceCellRegistration()

        dataSource = DataSource(collectionView: collectionView) { (view, index, item) in
            guard let section = Section(rawValue: index.section) else { Swift.fatalError("Unknown section") }
            switch section {
            case .results:
                return view.dequeueConfiguredReusableCell(using: queryCellRegistration, for: index, item: item)
            }
        }

        applyInitialSnapshot()
    }
    
    // MARK: - Snapshot
    
    private func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot)
    }
    
    // MARK: - Cell Registration

    private func createPlaceCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, PlaceSearchItem> {
        return .init(handler: { cell, indexPath, item in
            var content = PlaceInfoContentView.Configuration()
            content.workplace = item.workplace
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        })
    }

    // MARK: - UICollectionViewLayout

    func createLayout(isEmpty: Bool) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { Swift.fatalError("Unknown section!") }
            switch section {
            case .results:
                return Self.makeSearchResultsSectionLayout()
            }
        })
    }

    static func makeSearchResultsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(104))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(104))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        return section
    }
}
