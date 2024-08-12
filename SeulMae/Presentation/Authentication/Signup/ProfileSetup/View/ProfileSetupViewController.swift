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
    
    // MARK: - Dependency
    
    private var viewModel: ProfileSetupViewModel!
    
    // MARK: - UI
    
    private let stepLabel: UILabel = .title(title: "프로필을\n완성해주세요")
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .userProfile
        return imageView
    }()
    
    private let genderLabel: UILabel = .callout(title: "성별")
    
    private let maleRadioButton: RadioButton = {
        let button = RadioButton()
        button.setTitle("남성", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.iconConfiguration.iconColor = .primary
        button.iconConfiguration.indicatorColor = .primary
        button.allowsMultipleSelection = false
        button.animationDuration = 0.0
        button.isSelected = true
        return button
    }()
    
    private lazy var femaleRadioButton: RadioButton = {
        let button = RadioButton()
        button.setTitle("여성", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.iconConfiguration.iconColor = .primary
        button.iconConfiguration.indicatorColor = .primary
        button.allowsMultipleSelection = false
        button.animationDuration = 0.0
        button.associatedButtons.append(maleRadioButton)
        return button
    }()
    
    private lazy var genderHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 24
        return stackView
    }()
    
    private let genderVStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .leading
        return stackView
    }()
    
    private let nameLabel: UILabel = .callout(title: "이름")
    
    private let nameTextField: UITextField = .common(placeholder: "이름 입력")
    
    private let nameValidationResultLabel: UILabel = .footnote()
    
    private lazy var nameVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
           
        ])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let birthdayLabel: UILabel = .callout(title: "생년월일")
    
    private let birthdayTextField: UITextField = {
        let tf = UITextField.common(placeholder: "YYYY/MM/DD")
        if #available(iOS 17.0, *) {
            tf.textContentType = .birthdate
        }
        tf.keyboardType = .numberPad
        return tf
    }()

    private let birthdayValidationResultLabel: UILabel = .footnote()
    
    private lazy var birthdayVStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let nextStepButton: UIButton = .common(title: "가입완료")
    
    // MARK: - Properties
    
    private let phPickerViewController: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        return pickerViewController
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavItem()
        setupConstraints()
        bindSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        // Handle background taps
        let tapBackground = UITapGestureRecognizer()
        Task {
            for await _ in tapBackground.rx.event.asSignal().values {
                view.endEditing(true)
            }
        }
        view.addGestureRecognizer(tapBackground)
        
        // Handle profileImageView taps
        let tapImageView = UITapGestureRecognizer()
        Task {
            for await _ in tapImageView.rx.event.asSignal().values {
                present(phPickerViewController, animated: true)
            }
        }
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapImageView)
        
        // Handle picked image
        let image = phPickerViewController.rx.picked.asSignal()
        Task {
            for await image in image.values {
                profileImageView.image = image
            }
        }
        let imageData = image.compactMap { $0.jpegData(compressionQuality: 0.75) }
        
        // Merge male and femail button taps
        let male = maleRadioButton.rx.tap
            .map { _ in true }
            .asSignal()
        let female = femaleRadioButton.rx.tap
            .map { _ in false }
            .asSignal()
        let isMale = Signal.merge(male, female)
            .distinctUntilChanged()
        
        // Limit nameTextField max length
        let nameMaxLength = 8
        let name = nameTextField.rx
            .text
            .orEmpty
            .map { String($0.prefix(nameMaxLength)) }
            .asDriver()
        
        Task {
            for await name in name.values {
                nameTextField.text = name
            }
        }
        
        // Limit birthdayTextField max length
        let birthdayMaxLength = 8
        let birthday = birthdayTextField.rx
            .text
            .orEmpty
            .map { $0.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) }
            .map { String($0.prefix(birthdayMaxLength)) }
            .asDriver()
        
        Task {
            for await birthday in birthday.values {
                birthdayTextField.text = applyBirthdayFormat(text: birthday)
            }
        }
        
        // Apply birthday format (YYYY/MM/DD) to birthdayTextField
        func applyBirthdayFormat(text: String) -> String {
            var formatted = ""
            for (index, num) in text.enumerated() {
                if index == 4 || index == 6 {
                    formatted.append("/")
                }
                formatted.append(num)
            }
            return formatted
        }

        let output = viewModel.transform(
            .init(
                image: imageData,
                isMale: isMale,
                username: name,
                birthday: birthday,
                nextStep: nextStepButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await result in output.validatedUsername.values {
                nameValidationResultLabel.ext.setResult(result)
            }
        }
        
        Task {
            for await result in output.validatedBirthday.values {
                birthdayValidationResultLabel.ext.setResult(result)
            }
        }
        
        Task {
            for await isEnabled in output.nextStepEnabled.values {
                nextStepButton.ext.setEnabled(isEnabled)
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavItem() {
        navigationItem.title = "회원가입"
    }
    
    private func setupConstraints() {
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 40
        contentStackView.addArrangedSubview(genderVStack)
        contentStackView.addArrangedSubview(nameVStackView)
        contentStackView.addArrangedSubview(birthdayVStack)

        view.addSubview(stepLabel)
        view.addSubview(profileImageView)
        view.addSubview(contentStackView)
        view.addSubview(nameValidationResultLabel)
        view.addSubview(birthdayValidationResultLabel)
        view.addSubview(nextStepButton)
        
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        nameValidationResultLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayValidationResultLabel.translatesAutoresizingMaskIntoConstraints = false
        nextStepButton.translatesAutoresizingMaskIntoConstraints = false
        
        genderVStack.addArrangedSubview(genderLabel)
        genderVStack.addArrangedSubview(genderHStackView)
        
        genderHStackView.addArrangedSubview(maleRadioButton)
        genderHStackView.addArrangedSubview(femaleRadioButton)

        nameVStackView.addArrangedSubview(nameLabel)
        nameVStackView.addArrangedSubview(nameTextField)
        
        birthdayVStack.addArrangedSubview(birthdayLabel)
        birthdayVStack.addArrangedSubview(birthdayTextField)
        
        NSLayoutConstraint.activate([
            // Constraints stepLabel
            stepLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stepLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stepLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 52),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Constraints contentStackView
            contentStackView.leadingAnchor.constraint(equalTo: stepLabel.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 32),
            contentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Constraints nextStepButton
            nextStepButton.leadingAnchor.constraint(equalTo: stepLabel.leadingAnchor),
            nextStepButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextStepButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextStepButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Constraints validation result label
            nameValidationResultLabel.leadingAnchor.constraint(equalTo: stepLabel.leadingAnchor),
            nameValidationResultLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8.0),
            birthdayValidationResultLabel.leadingAnchor.constraint(equalTo: stepLabel.leadingAnchor),
            birthdayValidationResultLabel.topAnchor.constraint(equalTo: birthdayTextField.bottomAnchor, constant: 8.0),
            
            // Constraints textField height
            nameTextField.heightAnchor.constraint(equalToConstant: 48),
            birthdayTextField.heightAnchor.constraint(equalToConstant: 48),
            
            // Constraints imageView
            profileImageView.heightAnchor.constraint(equalToConstant: 88),
            profileImageView.widthAnchor.constraint(equalToConstant: 88)
        ])
    }
}
