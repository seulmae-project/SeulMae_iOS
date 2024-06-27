//
//  ProfileSetupViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

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
        static let male = "남성"
        static let female = "여성"
        static let birthdayFieldGuide = "생년월일"
        static let birthdayTextFieldPlaceholder = "생년월일"
        static let nextStep = "다음으로"
    }
    
    // MARK: - Dependency
    
    private var viewModel: ProfileSetupViewModel!
    
    private var phpPicker: PHPickerViewController?
    
    // MARK: - UI
    
    private let stepGuideLabel: UILabel = .title(title: Text.stepGuide)
    private let profileImageView = UIImageView()
    private let nameFieldGuideLabel: UILabel = .callout(title: Text.nameFieldGuide)
    private let nameTextField: UITextField = .common(placeholder: Text.nameTextFieldPlaceholder)
    private let usernameValidationResultLabel: UILabel = .footnote()
    
    private let genderFieldGuideLabel: UILabel = .callout(title: Text.genderFieldGuide)
    private let maleRadioButton: RadioButton = .common(title: Text.male)
    private let femaleRadioButton: RadioButton = .common(title: Text.female)
    private let birthdayFieldGuideLable: UILabel = .callout(title: Text.birthdayFieldGuide)
    private let birthdayTextField: UITextField = .common(placeholder: Text.birthdayFieldGuide)
    private let nextStepButton: UIButton = .common(title: Text.nextStep)
    
    private var picker: UIPickerView!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavItem()
        configureHierarchy()
        bindInternalSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
        
        let tapBackground = UITapGestureRecognizer()
        Task {
            for try await available in tapBackground.rx.event.values {
                view.endEditing(true)
            }
        }
        
        view.addGestureRecognizer(tapBackground)
        
        let male = maleRadioButton.rx.tag.asSignal()
        let female = femaleRadioButton.rx.tag.asSignal()
        let gender = Signal.merge(male, female)

        let output = viewModel.transform(
            .init(
                image: phpPicker!.rx.data.asSignal(),
                gender: gender,
                username: nameTextField.rx.text.orEmpty.asDriver(),
                year: picker.rx.itemSelected.map { $1 }.asSignal(),
                month: picker.rx.itemSelected.map { $1 }.asSignal(),
                day: picker.rx.itemSelected.map { $1 }.asSignal(),
                nextStep: nextStepButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await validatedUsername in output.validatedUsername.values {
                usernameValidationResultLabel.rx.validationResult.onNext(validatedUsername)
            }
        }
        
        Task {
            for await available in output.nextStepEnabled.values {
                nextStepButton.isEnabled = !available
            }
        }
    }

    // MARK: - Nav Item
    
    private func configureNavItem() {
        
    }
    
    // MARK: - Hierarchy
    
    private func configureHierarchy() {
        let genderFieldHStack = UIStackView(arrangedSubviews: [
            maleRadioButton, femaleRadioButton
        ])
        genderFieldHStack.spacing = 24
        
        let genderFieldVStack = UIStackView(arrangedSubviews: [
            genderFieldGuideLabel, genderFieldHStack
        ])
        
        let nameFieldVStack = UIStackView(arrangedSubviews: [
            nameFieldGuideLabel, nameFieldGuideLabel, usernameValidationResultLabel
        ])
        nameFieldVStack.axis = .vertical
        nameFieldVStack.spacing = 4.0
        
        let birthdayFieldHStack = UIStackView(arrangedSubviews: [
            
        ])
        let birthdayFieldVStack = UIStackView(arrangedSubviews: [
            birthdayFieldGuideLable
        ])
        birthdayFieldVStack.axis = .vertical
        
        let subViews: [UIView] = [
            stepGuideLabel, genderFieldVStack, nameFieldVStack, birthdayFieldVStack, nextStepButton
        ]
        subViews.forEach(view.addSubview)
        
        stepGuideLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.snp_topMargin).inset(24)
            make.centerX.equalToSuperview()
        }
        
        genderFieldVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(stepGuideLabel.snp.bottom).offset(52)
            make.centerX.equalToSuperview()
        }
        
        nameFieldVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(genderFieldVStack.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        birthdayFieldVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(nameFieldVStack.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        birthdayFieldHStack.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        nextStepButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp_bottomMargin).inset(24)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
        }
    }
}


