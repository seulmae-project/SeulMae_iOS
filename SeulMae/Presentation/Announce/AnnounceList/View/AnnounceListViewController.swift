//
//  AnnounceListViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AnnounceListViewController: UIViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnnounceListItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnnounceListItem>
    
    enum Section: Int, CaseIterable {
        case list
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.hidesWhenStopped = true
        activity.stopAnimating()
        return activity
    }()
    
    private var dataSource: DataSource!
    
    private let viewModel: AnnounceListViewModel!
    
    init(viewModel: AnnounceListViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, AnnounceListItem> { (cell, indexPath, item) in
            var content = AnnounceContentView.Configuration()
            content.announceType = "[필독]"
            content.title = "title"
            content.createdDate = Date()
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
        
        dataSource = DataSource(collectionView: collectionView) { (view, index, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: index.section) else { Swift.fatalError("Unknown section") }
            switch section {
            case .list:
                return view.dequeueConfiguredReusableCell(using: cellRegistration, for: index, item: item)
            }
        }
        
        bindSubviews()
    }
    
    private func bindSubviews() {
        let output = viewModel.transform(.init())
        
        Task {
            for await items in output.items.values {
                var snapshot = Snapshot()
                snapshot.appendSections(Section.allCases)
                snapshot.appendItems(items, toSection: .list)
                dataSource.apply(snapshot)
            }
        }
        
        Task {
            for await isLoading in output.isLoading.values {
                if isLoading {
                    loadingIndicator.startAnimating()
                } else {
                    loadingIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1/8)))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
