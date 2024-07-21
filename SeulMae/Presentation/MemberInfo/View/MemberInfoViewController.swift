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
    
    static func create(viewModel: MemberInfoViewModel) -> MemberInfoViewController {
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
    
    private let _workScheduleLabel = UILabel.section(title: AppText.workSchedule)

    private let workScheduleView = WorkScheduleView()
    
    // MARK: - Personal UI
        
    private let _workLogLabel = UILabel.section(title: AppText.workLog)

    private let dateRangePickerView = DateRangePickerView()
    
    private let workLogsSummaryView = WorkLogsSummaryView()
    
    private let workLogTableView = UITableView()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - Dependencies
    
    private var viewModel: MemberInfoViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onLoad()
        setDataSource()
        onBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Swift.print(#fileID, #line, "🐹🐹🐹🐹🐹🐹")
    }
    
    // MARK: - Data Binding
    
    private func onBind() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asSignal()
            .do { _ in
                Swift.print(#fileID, #line, "🐹🐹🐹🐹🐹🐹")
            }
        
        Task {
            for await onLoad in onLoad.values {
                Swift.print(#fileID, #line, "🐹🐹🐹🐹🐹🐹")
            }
        }
        
        let output = viewModel.transform(
            .init(
                onLoad: onLoad
                // onUserImageTap -> view 에서 처리..?
//                onContactTap: -> view 에서 처리?,
                // onWorkScheduleTap
//                onDateRangeSelected: ,
//                onScheduleTap: ,
//                onWorkLogTap:
            )
        )
        
        Task {
            for await memberInfo in output.memberInfo.values {
                // TODO: memberInfo -> item 변환하여 필수 정보가 없을 시 error
                Swift.print(#fileID, "🐹 RECEVIED DATA:\nmemberInfo: \(memberInfo)")
                memberProfileView.imageURL = memberInfo.imageURL
                memberProfileView.name = memberInfo.name
                memberProfileView.joinDate = memberInfo.joinDate
                memberProfileView.phoneNumber = memberInfo.phoneNumber
                // scheduleListView.items = memberInfo.sch
                //
            }
        }
    }
    
    // MARK: - On Load
    
    private func onLoad() {
        view.backgroundColor = .systemBackground
        
        let separator = UIView()
        separator.backgroundColor = .border
        separator.heightAnchor
            .constraint(equalToConstant: 1.0)
            .isActive = true
        
        let stack = UIStackView(arrangedSubviews: [
            memberProfileView,
            _workScheduleLabel,
            workScheduleView,
            separator,
            _workLogLabel,
            dateRangePickerView,
            workLogsSummaryView,
            workLogTableView
        ])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
                .inset(16)
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

