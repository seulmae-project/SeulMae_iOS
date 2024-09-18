//
//  WorkScheduleViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WorkScheduleDetailsViewController: UIViewController {
    
    // MARK: - Internal Types
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WorkScheduleDetailsItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, WorkScheduleDetailsItem>
    
    enum Section: Int, Hashable, CaseIterable {
        case title
        case workTime
        case weekday
        case members
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
    
    private var viewModel: WorkScheduleDetailsViewModel
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: WorkScheduleDetailsViewModel) {
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
        let textFieldCellRegistration = createCommonTextFieldCellRegistration()
        let weekdayCellRegistration = createWeekdayCellRegistration()
        
        dataSource = DataSource(collectionView: collectionView) { (view, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { Swift.fatalError("Unknown section") }
            switch section {
            case .title, .workTime:
                return view.dequeueConfiguredReusableCell(using: textFieldCellRegistration, for: indexPath, item: item)
            case .weekday:
                return view.dequeueConfiguredReusableCell(using: weekdayCellRegistration, for: indexPath, item: item)
            case .members:
                return nil
            }
        }
        
        // initial data
        let sections = Section.allCases
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - CellRegistration
    
    func createCommonTextFieldCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, WorkScheduleDetailsItem>  {
        return UICollectionView.CellRegistration<UICollectionViewCell, WorkScheduleDetailsItem> { (cell, indexPath, item) in
            var content = cell.commonInputContentConfiguration()
            guard case .text = item.itemType,
                  let text = item.text else { return }
            content.title = item.title
            content.text = text
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    func createWeekdayCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, WorkScheduleDetailsItem>  {
        return UICollectionView.CellRegistration<UICollectionViewCell, WorkScheduleDetailsItem> { (cell, indexPath, item) in
            var content = cell.scheduleWeekdaysContentConfiguration()
            guard case .weekdays = item.itemType,
                  let weekdays = item.weekdays else { return }
            content.title = item.title
            content.weekdays = weekdays
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { Swift.fatalError("Unknown section!") }
            let section: NSCollectionLayoutSection
            switch sectionKind {
            case .title, .workTime:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .estimated(44)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .estimated(44)),
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            case .weekday:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .estimated(88)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .estimated(88)),
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            case .members:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .estimated(88)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .estimated(88)),
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            }
            // section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
}
