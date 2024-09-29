//
//  SearchWorkplaceViewController.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchWorkplaceViewController: UIViewController {
        
    // MARK: - Internal Types
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, Hashable, CaseIterable {
        case list
    }
    
    struct Item: Hashable {
        let id: Workplace.ID
        let placeName: String
        let placeAddress: String
        let placeTel: String
        let placeMananger: String
    }
    
    // MARK: - UI Properties
    
    private let searchBar = SearchBarView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - Dependencies

    private var viewModel: SearchWorkplaceViewModel!
    
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
        
        setupView()
        setupNavItem()
        setupConstraints()
        setupDataSource()
        bindSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asSignal()
        
        onLoad.emit(onNext: { _ in
            Swift.print(#line, "onLoad")
        })
        .dispose()
        
        let selected = collectionView.rx
            .itemSelected
            .compactMap { [weak self] index in
                self?.dataSource?.itemIdentifier(for: index)
            }
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                query: searchBar.queryTextField.rx.text.orEmpty.asDriver(),
                onSearch: .empty(),
                selected: selected
            )
        )
        
        Task {
            for await item in output.item.values {
                applySnapshot(items: item.toListItem())
            }
        }
    }
    
    // MARK: - Nav Item
    
    private func setupNavItem() {
        navigationItem.title = "근무지 검색"
    }
    
    // MARK: - Hierarchy

    private func setupView() {
        view.backgroundColor = .systemBackground
    }

    private func setupConstraints() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 56),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - DataSource
    
    private func setupDataSource() {
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
            content.name = item.placeName
            content.mainAddress = item.placeAddress
            content.contact = item.placeTel
            content.manager = item.placeMananger
            // content.showsSeparator =
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    // MARK: - UICollectionViewLayout
    
    func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(132)))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(132)),
            subitems: [item])
        group.interItemSpacing = .fixed(4.0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8.0, leading: 0, bottom: 8.0, trailing: 0)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
