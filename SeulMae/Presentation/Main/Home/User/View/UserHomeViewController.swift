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
    
    private let rightBarButton = UIBarButtonItem(image: .bell, style: .plain, target: nil, action: nil)
    
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
        
    // MARK: - Properties
    
    private var dataSource: DataSource!
    private let startRecordRelay = PublishRelay<()>()
    private let saveRecordRelay = PublishRelay<()>()

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
                showAlarmList: rightBarButton.rx.tap.asSignal(),
                showAttendanceDetails: .empty(),
                onStartRecording: startRecordRelay.asSignal(),
                onSaveRecording: saveRecordRelay.asSignal()
            )
        )
        
        // Handle collectionView items
        output.items
            .drive(onNext: { [weak self] items in
                self?.applySnapshot(items: items)
            })
            .disposed(by: disposeBag)

        // Handle attendance start
        output.isStartRecording
            .drive(onNext: { isStart in
                if isStart {
                    WorkplaceOverviewContentView.attendanceButton?.setTitle("퇴근하기", for: .normal)
                }
            })
            .disposed(by: disposeBag)

        // Handle attendance start
        output.isSaveRecording
            .drive(onNext: { isSave in
                if isSave {
                    WorkplaceOverviewContentView.attendanceButton?.setTitle("출근하기", for: .normal)
                }        
            })
            .disposed(by: disposeBag)

        // Handle loading animations
        output.loading
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }

    func applySnapshot(items: [UserHomeItem]) {
        guard let item = items.first else { return }
        var snapshot = dataSource.snapshot()
        let applied = snapshot.itemIdentifiers(inSection: item.section)
        snapshot.deleteItems(applied)
        snapshot.appendItems(items, toSection: item.section)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Hierarchy
    
    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func configureNavItem() {
         navigationItem.rightBarButtonItem = rightBarButton
    }
    
    // MARK: - DataSource Methods
    
    private func configureDataSource() {
        let stateCellRegistration = createStateCellRegistration()
        let calendarCellRegistration = createCalendarCellRegistration()
        let listCellRegistration = createListCellRegistration()
        
        dataSource = DataSource(collectionView: collectionView) { (view, index, item) in
            guard let section = Section(rawValue: index.section) else {
                Swift.fatalError("Unknown section!")
            }
            
            switch section {
            case .status:
                return view.dequeueConfiguredReusableCell(using: stateCellRegistration, for: index, item: item)
            case .calendar:
                return view.dequeueConfiguredReusableCell(using: calendarCellRegistration, for: index, item: item)
            case .list:
                return view.dequeueConfiguredReusableCell(using: listCellRegistration, for: index, item: item)
            }
        }

        applyInitialSnapshot()
    }
    
    // MARK: - Snapshot Methods
    
    private func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot)
    }

    // MARK: - Cell Registrations
    
    private func createStateCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, UserHomeItem> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, UserHomeItem> { cell, index, item in
            var content = WorkplaceOverviewContentView.Configuration()
            content.name = item.workplace?.name
            content.joinDate = item.profile?.joinDate
            content.onStartRecording = { [weak self] in
                self?.startRecordRelay.accept(())
            }
            content.onSaveRecording = { [weak self] in
                self?.saveRecordRelay.accept(())
            }
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    private func createCalendarCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, UserHomeItem> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, UserHomeItem> { cell, index, item in
            var content = UserHomeCalendarContentView.Configuration()
            content.histories = item.histories
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    private func createListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, UserHomeItem> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, UserHomeItem> { cell, index, item in
            var content = WorkplaceStatusContentView.Configuration()
            content.name = item.workplace?.name
            content.workTime = "09:00 - 10:00"
            content.message = "1시간 승인 완료"
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    // MARK: - UICollectionViewLayout
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.4))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return section
    }
    
    static func createCalendarSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return section
    }
    
    static func createListSection() -> NSCollectionLayoutSection {
         let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return section
    }
}
