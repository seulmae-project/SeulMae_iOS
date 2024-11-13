//
//  AttHistoriesViewController.swift
//  SeulMae
//
//  Created by 조기열 on 11/13/24.
//

import UIKit

class AttHistoriesViewController: BaseViewController {

    typealias DataSource = UITableViewDiffableDataSource<Int, AttendanceHistory>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, AttendanceHistory>

    let reuseIdentifier = "att-histories-reuse-id"

    let placeImageView = UIImageView()
        .ext.size(width: 88, height: 88)
        .ext.round(radius: 44)

    let placeNameLabel = UILabel()
        .ext.font(.pretendard(size: 16, weight: .semibold))

    let searchBar = UIView()

    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
        .ext.refresh(refreshControl)

    var viewModel: AttHistoriesViewModel!
    var dataSource: DataSource!

    convenience init(viewModel: AttHistoriesViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureDataSource()
        bindInternalSubview()
    }

    private func configureHierarchy() {
        view.backgroundColor = .white
        
        let imageStack = UIStackView()
        imageStack.axis = .vertical
        imageStack.alignment = .center
        imageStack.spacing = 12
        [placeImageView, placeNameLabel]
            .forEach(imageStack.addArrangedSubview(_:))

        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let emptyView = SMEmptyView(message: "근무이력 empty 메세지")
        emptyView.backgroundColor = .white
        tableView.backgroundView = emptyView

        let views = [imageStack, searchBar, tableView]
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            imageStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 58),

            searchBar.heightAnchor.constraint(equalToConstant: 44),

            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: imageStack.bottomAnchor, constant: 36),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }

    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
            var content = AttHistoryContentView.Configuration()
            content.att = itemIdentifier
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
            return cell
        })
    }

    private func bindInternalSubview() {
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                onRefresh: onRefresh,
                onSearch: .empty(),
                onFilter: .empty(),
                showDetails: .empty()
            ))
        
        output.attHistories
            .drive(with: dataSource, onNext: { (dataSource, items) in
                var snapshot = Snapshot()
                snapshot.appendSections([0])
                snapshot.appendItems(items)
                dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)

        output.loading
            .drive(loadingIndicator.ext.isAnimating)
            .disposed(by: disposeBag)
    }
}
