//
//  SettingViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/5/24.
//

import UIKit

final class SettingViewController: UIViewController {
    
    // MARK: - Internal Types
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SettingListItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, SettingListItem>
    
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case account, system, info
        
        var description: String {
            switch self {
            case .account: return "계정"
            case .system: return "시스템"
            case .info: return "정보"
            }
        }
    }
    
    // MARK: - UI
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 48
        imageView.layer.cornerCurve = .continuous
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.image = .gochi
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let showProfileButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .pretendard(size: 20, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.setImage(.caretRight.resize(height: 20), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weight: .regular)
        label.text = "전화번호"
        return label
    }()
    
    private let phoneNumberOutlet: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weight: .semibold)
        label.textColor = .primary
        return label
    }()
    
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weight: .regular)
        label.text = "생년월일"
        return label
    }()
    
    private let birthdayOutlet: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weight: .semibold)
        label.textColor = .primary
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private var dataSource: DataSource!
    
    private let viewModel: SettingViewModel!
    
    init(viewModel: SettingViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavItem()
        setupView()
        setupConstraints()
        setupDataSource()
        bindSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let selected = collectionView.rx
            .itemSelected
            .compactMap { [weak self] indexPath in
                return self?.dataSource
                    .itemIdentifier(for: indexPath)
            }
            .asDriver()
        
        let output = viewModel.transform(
            .init(
                showProfile: showProfileButton.rx.tap.asSignal(),
                selectedItem: selected
            ))
        
        Task {
            for await item in output.item.values {
                self.showProfileButton.setTitle("\(item.username)의 프로필", for: .normal)
                // self.userImageView
                self.phoneNumberOutlet.text = item.phoneNumber
                self.birthdayOutlet.text = item.birthday
            }
        }
    }
    
    // MARK: - Hierarchy
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        let phoneNumberStack = UIStackView()
        phoneNumberStack.distribution = .equalCentering
        phoneNumberStack.addArrangedSubview(phoneNumberLabel)
        phoneNumberStack.addArrangedSubview(phoneNumberOutlet)
        
        let birthdayStack = UIStackView()
        birthdayStack.distribution = .equalCentering
        birthdayStack.addArrangedSubview(birthdayLabel)
        birthdayStack.addArrangedSubview(birthdayOutlet)
        
        let userInfoStack = UIStackView()
        userInfoStack.spacing = 8.0
        userInfoStack.axis = .vertical
        userInfoStack.directionalLayoutMargins = .init(top: 12, leading: 20, bottom: 12, trailing: 20)
        userInfoStack.isLayoutMarginsRelativeArrangement = true
        userInfoStack.backgroundColor = .init(hexCode: "F8F7F5")
        userInfoStack.layer.cornerRadius = 12
        userInfoStack.layer.cornerCurve = .continuous
        userInfoStack.addArrangedSubview(phoneNumberStack)
        userInfoStack.addArrangedSubview(birthdayStack)
        
        let contentStack = UIStackView()
        contentStack.spacing = 20
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.addArrangedSubview(userImageView)
        contentStack.addArrangedSubview(showProfileButton)
        contentStack.addArrangedSubview(userInfoStack)
        contentStack.directionalLayoutMargins = .init(top: 20, leading: 0, bottom: 20, trailing: 0)
        contentStack.isLayoutMarginsRelativeArrangement = true
        
        view.addSubview(contentStack)
        view.addSubview(collectionView)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentStack.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
            userImageView.heightAnchor.constraint(equalToConstant: 96),
            userImageView.widthAnchor.constraint(equalToConstant: 96),
            
            userInfoStack.widthAnchor.constraint(equalToConstant: 240),
        ])
    }
    
    private func setupNavItem() {
        navigationItem.title = "설정"
    }
    
    // MARK: - DataSource
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SettingListItem> { (cell, indexPath, item) in
            var content = UIListContentConfiguration.valueCell()
            content.textProperties.font = .pretendard(size: 16, weight: .regular)
            content.text = item.title
            content.imageProperties.maximumSize = CGSize(width: 24, height: 24)
            content.image = item.image
            // TODO: CustomContentView 생성 후 separator
            if item.text != "" {
                content.secondaryTextProperties.font = .pretendard(size: 16, weight: .regular)
                content.secondaryTextProperties.color = .secondaryLabel
                content.secondaryText = item.text
            } else {
                cell.accessories = [
                    .disclosureIndicator()
                ]
            }
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: "section-header-element-kind") {
            (supplementaryView, string, indexPath) in
            let section = Section(rawValue: indexPath.section)
            supplementaryView.label.text = section?.description ?? ""
            supplementaryView.label.font = .pretendard(size: 14, weight: .regular)
            supplementaryView.label.textColor = .secondaryLabel
        }
        
        dataSource = DataSource(collectionView: collectionView) { (view, index, item) -> UICollectionViewCell? in
            return view.dequeueConfiguredReusableCell(using: cellRegistration, for: index, item: item)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return view.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }
        
        // initial data
        let sections = Section.allCases
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        snapshot.appendItems(Section.account.menus, toSection: .account)
        snapshot.appendItems(Section.system.menus, toSection: .system)
        snapshot.appendItems(Section.info.menus, toSection: .info)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(56)))
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(56)),
                subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: "section-header-element-kind", alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
    }
}
