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
    
    enum Text {
        static let completion = "회원 가입 완료"
        static let stepGuide = "원트립님,\n만나서 반가워요!"
    
        static let nextStep = "로그인하러가기"
    }
    
    // MARK: - Dependency
    
    private var viewModel: SignupCompletionViewModel!
    
    private var completionGuideLabel: UILabel = .callout(title: Text.completion)
    private var guideLabel: UILabel = .title(Text.stepGuide)
    private var nextStepButton: UIButton = .common(title: Text.nextStep)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

