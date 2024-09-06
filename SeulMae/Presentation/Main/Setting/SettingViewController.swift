//
//  SettingViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/5/24.
//

import UIKit

final class SettingViewController: UIViewController {
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 48
        imageView.layer.cornerCurve = .continuous
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let showProfileButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .pretendard(size: 20, weight: .semibold)
        // button.setImage(, for: )
        return button
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weight: .regular)
        label.text = "전화번호"
        return label
    }()
    
    private let phoneNumberOutlet: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weight: .semibold)
        return label
    }()
    
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weight: .regular)
        label.text = "생년월일"
        return label
    }()
    
    private let birthdayOutlet: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weight: .semibold)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavItem()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        let phoneNumberStack = UIStackView()
        phoneNumberStack.distribution = .equalCentering
        phoneNumberStack.addArrangedSubview(phoneNumberLabel)
        phoneNumberStack.addArrangedSubview(phoneNumberOutlet)
        
        let birthdayStack = UIStackView()
        birthdayStack.distribution = .equalCentering
        birthdayStack.addArrangedSubview(birthdayLabel)
        birthdayStack.addArrangedSubview(birthdayOutlet)
        
        let userInfoStack = UIStackView()
        userInfoStack.spacing = 8.0
        userInfoStack.axis = .vertical
        userInfoStack.directionalLayoutMargins = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
        userInfoStack.isLayoutMarginsRelativeArrangement = true
        userInfoStack.addArrangedSubview(phoneNumberStack)
        userInfoStack.addArrangedSubview(birthdayStack)
        
        let contentStack = UIStackView()
        contentStack.spacing = 20
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.addArrangedSubview(userImageView)
        contentStack.addArrangedSubview(showProfileButton)
        contentStack.addArrangedSubview(userInfoStack)
        
        view.addSubview(contentStack)
        view.addSubview(collectionView)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentStack.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
            userImageView.heightAnchor.constraint(equalToConstant: 96),
            userImageView.widthAnchor.constraint(equalToConstant: 96),
        ])
    }
    
    private func setupNavItem() {
        navigationItem.title = "설정"
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout()
    }
}
