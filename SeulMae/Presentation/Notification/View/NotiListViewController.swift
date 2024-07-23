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
    
    // MARK: - Flow
    
    static func create(viewModel: NotiListViewModel) -> NotiListViewController {
        let view = NotiListViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: - Internal Types
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, NotiListItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, NotiListItem>
    
    enum Section: Hashable {
        case list
    }
    
    // MARK: - UI
    
    private let noticeButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        b.setTitleColor(.graphite, for: .normal)
        b.setTitle("공지", for: .normal)
        b.tag = 0
        return b
    }()
    
    private let remainderButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        b.setTitleColor(.graphite, for: .normal)
        b.setTitle("알림", for: .normal)
        b.tag = 1
        return b
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - Dependencies
    
    private var viewModel: NotiListViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataSource()
        setHierarchy()
        bindSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let onCategoryTaps = Signal.merge(
            noticeButton.rx.tag.asSignal(),
            remainderButton.rx.tag.asSignal()
        )
        
        Task {
            for await tag in onCategoryTaps.values {
                let selectedColor: UIColor = .graphite
                let unSelectedColor: UIColor = .graphite.withAlphaComponent(0.4)
                noticeButton.setTitleColor((tag == 0) ? selectedColor : unSelectedColor, for: .normal)
                remainderButton.setTitleColor(!(tag == 0) ? selectedColor : unSelectedColor, for: .normal)
            }
        }
        
        let onItemTap = collectionView.rx
            .itemSelected
            .compactMap { [unowned self] index in
                return dataSource.itemIdentifier(for: index)?
                    .id
            }
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                onItemTap: onItemTap
            )
        )
        
        Task {
            for await items in output.items.values {
                apply(items: items)
            }
        }
    }
    
    // MARK: - Data Source
    
    private func setDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, NotiListItem> { (cell, indexPath, item) in
            var content = NotiContentView.Configuration()
            content.icon = item.icon
            content.title = item.title
            content.body = item.body
            cell.contentConfiguration = content
        }
        
        dataSource = DataSource(collectionView: collectionView) { (view, index, item) -> UICollectionViewCell? in
            return view.dequeueConfiguredReusableCell(using: cellRegistration, for: index, item: item)
        }
    }
    
    private func apply(items: [NotiListItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.list])
        snapshot.appendItems(items, toSection: .list)
        dataSource.apply(snapshot)
    }
    
    // MARK: - Hierarchy
    
    private func setHierarchy() {
        view.backgroundColor = .systemBackground
        
        let categoryStack = UIStackView(arrangedSubviews: [
            noticeButton, remainderButton
        ])
        categoryStack.spacing = 12
        
        view.addSubview(categoryStack)
        view.addSubview(collectionView)
        
        let inset = CGFloat(16)
        
        categoryStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(inset)
            make.top.equalTo(view.snp_topMargin).inset(inset)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
                .inset(inset)
            make.top.equalTo(categoryStack.snp.bottom)
                .offset(inset)
        }
    }
    
    // MARK: - CollectionView Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(60)))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(60)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        return UICollectionViewCompositionalLayout(section: section)
    }
}
