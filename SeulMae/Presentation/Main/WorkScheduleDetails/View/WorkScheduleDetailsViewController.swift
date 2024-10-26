//
//  WorkScheduleViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: - 1. update save 시 로딩 처리 error 처리
// TODO: - 2. update save 시 닫고 뷰 화면 새로 고침 > viewDidLoad>??
// TODO: - 3. update save input data validation
// TODO: - 4. memberList View 선택시 멤버 연결 화면?
// TODO: - 5. 오늘의 일정만 workScheduleVC 에 표시 
// TODO: - 6. 일정 필터 고민해 보기

final class WorkScheduleDetailsViewController: UIViewController {
    
    // MARK: - Internal Types
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WorkScheduleDetailsItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, WorkScheduleDetailsItem>
    
    enum Section: Int, Hashable, CaseIterable {
        case name
        case workTime
        case weekday
        case members
    }
    
    // MARK: - UI
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.hidesWhenStopped = true
        activity.stopAnimating()
        return activity
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .pretendard(size: 18, weight: .semibold)
        button.backgroundColor = .primary
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        return button
    }()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    private let nameRelay = PublishRelay<String>()
    private let startTimeRelay = PublishRelay<Date>()
    private let endTimeRelay = PublishRelay<Date>()
    private let weekdayRelay = PublishRelay<[Int]>()
    private let memberRelay = PublishRelay<[Member.ID]>()
    
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
        let output = viewModel.transform(
            .init(
                name: nameRelay.asDriver(),
                startTime: startTimeRelay.asDriver(),
                endTime: endTimeRelay.asDriver(),
                weekdays: weekdayRelay.asDriver(),
                members: memberRelay.asDriver(),
                save: saveButton.rx.tap.asSignal()
            )
        )
        
        // Handle loading indicator
        Task {
            for await loading in output.loading.values {
                loadingIndicator.ext.bind(loading)
            }
        }
        
        // Setup navigation title
        Task {
            for await title in output.title.values {
                navigationItem.title = title
            }
        }
        
        // Apply converted items to the collection view
        Task {
            for await items in output.items.values {
                var snapshot = dataSource.snapshot()
                for item in items {
                    switch item.itemType {
                    case .name:
                        snapshot.appendItems([item], toSection: .name)
                    case .startTime, .endTime:
                        snapshot.appendItems([item], toSection: .workTime)
                    case .weekday:
                        snapshot.appendItems([item], toSection: .weekday)
                    case .members:
                        snapshot.appendItems([item], toSection: .members)
                    }
                }
                dataSource.apply(snapshot)
            }
        }
    }
    
    // MARK: - Hierarchy
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(saveButton)
    
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - DataSource
    
    private func setupDataSource() {
        let textFieldCellRegistration = createCommonTextFieldCellRegistration()
        let weekdayCellRegistration = createWeekdayCellRegistration()
        let timePickerCellRegistration = createTimePickerCellRegistration()
        
        dataSource = DataSource(collectionView: collectionView) { (view, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { Swift.fatalError("Unknown section") }
            switch section {
            case .name:
                return view.dequeueConfiguredReusableCell(using: textFieldCellRegistration, for: indexPath, item: item)
            case .workTime:
                return view.dequeueConfiguredReusableCell(using: timePickerCellRegistration, for: indexPath, item: item)
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
            guard case .name = item.itemType,
                  let name = item.name else { return }
            content.title = item.title
            content.text = name
            content.onChange = { [weak self] name in
                self?.nameRelay.accept(name)
            }
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    func createTimePickerCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, WorkScheduleDetailsItem>  {
        return UICollectionView.CellRegistration<UICollectionViewCell, WorkScheduleDetailsItem> { (cell, indexPath, item) in
            var content = cell.timePickerContentConfiguration()
            guard [.startTime, .endTime].contains(item.itemType),
                  let date = item.date else { return }
            content.title = item.title
            content.date = date
            content.onChange = { [weak self] date in
                if case .startTime = item.itemType {
                    self?.startTimeRelay.accept(date)
                } else {
                    self?.endTimeRelay.accept(date)
                }
            }
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    func createWeekdayCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, WorkScheduleDetailsItem>  {
        return UICollectionView.CellRegistration<UICollectionViewCell, WorkScheduleDetailsItem> { (cell, indexPath, item) in
            var content = cell.weekdaysContentConfiguration()
            guard case .weekday = item.itemType,
                  let weekdays = item.weekdays else { return }
            content.title = item.title
            content.weekdays = weekdays
            content.onChange = { [weak self] weekdays in
                self?.weekdayRelay.accept(weekdays)
            }
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else {
                Swift.fatalError("Unknown section!")
            }
            
            let section: NSCollectionLayoutSection
            switch sectionKind {
            case .name, .workTime:
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
}
