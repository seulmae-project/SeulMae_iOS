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
    
    private lazy var calendarCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        return cv
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
            guard let self else { return }
            // currentYear = year
            // TODO: - 년도 수정 및 날짜 정확하지 않음..
            currentMonth = month
            applySnapshot()
        }
        
        setHierarchy()
        setDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // TODO: - collectionview header 로 변경 &
        calendarControl.frame = CGRect(origin: .zero, size: CGSize(width: 94, height: 24))
        calendarCollectionView.frame = CGRect(x: 0, y: 40, width: frame.width, height: frame.height - 24)
    }
    
    // MARK: - Hierarchy
    
    private func setHierarchy() {
        addSubview(calendarControl)
        addSubview(calendarCollectionView)
    }
    
    // MARK: - DataSource
    
    private func setDataSource() {
        let weekdayCellRegistration = createWeekdayCellRegistration()
        let dateCellRegistration = createDateCellRegistration()
        
        dataSource = DataSource(collectionView: calendarCollectionView) { (view, index, item) in
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
        let sections = Section.allCases
        snapshot.appendSections(sections)
        let weekdayItems = createWeekdayItem()
        snapshot.appendItems(weekdayItems, toSection: .weekday)
        let dayItems = createDayItem()
        snapshot.appendItems(dayItems, toSection: .day)
        dataSource.apply(snapshot)
    }
    
    private func createDayItem() -> [Item] {
        var currentDayCount = numOfDaysInMonth[currentMonth - 1]
        ForLeapYears: if currentYear.ext.isLeapYear && currentMonth == 2 {
            currentDayCount += 1
        }
        
        var totalDayCount = currentDayCount
        
        /// Tag: add previous month day
        let previousDayCount = (firstWeekDay - 1)
        totalDayCount += previousDayCount
        
        /// Tag: add next month day
        totalDayCount = totalDayCount % 7 == 0 ? totalDayCount : totalDayCount + 7 - (totalDayCount % 7)
                
        return (1...totalDayCount).map {
            if $0 <= previousDayCount {
                /// Tag: previous month day
                let previousMonth = (currentMonth == 1) ? 12 : currentMonth - 1
                var previousMonthCount = numOfDaysInMonth[previousMonth - 1]
                ForLeapYears: if currentYear.ext.isLeapYear && previousMonth == 2 {
                    previousMonthCount += 1
                }
                
                let day = previousMonthCount - (firstWeekDay - 2)
                return Item(day: day, status: .normal)
            } else if $0 > (currentDayCount + previousDayCount) {
                /// Tag: next month day
                let day = $0 - (currentDayCount + previousDayCount)
                return Item(day: day, status: .normal)
            } else {
                /// Tag: current month day
                let day = ($0 - (firstWeekDay - 1))
                return Item(day: day, status: .normal)
            }
        }
    }
    
    private func createWeekdayItem() -> [Item] {
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
