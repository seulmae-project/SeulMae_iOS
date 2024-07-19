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
        case weekday
        case day
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
    
    // MARK: UI Properties
    
    private lazy var calendarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout())
        Swift.print("collectionView.bounds: \(collectionView.bounds)")
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private var calendarControl = MonthView()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    var currentYear: Int = 0
    
    var currentMonth: Int = 0
    
    var currentDay: Int = 0
    
    var firstWeekDay: Int = 0
    
    var numOfDaysInMonth = [
        31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    ]
    
    var weekdays = [
        "일", "월", "화", "수", "목", "금", "토"
    ]

    // MARK: - Life Cycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray
        
        let now = Date.ext.now
        currentYear = Calendar.current.component(.year, from: now)
        currentMonth = Calendar.current.component(.month, from: now)
        currentDay = Calendar.current.component(.day, from: now)
        firstWeekDay = now.ext.firstWeekDay
        
        configureHierarchy()
        configureDataSource()
        Swift.print(#function, #fileID, "test")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        Swift.print(#function, #fileID, "view: \(frame)")
        Swift.print("calendarControl: \(calendarControl.frame)")
        Swift.print("calendarCollectionView: \(calendarCollectionView.frame)")
        
        calendarControl.frame = CGRect(origin: .zero, size: CGSize(width: 94, height: 24))
        
        addSubview(calendarCollectionView)
        calendarCollectionView.frame = CGRect(x: 0, y: 24, width: frame.width, height: frame.height - 24)
    }
    
    // MARK: - Hierarchy
    
    private func configureHierarchy() {
        addSubview(calendarControl)
        // 이친구도 높이를 어떻게 정할 것인가..?
//        calendarControl.frame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: 100))
//        
//        addSubview(calendarCollectionView)
//        calendarCollectionView.frame = CGRect(x: 0, y: 100, width: frame.width, height: frame.height - 100)
//        collectionView.snp.makeConstraints {
//            $0.leading.trailing.top.bottom.equalToSuperview()
//        }
    }
    
    // MARK: - DataSource
    
    private func configureDataSource() {
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
        Swift.print("currentDayCount: \(currentDayCount)")
        ForLeapYears: if currentYear.ext.isLeapYear && currentMonth == 2 {
            currentDayCount += 1
        }
        
        var totalDayCount = currentDayCount
        
        /// Tag: add previous month day
        let previousDayCount = (firstWeekDay - 1)
        Swift.print("previousDayCount: \(previousDayCount)")
        totalDayCount += previousDayCount
        
        /// Tag: add next month day
        totalDayCount = totalDayCount % 7 == 0 ? totalDayCount : totalDayCount + 7 - (totalDayCount % 7)
        
        Swift.print("totalDayCount: \(totalDayCount)")
        
        let items = (1...totalDayCount).map {
            if $0 <= previousDayCount {
                /// Tag: previous month day
                let previousMonth = (currentMonth == 1) ? 12 : currentMonth - 1
                var previousMonthCount = numOfDaysInMonth[previousMonth - 1]
                ForLeapYears: if currentYear.ext.isLeapYear && previousMonth == 2 {
                    previousMonthCount += 1
                }
                
                // 30 -(2 - 2)
                print("previousMonthCount: \(previousMonthCount)")
                print("firstWeekDay: \(firstWeekDay)")
                // 31
                let day = previousMonthCount - (firstWeekDay - 2)
                print("1 $0: \($0), day: \(day)")
                return Item(day: day, status: .normal)
            } else if $0 > (currentDayCount + previousDayCount) {
                /// Tag: next month day
                let day = $0 - (currentDayCount + previousDayCount)
                print("2 $0: \($0), day: \(day)")
                return Item(day: day, status: .normal)
            } else {
                /// Tag: current month day
                let day = ($0 - (firstWeekDay - 1))
                print("3 $0: \($0), day: \(day)")
                return Item(day: day, status: .normal)
            }
        }
        
        Swift.print(#function, #fileID, "items.count: \(items.count)")
        return items
    }
    
    private func createWeekdayItem() -> [Item] {
        let items = weekdays.map(Item.init(weekday:))
        return items
    }
    
    // MARK: - Cell Registration
    
    private func createWeekdayCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, index, item in
            Swift.print(#function, #fileID, "test1")

            var content = cell.defaultContentConfiguration()
            content.text = item.weekday
            content.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
            content.textProperties.color = .graphite
            cell.contentConfiguration = content

        }
    }
    
    private func createDateCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, index, item in
            Swift.print(#function, #fileID, "test2")

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
                    heightDimension: .estimated(44)))
            // item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(44)),
                subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}
