//
//  WorkplaceViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/5/24.
//

import UIKit

final class WorkplaceViewController: UIViewController {
    
    // MARK: - Internal Types
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WorkplaceListItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, WorkplaceListItem>
    
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case members, announceList, workSchedules
        
        var description: String {
            switch self {
            case .members: return ""
            case .announceList: return "공지사항"
            case .workSchedules: return "근무일정"
            }
        }
    }
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // collectionView.showsHorizontalScrollIndicator = false
        // collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        setupDataSource()
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - DataSource
    
    private func setupDataSource() {
        let headerCellRegistration = createHeaderCellRegistration()
        let memberCellRegistration = createMemberCellRegistration()
        let announceCellRegistration = createAnnounceCellRegistration()
        let workScheduleCellRegistration = createWorkScheduleCellRegistration()
        
        dataSource = DataSource(collectionView: collectionView) { (view, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { Swift.fatalError("Unknown section") }
            switch section {
            case .members:
                return view.dequeueConfiguredReusableCell(using: memberCellRegistration, for: indexPath, item: item)
            case .announceList:
                return view.dequeueConfiguredReusableCell(using: announceCellRegistration, for: indexPath, item: item)
            case .workSchedules:
                return view.dequeueConfiguredReusableCell(using: workScheduleCellRegistration, for: indexPath, item: item)
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
            return view.dequeueConfiguredReusableSupplementary(
                using: headerCellRegistration, for: indexPath)
        }
    }
    
    // MARK: - CellRegistration
    
    func createHeaderCellRegistration() -> UICollectionView.SupplementaryRegistration<TitleSupplementaryView> {
        return UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: "section-header-element-kind") {
            (supplementaryView, string, indexPath) in
            let section = Section(rawValue: indexPath.section)
            supplementaryView.label.text = section?.description ?? ""
            supplementaryView.label.font = .pretendard(size: 14, weight: .regular)
            supplementaryView.label.textColor = .secondaryLabel
        }
    }
    
    func createMemberCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem>  {
        return UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem> { (cell, indexPath, item) in
            var content = cell.memberContentConfiguration()
            guard case .member = item.itemType,
                  let member = item.member else { return }
            content.member = member
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    func createAnnounceCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem>  {
        return UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem> { (cell, indexPath, item) in
            var content = cell.announceSummeryContentConfiguration()
            guard case .announce = item.itemType,
                  let announce = item.announce else { return }
            content.announce = announce
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    func createWorkScheduleCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem>  {
        return UICollectionView.CellRegistration<UICollectionViewCell, WorkplaceListItem> { (cell, indexPath, item) in
            var content = cell.workScheduleContentConfiguration()
            guard case .workSchedule = item.itemType,
                  let workSchedule = item.workSchedule else { return }
            content.workSchedule = workSchedule
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout()
    }
}
