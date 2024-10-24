//
//  ScheduleCreationViewController.swift
//  SeulMae
//
//  Created by 조기열 on 10/23/24.
//

import UIKit
import RxSwift
import RxCocoa

class ScheduleCreationViewController: BaseViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    enum Section: Int, Hashable, CaseIterable {
        case list
    }

    struct Item: Hashable {
        let id: String = UUID().uuidString
        let member: Member
    }
    
    private let scheduleInlet = ScheduleInlet()
    private let memberEmptyView = MemberEmptyView()
    private lazy var collectionView: UICollectionView = Ext.common(with: memberEmptyView)
    private let createButton: UIButton = Ext.common(title: "일정 생성")
    private var dataSource: DataSource!
    private let onCheckRelay = PublishRelay<(Bool, Member.ID)>()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavItem()
        configureHierarchy()
        configureDataSource()
    }

    private func configureNavItem() {
        navigationController?.title = "일정 생성"
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        let views = [scheduleInlet, collectionView, createButton]
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let insets = CGFloat(16)
        NSLayoutConstraint.activate([
            scheduleInlet.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            scheduleInlet.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets),
            scheduleInlet.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: insets),
            scheduleInlet.heightAnchor.constraint(equalToConstant: 108),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets),
            collectionView.topAnchor.constraint(equalTo: scheduleInlet.bottomAnchor, constant: insets),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -insets),

            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            createButton.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -insets),
            createButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -insets),
        ])
    }

    private func configureDataSource() {
        let memberCellRegistration = createMemberCellRegistration()

        dataSource = DataSource(collectionView: collectionView) { view, index, item in
            guard let section = Section(rawValue: index.section) else { Swift.fatalError("Unknown section!") }
            switch section {
            case .list:
                return view.dequeueConfiguredReusableCell(using: memberCellRegistration, for: index, item: item)
            }
        }

        let snapshot = makeInitialSnapshot()
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func makeInitialSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        return snapshot
    }

    private func createMemberCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return .init { cell, index, item in
            var content = MemberSelectionContentView.Configuration()
            content.onCheck = { [weak self] isCheck in
                self?.onCheckRelay.accept((isCheck, item.member.id))
            }
            content.memberImageURL = item.member.imageURL
            content.memberName = item.member.name
            content.description = "1일 전 9시간 근무했어요"
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { Swift.fatalError("Unknown section!") }
            switch section {
            case .list:
                return Self.makeListSectionLayout()
            }
        })
    }

    static func makeListSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.18))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let insets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.contentInsets = insets
        return section
    }
}

