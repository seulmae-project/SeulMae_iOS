//
//  ManagerHomeViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ManagerHomeViewController: BaseViewController {
    
    // MARK: - Internal Types
    
    typealias Item = ManagerHomeItem
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ListItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ListItem>
    typealias ListItem = ManagerHomeListItem
    
    enum Section: Int, Hashable, CaseIterable {
        case list
    }
    
    // MARK: - UI
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "금일의 근무 요청을\n확인해 주세요"
        label.numberOfLines = 2
        label.font = .pretendard(size: 24, weight: .medium)
        return label
    }()
    
    private let attendRequestStatusView = AttendRequestStatusView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()
    
//    private let calendarView = CalendarView()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - Dependencies
 
    private var viewModel: ManagerHomeViewModel
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: ManagerHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        setupNavItem()
        setupConstraints()
        setupDataSource()
        bindSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asSignal()
        let onRefresh = refreshControl.rx
            .controlEvent(.valueChanged)
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                onRefresh: onRefresh,
                showNotis: .empty(),
                showDetails: .empty()
            )
        )
        
        Task {
            for await item in output.item.values {
                switch item.type {
                case .status:
                    attendRequestStatusView.completedCountLabel.text = String(item.doneRequestCount!)
                    attendRequestStatusView.progressCountLabel.text = String(item.leftRequestCount!)
                case .list:
                    var snapshot = Snapshot()
                    snapshot.appendSections(Section.allCases)
                    snapshot.appendItems([], toSection: .list)
                    dataSource.apply(snapshot)
                }
            }
        }
        
        Task {
            for await loading in output.loading.values {
                loadingIndicator.ext.isAnimating(loading)
            }
        }
    }
    
    // MARK: - DataSource
    
    private func setupDataSource() {
        let finderCellRegistration = createFinderCellRegistration()
        
        dataSource = DataSource(collectionView: collectionView) { (view, index, item) in
            guard let section = Section(rawValue: index.section) else {
                return nil
            }
            
            switch section {
            case .list:
                return view.dequeueConfiguredReusableCell(using: finderCellRegistration, for: index, item: item)
            }
        }
        
//        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
//            return (kind == OutlineSupplementaryView.reuseIdentifier)
//            ? view.dequeueConfiguredReusableSupplementary(
//                using: headerCellRegistration, for: indexPath)
//            : view.dequeueConfiguredReusableSupplementary(using: footerCellRegistration, for: indexPath)
//        }
    }
    
    // MARK: - Cell Registration
    
    private func createFinderCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { cell, index, item in
            var content = AttendanceRequestContentView.Configuration()
            content.imageURL = item.userImageUrl
            content.name = item.name
            content.isApprove = item.isApprove
            content.totalWorkTime = item.totalWorkTime
            content.workStartDate = item.workStartDate
            content.workEndDate = item.workEndDate
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    // MARK: - Hierarchy
    
    private func setupView() {
         view.backgroundColor = .systemBackground
    }
    
    private func setupNavItem() {
        // navigationItem.rightBarButtonItem = notiRightBarButton
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(attendRequestStatusView)
        scrollView.addSubview(collectionView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        attendRequestStatusView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let inset = CGFloat(20)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
    
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: inset),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: inset),
            
            attendRequestStatusView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            attendRequestStatusView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -inset),
            attendRequestStatusView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: attendRequestStatusView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
