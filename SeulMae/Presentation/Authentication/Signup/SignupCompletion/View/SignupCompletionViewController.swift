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
    private var stepGuideLabel: UILabel = .title(Text.stepGuide)
    private var nextStepButton: UIButton = .common(title: Text.nextStep)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavItem()
        configureHierarchy()
    }

    // MARK: - Nav Item
    
    private func configureNavItem() {
        
    }
    
    // MARK: - Hierarchy
    
    private func configureHierarchy() {
        let subViews: [UIView] = [
            completionGuideLabel, stepGuideLabel, nextStepButton
        ]
        subViews.forEach(view.addSubview)
        
        completionGuideLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(144)
            make.top.equalTo(view.snp_topMargin).inset(132)
            make.centerX.equalToSuperview()
        }
        
        stepGuideLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(106)
            make.top.equalTo(completionGuideLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
//        nameFieldVStack.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(20)
//            make.top.equalTo(genderFieldVStack.snp.bottom).offset(16)
//            make.centerX.equalToSuperview()
//        }
        
        nextStepButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp_bottomMargin).inset(24)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
        }
    }
}

