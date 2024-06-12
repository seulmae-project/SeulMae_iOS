//
//  ProfileSetupViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit

final class ProfileSetupViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: ProfileSetupViewModel) -> ProfileSetupViewController {
        let view = ProfileSetupViewController()
        view.viewModel = viewModel
        return view
    }
    
    enum Text {
        static let stepGuide = "프로필을\n완성해주세요"
        static let nameFieldGuide = "이름"
        static let nameTextFieldPlaceholder = "이름 입력"
        static let genderFieldGuide = "성별"
        static let birthdayFieldGuide = "생년월일"
        static let birthdayTextFieldPlaceholder = "생년월일"
        static let nextStep = "다음으로"
    }
    
    // MARK: - Dependency
    
    private var viewModel: ProfileSetupViewModel!
    
    // MARK: - UI
    
    private var stepGuideLabel: UILabel = .title(Text.stepGuide)
    private var nameFieldGuideLabel: UILabel = .callout(title: Text.nameFieldGuide)
    private var nameTextField: UITextField = .common(placeholder: Text.nameTextFieldPlaceholder)
    private var genderFieldGuideLabel: UILabel = .callout(title: Text.genderFieldGuide)
    private var genderSegmentController: UISegmentedControl!
    private var birthdayFieldGuideLable: UILabel = .callout(title: Text.birthdayFieldGuide)
    private var birthdayTextField: UITextField = .common(placeholder: Text.birthdayFieldGuide)
    private var nextStepButton: UIButton = .common(title: Text.nextStep)
    
    // MARK: - Life Cycle

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
        
    }
}
