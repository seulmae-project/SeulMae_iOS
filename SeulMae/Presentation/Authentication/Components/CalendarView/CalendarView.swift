//
//  CalendarView.swift
//  SeulMae
//
//  Created by 조기열 on 7/1/24.
//

import UIKit

class CalendarView: UIView {
    
    // MARK: - Internal Types
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, CalendarItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CalendarItem>
    
    enum Section: Int, Hashable, CaseIterable {
        case weekday, day
    }
    
    // MARK: UI Properties
    
    private var calendarControl = CalendarControl()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Properties
    
    let showOnlyCurrentMonthDates = false
    
    var onTap: ((_ date: Date) -> Void)?
    var dataSource: DataSource!
    var currentDate: Date = .ext.now
//    var currentYear: Int = 0
//    var currentMonth: Int = 0
//    var currentDay: Int = 0
//    
//    private var firstWeekDay: Int = 0
//    
//    private var numOfDaysInMonth = [
//        31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
//    ]

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        let now = Date.ext.now
//        currentYear = Calendar.current.component(.year, from: now)
//        currentMonth = Calendar.current.component(.month, from: now)
//        currentDay = Calendar.current.component(.day, from: now)
//        firstWeekDay = now.ext.firstWeekDay
        
        calendarControl.onChange = { [weak self] date in
            self?.currentDate = date
            self?.applyInitialSnapshot()
        }
        
        addSubview(calendarControl)
        addSubview(collectionView)
        
        setDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 352, height: 300)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // TODO: - collectionview header 로 변경 &
        calendarControl.frame = CGRect(origin: .zero, size: CGSize(width: 94, height: 24))
        collectionView.frame = CGRect(x: 0, y: 40, width: frame.width, height: frame.height - 24)
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
        
        applyInitialSnapshot()
    }
    
    // MARK: - Snapshot
    
    private func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        let weekdays = createWeekdayItems()
        snapshot.appendItems(weekdays, toSection: .weekday)
        
        let calendar = Calendar.current
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentDate)
        let nextMonth = calendar.date(byAdding: .month, value: +1, to: currentDate)

        let previousMonthDays = createDayItems(previousMonth!)
        let thisMonthDays = createDayItems(currentDate)
        let nextMonthDays = createDayItems(nextMonth!)
        let days = previousMonthDays + thisMonthDays + nextMonthDays
        snapshot.appendItems(days, toSection: .day)
        
        dataSource.apply(snapshot) { [weak self] in
            guard let strongSelf = self,
                  let thisMonthItem = thisMonthDays.first,
                  let indexPath = strongSelf.dataSource.indexPath(for: thisMonthItem) else { return }
            strongSelf.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    private func createWeekdayItems() -> [CalendarItem] {
        return ["일", "월", "화", "수", "목", "금", "토"]
            .map(CalendarItem.init(weekday:))
    }
    
    private func createDayItems(_ date: Date) -> [CalendarItem] {
        let calendar = Calendar.current
        let firstWeekDay = date.ext.firstWeekDay
        let currentMonthDayCount = date.ext.days
        Swift.print("month: \(date.ext.month), dayCount: \(currentMonthDayCount)")
        let previousMonthDayCountInThisMonth = (firstWeekDay - 1)
        
        // fill the remaining space in the current month's calendar with dates from the previous or next month
        return (1...42).map {
            let currentMonthRange = firstWeekDay...(currentMonthDayCount + previousMonthDayCountInThisMonth)
            if currentMonthRange.contains($0) {
                // Current month
                let day = ($0 - previousMonthDayCountInThisMonth)
                return CalendarItem(day: day, state: .normal)
            } else {
                // Other month
                if showOnlyCurrentMonthDates {
                    // Show empty view
                    return CalendarItem(day: $0, state: .none)
                } else {
                    // Show previous and next month dates
                    let isPreviousMonth = ($0 < firstWeekDay)
                    if isPreviousMonth {
                        let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: date)
                        let previousMonthDayCount = previousMonthDate!.ext.days
                        let day = previousMonthDayCount - (previousMonthDayCountInThisMonth - $0)
                        return CalendarItem(day: day, state: .none)
                    } else {
                        let day = $0 - (currentMonthDayCount + previousMonthDayCountInThisMonth)
                        return CalendarItem(day: day, state: .none)
                    }
                }
            }
        }
    }
    
    // MARK: - Cell Registration
    
    private func createWeekdayCellRegistration() -> UICollectionView.CellRegistration<TextCell, CalendarItem> {
        return UICollectionView.CellRegistration<TextCell, CalendarItem> { cell, index, item in
            cell.label.text = item.weekday
            cell.label.font = .pretendard(size: 12, weight: .medium)
            cell.label.textAlignment = .center
            cell.backgroundConfiguration = .clear()
        }
    }
    
    private func createDateCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, CalendarItem> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, CalendarItem> { cell, index, item in
            var content = DayContentView.Configuration()
            content.day = item.day
            content.status = item.dayState ?? .normal
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }
    
    private func visibleItemsWillDisplay(
        _ items: [any NSCollectionLayoutVisibleItem],
        scrollOffset: CGPoint,
        environment: NSCollectionLayoutEnvironment) {
            print("items: \(items.count), scrollOffset: \(scrollOffset)")
        }
    
    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { Swift.fatalError("Unknown section") }
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .absolute(32),
                    heightDimension: .absolute(32)))
            let weekGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .absolute(320),
                    heightDimension: .absolute(32)),
                subitem: item, count: 7)
            weekGroup.interItemSpacing = .fixed(16)
            var section: NSCollectionLayoutSection
            switch sectionKind {
            case .weekday:
                section = NSCollectionLayoutSection(group: weekGroup)
            case .day:
                let calendarGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(
                        widthDimension: .absolute(320),
                        heightDimension: .absolute(224)),
                    subitem: weekGroup, count: 6)
                calendarGroup.interItemSpacing = .fixed(16)
                section = NSCollectionLayoutSection(group: calendarGroup)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 32
                section.visibleItemsInvalidationHandler = self.visibleItemsWillDisplay(_:scrollOffset:environment:)
            }
            
            section.contentInsets = .init(top: 4.0, leading: 16, bottom: 4.0, trailing: 16)
            return section
        }
    }
}
