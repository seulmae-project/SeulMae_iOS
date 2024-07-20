//
//  MemberInfoViewController.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MemberInfoViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: MemberViewModel) -> MemberInfoViewController {
        let view = MemberInfoViewController()
        view.viewModel = viewModel
        return view
    }
    
    static let reuseIdentifier = "reuse-id"
    
    // MARK: - Internal Types
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Item>
    
    enum Section: CaseIterable {
        case list
    }
    
    struct Item: Hashable {
        var id: String = UUID().uuidString
        var isAccept: Bool = false
        var date: Date?
        var duration: String = ""
        var wage: String = ""
    }
    
    // MARK: - Public UI

    private let memberProfileView = MemberProfileView()
    
    private let workScheduleLabel = UILabel.title(title: AppText.workSchedule)

    private let workScheduleView = WorkScheduleView()
    
    // MARK: - Personal UI
    
    private let wageLabel = UILabel()
    
    private let workLogLabel = UILabel.title(title: AppText.workLog)

    private let dateRangePickerView = DateRangePickerView()
    
    private let workLogSummaryView = UIView()
    
    private let workLogTableView = UITableView()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - Dependencies
    
    private var viewModel: MemberViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onLoad()
        setDataSource()
        onBind()
    }
    
    // MARK: - Data Binding
    
    private func onBind() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                onLoad: onLoad
//                onContactTap: ,
//                onDateRangeSelected: ,
//                onScheduleTap: ,
//                onWorkLogTap:
            )
        )
        
        Task {
            for await memberInfo in output.memberInfo.values {
                // TODO: memberInfo -> item 변환하여 필수 정보가 없을 시 error
                memberProfileView.imageURL = memberInfo.imageURL
                memberProfileView.name = memberInfo.name
                memberProfileView.joinDate = memberInfo.joinDate
                memberProfileView.phoneNumber = memberInfo.phoneNumber
                // scheduleListView.items = memberInfo.sch
                //
            }
        }
        
//        Task {
//            for await workLogList in output.workLogList.values {
//                workLogListView = workLogList
//            }
//        }
    }
    
    // MARK: - On Load
    
    private func onLoad() {
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [
            memberProfileView,
            workScheduleLabel,
            workScheduleView,
            separator,
            workLogLabel,
            workLogTableView
        ])
        stack.axis = .vertical
        stack.spacing = 8.0
        stack.setCustomSpacing(8.0, after: memberProfileView)
        stack.setCustomSpacing(8.0, after: workScheduleView)
        stack.setCustomSpacing(8.0, after: separator)
        view.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Set Data Source
    
    func setDataSource() {
        dataSource = DataSource(tableView: workLogTableView, cellProvider: { view, index, item in
            let cell = view.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: index)
            var content = WorkLogContentView.Configuration()
            content.isAccept = item.isAccept
            content.date = item.date
            content.duration = item.duration
            content.wage = item.wage
            cell.contentConfiguration = content
            return cell
        })
        
        dataSource.defaultRowAnimation = .fade
    }
}

