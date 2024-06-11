//
//  SignupCompletionViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit

final class SignupCompletionViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: SignupCompletionViewModel) -> SignupCompletionViewController {
        let view = SignupCompletionViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: - Dependency
    
    private var viewModel: SignupCompletionViewModel!
    
    private var guideLabel: UILabel!
    private var nameFieldGuideLabel: UILabel!
    private var nameTextField: UITextField!
    private var FieldGuideLabel: UILabel!
    private var TextField: UITextField!
    private var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

