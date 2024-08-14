//
//  WorkplaceDetailsViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/14/24.
//

import UIKit

final class WorkplaceDetailsViewController: UIViewController {
    
// MAin image and common 구성
    private let workplaceMainImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let nameLabel: UILabel = .callout(title: "근무지")
    private let workplaceNameLabel: UILabel = .callout(title: "")
    
    private let workplaceManagerLabel: UILabel = .callout(title: "매니저")
    
    private let contactLabel: UILabel = .callout(title: "연락처")
    private let workplaceContactLabel: UILabel = .callout(title: "연락처")

    private let addressLabel: UILabel = .callout(title: "주소")
    private let workplaceAddressLabel: UILabel = .footnote(title: "주소")
    
    private let membersLabel: UILabel = .callout(title: "참여인원")
    private let workplaceMembersLabel: UILabel = .footnote(title: "-명")
    
    private let joinWorkplaceButton: UIButton = .common(title: "입장하기")
 
    private var viewModel: WorkplaceDetailsViewModel
    
    init(viewModel: WorkplaceDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        setupNavItem()
        setupConstraints()
        bindSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindSubviews() {
        let output = viewModel.transform(
            .init(joinWorkplace: joinWorkplaceButton.rx.tap.asSignal())
        )
        // Handle api loading
        Task {
            for await isLoading in output.isLoading.values {
                Swift.print(isLoading)
            }
        }
        // Handle workplace details information
        Task {
            for await details in output.details.values {
                // workplaceMainImageView
                workplaceNameLabel.text = details.name
                workplaceContactLabel.text = details.contact
                workplaceAddressLabel.text = details.mainAddress
                workplaceManagerLabel.text = details.manager
                // workplaceMembersLabel
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavItem() {
        // navigationItem.title = "근무지 이름"
    }
    
    private func setupConstraints() {
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 8.0
        
        view.addSubview(contentStack)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(workplaceNameLabel)
        
        contentStack.addArrangedSubview(workplaceManagerLabel)
        
        contentStack.addArrangedSubview(contactLabel)
        contentStack.addArrangedSubview(workplaceContactLabel)
        
        contentStack.addArrangedSubview(addressLabel)
        contentStack.addArrangedSubview(workplaceAddressLabel)
        
        contentStack.addArrangedSubview(membersLabel)
        contentStack.addArrangedSubview(workplaceMembersLabel)
        
        contentStack.addArrangedSubview(joinWorkplaceButton)
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Constraint button heigth
            joinWorkplaceButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}
