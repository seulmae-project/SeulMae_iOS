//
//  NotiListViewController.swift
//  SeulMae
//
//  Created by 조기열 on 7/22/24.
//

import UIKit
import RxSwift
import RxCocoa

final class NotiListViewController: UIViewController {
    
    // MARK: - Internal Types
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, NotiListItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, NotiListItem>
    
    enum Section: Int, CaseIterable, Hashable {
        case category
        case list
    }
    
    // MARK: - UI
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - Dependencies
    
    private var viewModel: NotiListViewModel!
    
    // MARK: - Life Cycle
    
    init(viewModel: NotiListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavItem()
        setupView()
        setupConstraints()
        setupDataSource()
        bindSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asSignal()
        let onRefresh = refreshControl.rx
            .controlEvent(.valueChanged)
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
                onRefresh: onRefresh,
                onItemTap: onItemTap
            )
        )
        
        Task {
            for await items in output.categories.values {
                applyCategories(items: items)
            }
        }
        
        Task {
            for await items in output.notiList.values {
                applyNotiList(items: items)
            }
        }
    }
    
    // MARK: - Data Source
    
    private func setupDataSource() {
        let categoryCellRegistration = UICollectionView.CellRegistration<TextCell, NotiListItem> { (cell, indexPath, item) in
            guard let category = item.category else { return }
            cell.label.text = category
            cell.label.font = .pretendard(size: 15, weight: .regular)
            cell.label.textAlignment = .center
            cell.layer.cornerRadius = 8.0
            cell.layer.cornerCurve = .circular
            cell.layer.borderColor = UIColor(hexCode: "EEEEEE").cgColor
            cell.layer.borderWidth = 1.0
            // TODO: category 에 따라 다르게
            // cell.label.textColor = .graphite
            // 선택된 카테고리인지 확인
        }
        
        let notiCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, NotiListItem> { (cell, indexPath, item) in
            var content = NotiContentView.Configuration()
            guard let noti = item.noti else { return }
            content.type = noti.type.rawValue
            content.date = noti.regDate
            content.title = noti.title
            content.message = noti.message
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
        
        dataSource = DataSource(collectionView: collectionView) { (view, index, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: index.section) else { Swift.fatalError("Unknown section") }
            switch section {
            case .category:
                return view.dequeueConfiguredReusableCell(using: categoryCellRegistration, for: index, item: item)
            case .list:
                return view.dequeueConfiguredReusableCell(using: notiCellRegistration, for: index, item: item)
            }
        }
    }
    
    private func applyCategories(items: [NotiListItem]) {
        let categories = items.filter { $0.type == .category }
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(categories, toSection: .category)
        dataSource.apply(snapshot)
    }
    
    private func applyNotiList(items: [NotiListItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteSections([.list])
        snapshot.appendSections([.list])
        let notiList = items.filter { $0.type == .noti }
        snapshot.appendItems(notiList, toSection: .list)
        dataSource.apply(snapshot)
    }
    
    // MARK: - Hierarchy
    
    private func setupNavItem() {
        navigationItem.title = "알림"
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - CollectionView Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { Swift.fatalError("Unknown section") }
            var section: NSCollectionLayoutSection
            switch sectionKind {
            case .category:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .estimated(58),
                        heightDimension: .estimated(36)),
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
                section.interGroupSpacing = 8.0
            case .list:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1/8)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)),
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            }
            return section
        }
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider)
        return layout
    }
}
