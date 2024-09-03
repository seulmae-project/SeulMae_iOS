//
//  AnnounceViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AnnounceViewController: UIViewController {
    
    // MARK: - Internal Types
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnnounceItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnnounceItem>
    
    enum Section: Int, CaseIterable {
        case category
    }
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil)
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        return pageViewController
    }()
    
    private let viewControllers: [UIViewController]
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - Dependencies
    
    private let viewModel: AnnounceViewModel!
    
    init(viewModel: AnnounceViewModel!, viewControllers: [UIViewController]) {
        self.viewModel = viewModel
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavItem()
        setupView()
        addChild(pageViewController)
        pageViewController.setViewControllers([viewControllers.first!], direction: .forward, animated: true)
        setupConstraints()
        setupDataSource()
        bindSubviews()
    }
    
    private func bindSubviews() {
        let categories = Driver.just(["전체", "필독"])
        Task {
            for await categories in categories.values {
                let items = categories.map(AnnounceItem.init(title:))
                var snapshot = Snapshot()
                snapshot.appendSections(Section.allCases)
                snapshot.appendItems(items, toSection: .category)
                dataSource.apply(snapshot)
            }
        }
    }
    
    private func setupNavItem() {
        navigationItem.title = "공지"
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Hierarchy
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(pageViewController.view)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 36),
            
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - DataSource
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, AnnounceItem> { (cell, indexPath, item) in
            cell.label.text = item.title
            cell.label.font = .pretendard(size: 15, weight: .regular)
            cell.label.textAlignment = .center
            cell.layer.cornerRadius = 8.0
            cell.layer.cornerCurve = .circular
            cell.layer.borderColor = UIColor(hexCode: "EEEEEE").cgColor
            cell.layer.borderWidth = 1.0
        }
        
        dataSource = DataSource(collectionView: collectionView) { (view, index, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: index.section) else { Swift.fatalError("Unknown section") }
            switch section {
            case .category:
                return view.dequeueConfiguredReusableCell(using: cellRegistration, for: index, item: item)
            }
        }
    }
    
    // MARK: - CollectionView Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .estimated(58),
                heightDimension: .estimated(36)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 8.0
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UIPageViewControllerDataSource

extension AnnounceViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let lastIndex = viewControllers.count - 1
        var nextIndex = currentIndex + 1
        if (lastIndex < nextIndex) {
            nextIndex = 0
        }
        
        return viewControllers[nextIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let lastIndex = viewControllers.count - 1
        var previousIndex = currentIndex - 1
        if (previousIndex < 0) {
            previousIndex = lastIndex
        }
        
        return viewControllers[previousIndex]
    }
}
