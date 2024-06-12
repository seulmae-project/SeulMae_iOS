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
    
    private let completionGuideLabel: UILabel = .callout(title: Text.completion)
    private let stepGuideLabel: UILabel = .title(title: Text.stepGuide)
    private let completionImageView: UIImageView = UIImageView()
    private let nextStepButton: UIButton = .common(title: Text.nextStep)
   
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
        let completionVStack = UIStackView(arrangedSubviews: [
            completionGuideLabel, stepGuideLabel, completionImageView
        ])
        completionVStack.axis = .vertical
        completionVStack.alignment = .center
        completionVStack.spacing = 8.0
        completionVStack.setCustomSpacing(26, after: stepGuideLabel)
        
        let subViews: [UIView] = [
            completionVStack, nextStepButton
        ]
        subViews.forEach(view.addSubview)
        
        completionVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(144)
            make.centerX.equalToSuperview()
        }
        
        completionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(120)
        }
        
        nextStepButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp_bottomMargin).inset(24)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
        }
    }
}

