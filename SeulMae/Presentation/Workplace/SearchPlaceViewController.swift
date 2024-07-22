//
//  SearchPlaceViewController.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchPlaceViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: SearchPlaceViewModel) -> SearchPlaceViewController {
        let view = SearchPlaceViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: - Internal Types
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, Hashable, CaseIterable {
        case list
    }
    
    struct Item: Hashable {
        let placeName: String
        let placeAddress: String
        let placeTel: String
        let placeMananger: String
    }
    
    // MARK: - UI Properties
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        let attr = NSAttributedString(string: "행사 검색")
        //[NSAttributedString.Key.foregroundColor: UIColor.accentColor]
        controller.searchBar.searchTextField.attributedPlaceholder = attr
        controller.searchBar.searchTextField.leftView?.tintColor = .black
        controller.hidesNavigationBarDuringPresentation = true
        controller.showsSearchResultsController = true
        controller.searchResultsUpdater = self
        return controller
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let addNewPlaceButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - Dependencies

    private var viewModel: SearchPlaceViewModel!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavItem()
        configureHierarchy()
        configureDataSource()
        bindInternalSubviews()
    }
    
    // MARK: - Nav Item
    
    private func configureNavItem() {
     
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
        let output = viewModel.transform(
            .init(
                query: .empty(),
                onSearch: .empty(),
                onTap: .empty(),
                addNewPlace: .empty()
            )
        )
    }
    
    // MARK: - Hierarchy
    
    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
    
    }
    
    // MARK: - DataSource
    
    private func configureDataSource() {
        let workplaceCellRegistration = createWorkplaceCellRegistration()
        
        dataSource = DataSource(collectionView: collectionView) { (view, index, item) in
            view.dequeueConfiguredReusableCell(using: workplaceCellRegistration, for: index, item: item)
        }
    }
    
    // MARK: - Snapshot
    
    private func applySnapshot(items: [Item]) {
        var snapshot = Snapshot()
        let sections = Section.allCases
        snapshot.appendSections(sections)
        snapshot.appendItems(items, toSection: .list)
        dataSource.apply(snapshot)
    }
    
    // MARK: - Cell Registration
    
    private func createWorkplaceCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, index, item in
            var content = WorkplaceContentView.Configuration()
            content.placeName = item.placeName
            content.placeAddress = item.placeAddress
            content.placeTel = item.placeTel
            content.placeMananger = item.placeMananger
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

extension SearchPlaceViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
