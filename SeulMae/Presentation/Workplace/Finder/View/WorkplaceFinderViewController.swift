//
//  WorkplaceFinderViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/15/24.
//

import UIKit

final class WorkplaceFinderViewController: UIViewController {
    
    // MARK: - Internal Types
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, WorkplaceFinderItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WorkplaceFinderItem>
    
    enum Section: Int, CaseIterable {
        case join // 참여하기
        case pending // 대기중인
        case active // 참여중인
    }
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()
    
    private let titleLabel: UILabel = .title(title: "참여중인 근무지가 없어요")
    private let searchWorkplaceButton: UIButton = .common(title: "찾아보기")
    private let createWorkplaceButton: UIButton = .common(title: "생성하기")
    private let pendingLabel: UILabel = .title(title: "승인 대기중인 근무지")
    
    // MARK: - Properties
    
    private var viewModel: WorkplaceFinderViewModel
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: WorkplaceFinderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupConstraints()
        bindSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let output = viewModel.transform(
            .init(
                search: searchWorkplaceButton.rx.tap.asSignal(),
                create: createWorkplaceButton.rx.tap.asSignal()
            )
        )
        
        Task {
            
        }
    }
    
    // MARK: - Hierarchy
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        let buttonStack = UIStackView()
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 8.0
        
        view.addSubview(titleLabel)
        view.addSubview(buttonStack)
        view.addSubview(pendingLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        pendingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.addArrangedSubview(searchWorkplaceButton)
        buttonStack.addArrangedSubview(createWorkplaceButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            buttonStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            buttonStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            
            pendingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            pendingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            pendingLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 12),
            
            // Constraint button height
            buttonStack.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    
    
    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else {
                Swift.fatalError("Unknown section!")
            }
            
            let section: NSCollectionLayoutSection
            switch sectionKind {
            case .join:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(200)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(200)),
                    subitems: [item])
                group.interItemSpacing = .fixed(12)
                section = NSCollectionLayoutSection(group: group)
            case .pending:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(100)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(0.9),
                        heightDimension: .absolute(100)),
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.interGroupSpacing = 20
            case .active:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .absolute(100)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .absolute(100)),
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            }
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: "section-header-element-kind",
                alignment: .top, absoluteOffset: .init(x: 0, y: -12))
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
}
