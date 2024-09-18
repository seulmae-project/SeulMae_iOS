//
//  WorkScheduleListViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import UIKit

final class WorkScheduleListViewController: UIViewController {
    
    // MARK: - Internal Types
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WorkplaceListItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, WorkplaceListItem>
    
    enum Section: Int, Hashable, CaseIterable {
        case list
    }
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - Dependencies
    
    private var viewModel: WorkScheduleListViewModel
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: WorkScheduleListViewModel) {
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
        
    }
    
    // MARK: - Hierarchy
    
    private func setupConstraints() {
        view.addSubview(collectionView)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - DataSource
    
    private func setupDataSource() {
        let workScheduleCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem> { (cell, indexPath, item) in
            var content = cell.workScheduleContentConfiguration()
            guard case .workSchedule = item.itemType,
                  let workSchedule = item.workSchedule else { return }
            content.workSchedule = workSchedule
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
        
        dataSource = DataSource(collectionView: collectionView) { (view, indexPath, item) -> UICollectionViewCell? in
            return view.dequeueConfiguredReusableCell(using: workScheduleCellRegistration, for: indexPath, item: item)
        }
        
        // initial data
        let sections = Section.allCases
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .absolute(180)))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .absolute(180)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
