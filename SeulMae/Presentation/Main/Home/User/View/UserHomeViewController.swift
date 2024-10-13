//
//  UserHomeViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class UserHomeViewController: BaseViewController {
    
    // MARK: - Internal Types
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, UserHomeItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UserHomeItem>
    
    enum Section: Int, CaseIterable, Hashable {
        case status
        case calendar
        case list
    }
    
    // MARK: - UI Properties
    
    private let notiRightBarButton = UIBarButtonItem(image: .bell, style: .plain, target: nil, action: nil)
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(
            frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    // private let calendarView = CalendarView()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    private let attendanceRelay = PublishRelay<()>()
    private let addRelay = PublishRelay<AttendRequest>()
    
    // MARK: - Dependencies
    
    private var viewModel: UserHomeViewModel
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: UserHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configureHierarchy()
        configureNavItem()
        configureDataSource()
        bindSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map { _ in return () }
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                refresh: refreshControl.rx.controlEvent(.valueChanged).asSignal(),
                showNotis: notiRightBarButton.rx.tap.asSignal(),
                showDetails: .empty(),
                onAttendance: attendanceRelay.asSignal(),
                add: addRelay.asSignal()
            )
        )
        
        Task {
            for await item in output.item.values {
                var snapshot = Snapshot()
                snapshot.appendSections(Section.allCases)
                snapshot.appendItems([item], toSection: .status)
                dataSource.apply(snapshot)
            }
        }
        
        Task {
            for await loading in output.loading.values {
                loadingIndicator.ext.isAnimating(loading)
            }
        }
    }
    
    // MARK: - Hierarchy
    
    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func configureNavItem() {
        // navigationItem.rightBarButtonItem = notiRightBarButton
    }
    
    // MARK: - DataSource Methods
    
    private func configureDataSource() {
        let StateCellRegistration = createStateCellRegistration()
        let calendarCellRegistration = createCalendarCellRegistration()
        let listCellRegistration = createListCellRegistration()
        
        dataSource = DataSource(collectionView: collectionView) { (view, index, item) in
            guard let section = Section(rawValue: index.section) else {
                Swift.fatalError("Unknown section!")
            }
            
            switch section {
            case .status:
                return view.dequeueConfiguredReusableCell(using: StateCellRegistration, for: index, item: item)
            case .calendar:
                return view.dequeueConfiguredReusableCell(using: calendarCellRegistration, for: index, item: item)
            case .list:
                return view.dequeueConfiguredReusableCell(using: listCellRegistration, for: index, item: item)
            }
        }
    }
    
    // MARK: - Snapshot Methods
    
    
    
    // MARK: - Cell Registrations
    
    private func createStateCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, UserHomeItem> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, UserHomeItem> { cell, index, item in
            var content = WorkplaceOverviewContentView.Configuration()
            content.name = "테스트테스트"
            content.joinDate = Date()
            content.onAttendance = { [weak self] in
                self?.attendanceRelay.accept(())
            }
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    private func createCalendarCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, UserHomeItem> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, UserHomeItem> { cell, index, item in
            var content = AttendanceRequestContentView.Configuration()

            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    private func createListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, UserHomeItem> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, UserHomeItem> { cell, index, item in
            var content = WorkplaceStatusContentView.Configuration()
            content.name = 
            content.workTime
            content.message
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    // MARK: - UICollectionViewLayout
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {  sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else {
                Swift.fatalError("Unknown section!")
            }
            
            switch section {
            case .status:
                return UserHomeViewController.createStateSection()
            case .calendar:
                return UserHomeViewController.createCalendarSection()
            case .list:
                return UserHomeViewController.createListSection()
            }
        }
    }
    
    static func createStateSection() -> NSCollectionLayoutSection {
        //        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(350), heightDimension: .estimated(144))
        //        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(350), heightDimension: .estimated(144))
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(350), heightDimension: .estimated(144))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    static func createCalendarSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    static func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
