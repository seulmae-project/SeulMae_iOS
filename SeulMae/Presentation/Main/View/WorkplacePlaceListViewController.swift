//
//  WorkplacePlaceListViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import UIKit

final class WorkplacePlaceListViewController: UIViewController {
    
    private var viewModel: WorkplaceListViewModel
    
    init(viewModel: WorkplaceListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
}
