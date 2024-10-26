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

    convenience init(viewModel: ScheduleCreationViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, ScheduleCreationItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ScheduleCreationItem>
    
    enum Section: Int, Hashable, CaseIterable {
        case list
    }
    
    private let scheduleCustomView = ScheduleCustomizationView()
    private let memberEmptyView = MemberEmptyView()
    
    private lazy var collectionView: UICollectionView = Ext.common(
        layout: createLayout(),
        emptyView: memberEmptyView,
        refreshControl: refreshControl)
    private let createButton: UIButton = Ext.common(title: "일정 생성")
    private var dataSource: DataSource!
    private let onWeekdaysChangeRelay = PublishRelay<[Int]>()

    private var viewModel: ScheduleCreationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavItem()
        configureHierarchy()
        configureDataSource()
        bindInternalSubViews()
    }

    private func bindInternalSubViews() {
        scheduleCustomView.onChange = { [weak self] weekdays in
            Swift.print(#fileID, "weekdays: \(weekdays)")
            self?.onWeekdaysChangeRelay.accept(weekdays)
        }

        let members = collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { (self, _) in
                let indexPaths = self.collectionView.indexPathsForSelectedItems ?? []
                Swift.print(#fileID, "selected index: \(indexPaths)")
                return indexPaths.compactMap(self.dataSource.itemIdentifier(for:))
            }
            .startWith([ScheduleCreationItem]())
            .asDriver()

        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                onRefresh: onRefresh,
                title: scheduleCustomView.nameTextField.rx.text.orEmpty.asDriver(),
                startTime: scheduleCustomView.startTimeTextFeild.rx.text.orEmpty.asDriver(),
                endTime: scheduleCustomView.endTimeTextField.rx.text.orEmpty.asDriver(),
                weekdays: onWeekdaysChangeRelay.asDriver(),
                onInvite: memberEmptyView.inviteMemberButton.rx.tap.asSignal(),
                members: members,
                onCreate: createButton.rx.tap.asSignal()
            )
        )

        output.items
            .drive(with: self, onNext: { (self, items) in
                Swift.print(#fileID, "items count: \(items.count)")
                self.memberEmptyView.isHidden = !(items.isEmpty)
                var snapshot = self.dataSource.snapshot()
                let applied = snapshot.itemIdentifiers(inSection: .list)
                snapshot.deleteItems(applied)
                snapshot.appendItems(items, toSection: .list)
                self.dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)
    }

    private func configureNavItem() {
        navigationController?.title = "일정 생성"
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        
        let views = [scheduleCustomView, collectionView, createButton]
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let insets = CGFloat(16)
        NSLayoutConstraint.activate([
            scheduleCustomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            scheduleCustomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets),
            scheduleCustomView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: insets),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets),
            collectionView.topAnchor.constraint(equalTo: scheduleCustomView.bottomAnchor, constant: insets),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -insets),

            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets),
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
        collectionView.backgroundView?.isHidden = false
    }

    private func makeInitialSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        return snapshot
    }

    private func createMemberCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, ScheduleCreationItem> {
        return .init { cell, index, item in
            var content = MemberSelectionContentView.Configuration()
//            content.onCheck = { [weak self] isCheck in
//                self?.onMemberCheckRelay.accept((isCheck, item.member.id))
//            }
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
        let insets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.contentInsets = insets
        return section
    }
}

