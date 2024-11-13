//
//  UnhandledAttListViewController.swift
//  SeulMae
//
//  Created by 조기열 on 11/12/24.
//

import UIKit
import RxSwift
import RxCocoa

class UnhandledAttListViewController: UIViewController {

    typealias DataSource = UITableViewDiffableDataSource<Int, Attendance>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Attendance>

    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let reuseIdentifier = "unhandled-att-reuse-id"
    var dataSource: DataSource!
    var attRelay = PublishRelay<(Attendance.ID, Bool)>()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureDataSource()
    }

    func applySnapshot(_ items: [Attendance]) {
        tableView.backgroundView?.isHidden = !items.isEmpty
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot)
    }

    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        let emptyView = SMEmptyView(message: "대기중인 요청이 없어요")
        emptyView.backgroundColor = .white
        tableView.backgroundView = emptyView
    }

    func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
            var content = UnhandledAttContentView.Configuration()
            content.att = itemIdentifier
            content.onTap = { [weak self] isOk in
                self?.attRelay.accept((itemIdentifier.id, isOk))
            }
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
            return cell
        })
    }
}
