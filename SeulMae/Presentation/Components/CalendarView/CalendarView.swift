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

    private var today: Date?
    private var currentMonth: Int?
    var minimumDate: Date?
    var maximumDate: Date?

    let showOnlyCurrentMonthDates = false

    var onTap: ((_ date: Date) -> Void)?
    var dataSource: DataSource!
    var currentDate: Date = .ext.now
    var startPreload: Bool = false

    //    var currentYear: Int = 0
    //    var currentMonth: Int = 0
    //    var currentDay: Int = 0
    //
    //    private var firstWeekDay: Int = 0
    //
    //    private var numOfDaysInMonth = [
    //        31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    //    ]

    // MARK: - Life Cycle Method

    convenience init() {
        // onChange
        self.init(frame: .zero)
        let calendar = Calendar.current
        today = .ext.now
        currentMonth = calendar.dateComponents([.month], from: today!).month!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        minimumDate = formatter.date(from: "2010-01-01")!
        maximumDate = formatter.date(from: "2025-01-01")!

        // ???
        calendarControl.onChange = { [weak self] date in
            self?.currentDate = date
            self?.applyInitialSnapshot()
        }

        addSubview(calendarControl)
        addSubview(collectionView)

        setDataSource()

        // 애니메이션 넣을려면 contentView 하나로 인식
        // content view 하나당 달 하나
        // reuqest t
    }

    //    "userId": 2,
    //    "workDate": "2024-07-08",
    //    "isRequestApprove": true,
    //    "isManagerCheck": false,
    //    "idAttendanceRequestHistory": 5

    // var dayConfiguration:
    // 특정 날짜 꾸미기
    struct DayConfig {
        var backgroundColor: UIColor?
        var bedgeImage: UIImage?
    }

    func update(dateList: [Date], withConfig: DayConfig) {
        var snapshot = dataSource.snapshot()
        let items = snapshot.itemIdentifiers
        let existing = items.filter { item in
            dateList.contains(where: { $0 == item.date! })
        }
    }

    func setEvents(month: Int, days: [Int], withDayConfig: DayConfig) {

    }

    var onMonthChange: ((Int) -> Void)?
    var onDaySelect: ((Int) -> Void)?
    // 바뀌는 걸 알고 달력에 다시 넣어줄려면
    // 옵저블로 연결되어야 함

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
        var dates: [Date] = []
        var currentDate = minimumDate
        while currentDate! <= maximumDate! {
            dates.append(currentDate!)
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate!)!
        }
        let items = dates.flatMap(createDayItems)
        snapshot.appendItems(items, toSection: .day)

        dataSource.apply(snapshot) { [weak self] in
//            guard let strongSelf = self,
//                  let thisMonthItem = currentMonthDays.first,
//                  let indexPath = strongSelf.dataSource.indexPath(for: thisMonthItem) else { return }
//            strongSelf.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//            strongSelf.startPreload = true
        }
    }
    
    func some(page: Int) {
        if (!startPreload) { return }
        
        let snapshot = dataSource.snapshot()
        let items = snapshot.itemIdentifiers(inSection: .day)
        let pageCounts = (items.count / 42)
        let lastPageIndex = (pageCounts - 1)
        if (page == 0) {
            print("need previos month")
            // month 확인
            
        } else if (lastPageIndex == page) {
            print("need next month")
            // month 확인
            
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
                return CalendarItem(date: date, day: day, state: .normal)
            } else {
                // Other month
                if showOnlyCurrentMonthDates {
                    // Show empty view
                    return CalendarItem(date: date, day: $0, state: .none)
                } else {
                    // Show previous and next month dates
                    let isPreviousMonth = ($0 < firstWeekDay)
                    if isPreviousMonth {
                        let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: date)
                        let previousMonthDayCount = previousMonthDate!.ext.days
                        let day = previousMonthDayCount - (previousMonthDayCountInThisMonth - $0)
                        return CalendarItem(date: previousMonthDate!, day: day, state: .none)
                    } else {
                        let nextMonthDate = calendar.date(byAdding: .month, value: +1, to: date)
                        let day = $0 - (currentMonthDayCount + previousMonthDayCountInThisMonth)
                        return CalendarItem(date: nextMonthDate!, day: day, state: .none)
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
        offset: CGPoint,
        environment: NSCollectionLayoutEnvironment) {
//          items.forEach { item in
//              let frame = item.frame
//              let rect = CGRect(x: offset.x, y: offset.y, width: environment.container.contentSize.width, height: frame.height)
//              let inter = rect.intersection(frame)
//              let percent: CGFloat = inter.width / frame.width
//              let scale = 0.8 + (0.2 * percent)
//              item.transform = CGAffineTransform(scaleX: 0.98, y: scale)
//          }
            let contentSize = environment.container.contentSize.width
            let page = Int(max(.zero, round(offset.x / contentSize)))
            some(page: page)
        }
    
    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let sectionKind = Section(rawValue: sectionIndex) else {
                Swift.fatalError("Unknown section")
            }
            
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
                section.visibleItemsInvalidationHandler = self.visibleItemsWillDisplay(_:offset:environment:)
            }
            
            section.contentInsets = .init(top: 4.0, leading: 16, bottom: 4.0, trailing: 16)
            return section
        }
    }
}
