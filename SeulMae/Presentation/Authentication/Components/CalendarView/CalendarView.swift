//
//  CalendarView.swift
//  SeulMae
//
//  Created by 조기열 on 7/1/24.
//

import UIKit

class CalendarView: UIView {
    
    // MARK: - Internal Types
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, Hashable, CaseIterable {
        case weekday, day
    }
    
    struct Item: Hashable, Identifiable {
        enum ItemType {
            case weekday, day
        }
        
        let id: String
        let itemType: ItemType
        let weekday: String?
        let day: Int?
        let status: DayContentView.Configuration.Status?
        
        init(weekday: String) {
            self.id = UUID().uuidString
            self.itemType = .weekday
            self.weekday = weekday
            self.day = nil
            self.status = nil
        }
        
        init(day: Int, status: DayContentView.Configuration.Status) {
            self.id = UUID().uuidString
            self.itemType = .day
            self.day = day
            self.status = status
            self.weekday = nil
        }
    }
    
    // MARK: UI
    
    private var calendarControl = CalendarControl()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Properties
    
    var onTap: ((_ date: Date) -> Void)?
    
    private var dataSource: DataSource!
    
    private var currentYear: Int = 0
    
    private var currentMonth: Int = 0
    
    private var currentDay: Int = 0
    
    private var firstWeekDay: Int = 0
    
    private var numOfDaysInMonth = [
        31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    ]
    
    private var weekdays = [
        "일", "월", "화", "수", "목", "금", "토"
    ]

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let now = Date.ext.now
        currentYear = Calendar.current.component(.year, from: now)
        currentMonth = Calendar.current.component(.month, from: now)
        currentDay = Calendar.current.component(.day, from: now)
        firstWeekDay = now.ext.firstWeekDay
        
        calendarControl.onChange = { [weak self] month in
            guard let strongSelf = self else { return }
            strongSelf.currentMonth = month
            strongSelf.applySnapshot()
        }
        
        addSubview(calendarControl)
        addSubview(collectionView)
        
        setDataSource()
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 320, height: 300)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // TODO: - collectionview header 로 변경 &
        calendarControl.frame = CGRect(origin: .zero, size: CGSize(width: 94, height: 24))
        collectionView.frame = CGRect(x: 0, y: 40, width: frame.width, height: frame.height - 24)
    }
    
    // MARK: - Hierarchy
    
    private func setHierarchy() {
        
    }
    
    // MARK: - DataSource
    
    private func setDataSource() {
        let weekdayCellRegistration = createWeekdayCellRegistration()
        let dateCellRegistration = createDateCellRegistration()
        
        dataSource = DataSource(collectionView: collectionView) { (view, index, item) in
            guard let section = Section(rawValue: index.section) else { return nil }
            switch section {
            case .weekday:
                return view.dequeueConfiguredReusableCell(using: weekdayCellRegistration, for: index, item: item)
            case .day:
                return view.dequeueConfiguredReusableCell(using: dateCellRegistration, for: index, item: item)
            }
        }
        
        applySnapshot()
    }
    
    // MARK: - Snapshot
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        let weekdays = createWeekdayItems()
        snapshot.appendItems(weekdays, toSection: .weekday)
        let days = createDayItems()
        snapshot.appendItems(days, toSection: .day)
        dataSource.apply(snapshot)
    }
    
    private func createDayItems() -> [Item] {
        let showOnlyCurrentMonthDates = true
        
        var currentDayCount = numOfDaysInMonth[currentMonth - 1]
        NSLog("currentMonth: \(currentMonth), currentDayCount: \(currentDayCount)")
        
        ForLeapYears: if currentYear.ext.isLeapYear && currentMonth == 2 {
            currentDayCount += 1
        }
        
        var totalDayCount = currentDayCount
        
        // fill the remaining space in the current month's calendar with dates from the previous or next month
        let previousDayCount = (firstWeekDay - 1)
        totalDayCount += previousDayCount

        let nextMonthDayCount = 7 - (totalDayCount % 7)
        totalDayCount = (totalDayCount % 7) == 0 ? totalDayCount : totalDayCount + nextMonthDayCount
                
        return (1...totalDayCount).map {
            let currentMonthRange = firstWeekDay...(currentDayCount + previousDayCount)
            if currentMonthRange.contains($0) {
                // Current month
                let day = ($0 - previousDayCount)
                return Item(day: day, status: .normal)
            } else {
                // Other month
                if showOnlyCurrentMonthDates {
                    // Show empty view
                    return Item(day: $0, status: .normal)
                } else {
                    // Show previous and next month dates
                    let isPreviousMonth = ($0 < firstWeekDay)
                    if isPreviousMonth {
                        let previousMonth = (currentMonth == 1) ? 12 : currentMonth - 1
                        var previousMonthCount = numOfDaysInMonth[previousMonth - 1]
                        if currentYear.ext.isLeapYear && previousMonth == 2 {
                            previousMonthCount += 1
                        }
                        
                        let day = previousMonthCount - (firstWeekDay - 2)
                        return Item(day: day, status: .normal)
                    } else {
                        let day = $0 - (currentDayCount + previousDayCount)
                        return Item(day: day, status: .normal)
                    }
                }
            }
        }
    }
    
    private func createWeekdayItems() -> [Item] {
        let items = weekdays.map(Item.init(weekday:))
        return items
    }
    
    // MARK: - Cell Registration
    
    private func createWeekdayCellRegistration() -> UICollectionView.CellRegistration<TextCell, Item> {
        return UICollectionView.CellRegistration<TextCell, Item> { cell, index, item in
            cell.label.text = item.weekday
            cell.label.font = .systemFont(ofSize: 14, weight: .semibold)
            cell.label.textColor = .graphite
            cell.label.textAlignment = .center
        }
    }
    
    private func createDateCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, index, item in
            var content = DayContentView.Configuration()
            content.day = item.day
            content.status = item.status ?? .normal
            cell.contentConfiguration = content
        }
    }
    
    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0 / 7.0),
                    heightDimension: .estimated(32)))
            // item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(32)),
                subitems: [item])
            group.interItemSpacing = .fixed(16)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            return section
        }
        
        // let config = UICollectionViewCompositionalLayoutConfiguration()
        // config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider)
        return layout
    }
}
