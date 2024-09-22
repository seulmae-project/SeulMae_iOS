//
//  AttendanceViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/19/24.
//

import UIKit

final class AttendanceViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let label3: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let label4: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView()
        
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func bindSubviews() {
        
    }
    
    private func setupView() {
        let leftLabelVStack = UIStackView(arrangedSubviews: [
            label, label2
        ])
        leftLabelVStack.axis = .vertical
        leftLabelVStack.spacing = 4.0
        
        let rightLabelVStack = UIStackView(arrangedSubviews: [
            label3, label4
        ])
        rightLabelVStack.axis = .vertical
        rightLabelVStack.spacing = 4.0
        
        let labelHStack = UIStackView(arrangedSubviews: [
            leftLabelVStack, rightLabelVStack
        ])
        labelHStack.distribution = .equalCentering
        
        progressView.progressTintColor = .primary
        progressView.trackTintColor = .systemBackground
        
        let contentStack = UIStackView(arrangedSubviews: [
            labelHStack, progressView
        ])
        contentStack.axis = .vertical
        contentStack.spacing = 8.0

        view.addSubview(contentStack)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
