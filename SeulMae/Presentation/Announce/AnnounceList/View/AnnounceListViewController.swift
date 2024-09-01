//
//  AnnounceListViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AnnounceListViewController: UIViewController {
    
    private let viewModel: AnnounceListViewModel!
    
    init(viewModel: AnnounceListViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavItem() {
        navigationItem.title = "공지사항"
    }
}
