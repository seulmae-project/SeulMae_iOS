//
//  AddNewWorkplaceViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/13/24.
//

import UIKit

final class AddNewWorkplaceViewController: UIViewController {
    
    private let workplaceMainImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let nameLabel: UILabel = .callout(title: "근무지 이름")
    private let nameTextField: UITextField = .common(placeholder: "근무지 이름 입력")
    private let nameValidationResultLabel: UILabel = .footnote()
    
    private let contactLabel: UILabel = .callout(title: "근무지 연락처")
    private let contactTextField: UITextField = .common(placeholder: "근무지 이름 입력")
    private let contactValidationResultLabel: UILabel = .footnote()

    private let addressLabel: UILabel = .callout(title: "근무지 주소")
    private let addresssTextField: UITextField =  .common(placeholder: "근무지 주소 입력")
    private let addressValidationResultLabel: UILabel = .footnote()
 
    private var viewModel: AddNewWorkplaceViewModel
    
    init(viewModel: AddNewWorkplaceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindSubviews() {
        let output = viewModel.transform(
            .init(
                mainImage: .empty(),
                name: .empty(),
                contact: .empty(),
                address: .empty(),
                addNew: .empty()
            )
        )
        // Handle Button enabled
        Task {
            for await _ in output.AddNewEnabled.values {
                
            }
        }
        //
        Task {
            for await _ in output.AddNewEnabled.values {
                
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavItem() {
        navigationItem.title = "근무지 생성"
    }
    
    private func setupConstraints() {
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 40
        
        view.addSubview(contentStack)
        view.addSubview(nameValidationResultLabel)
        view.addSubview(contactValidationResultLabel)
        view.addSubview(addressValidationResultLabel)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        nameValidationResultLabel.translatesAutoresizingMaskIntoConstraints = false
        contactValidationResultLabel.translatesAutoresizingMaskIntoConstraints = false
        addressValidationResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.addSubview(nameLabel)
        contentStack.addSubview(nameTextField)
        contentStack.addSubview(contactLabel)
        contentStack.addSubview(contactTextField)
        contentStack.addSubview(addressLabel)
        contentStack.addSubview(addresssTextField)
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.topAnchor.constraint(equalTo: view.bottomAnchor),
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Constarint validation result message
            nameValidationResultLabel.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            nameValidationResultLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8.0),
            contactValidationResultLabel.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            contactValidationResultLabel.topAnchor.constraint(equalTo: contactTextField.bottomAnchor, constant: 8.0),
            addressValidationResultLabel.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            addressValidationResultLabel.topAnchor.constraint(equalTo: addresssTextField.bottomAnchor, constant: 8.0),
            
            // Constraint textFields height
            addresssTextField.heightAnchor.constraint(equalToConstant: 48),
            contactTextField.heightAnchor.constraint(equalToConstant: 48),
            addresssTextField.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}
