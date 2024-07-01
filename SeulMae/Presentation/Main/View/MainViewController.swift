//
//  MainViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Flow
    
    static func create(viewModel: MainViewModel) -> MainViewController {
        let view = MainViewController()
        view.viewModel = viewModel
        return view
    }
    
    enum Text {
        static let accountIDFieldGuide = "아이디"
    }
    
    // MARK: - Dependency
    
    private var viewModel: MainViewModel!
    
    // MARK: - UI
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
    }
    
    private func bindInternalSubviews() {
        let output = viewModel.transform(
            .init(
             
            )
        )
    }

    private func configureHierarchy() {
        
    }
}

