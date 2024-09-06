//
//  ManagerHomeViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/5/24.
//

import UIKit

final class ManagerHomeViewController: UIViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<AttendanceListSection, AttendanceListItem>
    typealias DataSource = UICollectionViewDiffableDataSource<AttendanceListSection, AttendanceListItem>
    
    private let notiRightBarButton = UIBarButtonItem(image: .bell, style: .plain, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
}
