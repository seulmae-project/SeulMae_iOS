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
    
    private let addNewWorkplaceButton: UIButton = {
        let button = UIButton.common()
        button.setTitle("근무지 생성", for: .normal)
        button.setTitleColor(.lightPrimary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .primary
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        return button
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
                query: .empty(),
                onSearch: .empty(),
                selected: selected,
                addNewPlace: addNewWorkplaceButton.rx.tap.asSignal()
            )
        )
        //
        Task {
            for await item in output.item.values {
                Swift.print(#line, "\(item.workplaceList.count) items have been applied")
                let items = item.workplaceList.map {
                    return Item(
                        id: $0.id,
                        placeName: $0.name,
                        placeAddress: ($0.mainAddress + $0.subAddress),
                        placeTel: $0.contact,
                        placeMananger: $0.manager
                    )
                }
                applySnapshot(items: items)
            }
        }
    }
    
    struct Item: Hashable {
        let id: Workplace.ID
        let placeName: String
        let placeAddress: String
        let placeTel: String
        let placeMananger: String
    }
    

    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Nav Item
    
    private func setupNavItem() {
        navigationItem.title = "근무지 검색" // controller에 설정하면 안됌
    }
    
    // MARK: - Hierarchy
    
    private func setupConstraints() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(addNewWorkplaceButton)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addNewWorkplaceButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 56),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addNewWorkplaceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addNewWorkplaceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addNewWorkplaceButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            addNewWorkplaceButton.heightAnchor.constraint(equalToConstant: 56),
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
            content.workplaceName = item.placeName
            content.workplaceAddress = item.placeAddress
            content.workplaceContact = item.placeTel
            content.workplaceMananger = item.placeMananger
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    // MARK: - UICollectionViewLayout
    
    func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.25)))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0)),
            subitems: [item])
        group.interItemSpacing = .fixed(8.0)
        let section = NSCollectionLayoutSection(group: group)
         section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension SearchWorkplaceViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
