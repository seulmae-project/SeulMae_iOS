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
    typealias Item = WorkplaceFinderItem
    
    enum Section: Int, CustomStringConvertible, CaseIterable {
        case finder, sumitState, workplace
        
        var title: String {
            switch self {
            case .finder:
                "근무지 참여하기"
            case .sumitState:
                "가입 대기중인 근무지"
            case .workplace:
                "내 근무지 리스트"
            }
        }
        
        var description: String {
            switch self {
            case .finder:
                "참여하거나 새로운 근무지를 만들어요"
            case .sumitState:
                "승인이되면 알림으로 알려드려요"
            case .workplace:
                "내가 가입한 근무지 리스트에요"
            }
        }
    }
    
    // MARK: - UI
    
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
        
        setupView()
        setupConstraints()
        setupDataSource()
        bindSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map { _ in return () }
            .asSignal()
        let onRefresh = refreshControl.rx
            .controlEvent(.valueChanged)
            .map { _ in }
            .asSignal()
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                onRefresh: onRefresh,
                search: findRelay.asSignal(),
                create: createRelay.asSignal()
            )
        )
        
        Task {
            for await loading in output.loading.values {
                loadingIndicator.ext.isAnimating(loading)
            }
        }
        
        Task {
            for await items in output.items.values {
                guard let item = items.first else { return }
                var snapshot = Snapshot()
                snapshot.appendSections(Section.allCases)
                snapshot.appendItems([Item()], toSection: .finder)
                switch item.type {
                case .finder:
                    break
                case .sumitState:
                    snapshot.appendItems(items, toSection: .sumitState)
                case .workplace:
                    snapshot.appendItems(items, toSection: .workplace)
                }
                dataSource.apply(snapshot)
            }
        }
    }
    
    // MARK: - Hierarchy
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
    }
    
    // MARK: - DataSource
    
    private func setupDataSource() {
        let finderCellRegistration = createFinderCellRegistration()
        let submitStateCellRegistration = createSubmitStateCellRegistration()
        let workplaceCellRegistration = createWorkplaceCellRegistration()
        let headerCellRegistration = createHeaderCellRegistration()
        let footerCellRegistration = createFooterCellRegistration()
        dataSource = DataSource(collectionView: collectionView) { (view, index, item) in
            guard let section = Section(rawValue: index.section) else { return nil }
            switch section {
            case .finder:
                return view.dequeueConfiguredReusableCell(using: finderCellRegistration, for: index, item: item)
            case .sumitState:
                return view.dequeueConfiguredReusableCell(using: submitStateCellRegistration, for: index, item: item)
            case .workplace:
                return view.dequeueConfiguredReusableCell(using: workplaceCellRegistration, for: index, item: item)
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
            return (kind == OutlineSupplementaryView.reuseIdentifier)
            ? view.dequeueConfiguredReusableSupplementary(
                using: headerCellRegistration, for: indexPath)
            : view.dequeueConfiguredReusableSupplementary(using: footerCellRegistration, for: indexPath)
        }
        
        applyInitialSnapshot()
    }
    
    // MARK: - Snapshot
    
    func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([Item()], toSection: .finder)
        dataSource?.apply(snapshot)
    }
    
    // MARK: - Cell Registration
    
    private func createFinderCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, index, item in
            guard case .finder = item.type else { return }
            var content = WorkplaceFinderContentView.Configuration()
            content.onSearch = { [weak self] in
                self?.findRelay.accept(())
            }
            content.onCreate = { [weak self] in
                self?.createRelay.accept(())
            }
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    private func createSubmitStateCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, index, item in
            
        }
    }
    
    private func createWorkplaceCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, index, item in
            guard case .workplace = item.type else { return }
            var content = WorkplaceContentView.Configuration()
            content.name = item.workplace?.name ?? ""
            content.imageUrl = item.workplace?.thumbnailURL ?? ""
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    func createHeaderCellRegistration() -> UICollectionView.SupplementaryRegistration<OutlineSupplementaryView> {
        return .init(elementKind: OutlineSupplementaryView.reuseIdentifier) { (supplementaryView, string, indexPath) in
            guard let section = Section(rawValue: indexPath.section) else {
                Swift.fatalError("Unknown section!")
            }
            
            supplementaryView.titleLabel.ext
                .setText(section.title, size: 24, weight: .semibold)
            supplementaryView.descriptionLabel.ext
                .setText(section.description, size: 16, weight: .regular, color: .secondaryLabel)
            
            let showSeparator = !(section == .finder)
            supplementaryView.showsSeparator = false
        }
    }
    
    func createFooterCellRegistration() -> UICollectionView.SupplementaryRegistration<SeparatorSupplementaryView> {
        return UICollectionView.SupplementaryRegistration
        <SeparatorSupplementaryView>(elementKind: SeparatorSupplementaryView.reuseIdentifier) { supplementaryView, elementKind, indexPath in
            
        }
    }
    
    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else {
                Swift.fatalError("Unknown section!")
            }
            
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(12))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: OutlineSupplementaryView.reuseIdentifier,
                alignment: .top)
            let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: SeparatorSupplementaryView.reuseIdentifier,
                alignment: .bottom)
            
            let section: NSCollectionLayoutSection
            switch sectionKind {
            case .finder:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(200)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(200)),
                    subitems: [item])
                group.interItemSpacing = .fixed(12)
                section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
            case .sumitState:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(100)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(0.9),
                        heightDimension: .absolute(100)),
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.interGroupSpacing = 20
                section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
            case .workplace:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(100)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(100)),
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [sectionHeader]
            }
            
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
}
