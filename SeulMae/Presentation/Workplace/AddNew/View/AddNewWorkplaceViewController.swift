//
//  AddNewWorkplaceViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/13/24.
//

import UIKit
import PhotosUI
import MapKit

final class AddNewWorkplaceViewController: UIViewController {
    
    private let phPickerViewController: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        return pickerViewController
    }()
    
    // .frame(height: 300)
    private let mapView: MKMapView = {
        let mapView = MKMapView()
//        let centerLocation = CLLocationCoordinate2D(latitude: locationStruct.latitude, longitude: locationStruct.longtitude)
//        let region = MKCoordinateRegion(center: centerLocation, latitudinalMeters: 100, longitudinalMeters: 100)
//        let annotation = MKPointAnnotation()
//        annotation.title = locationStruct.name
//        annotation.coordinate = centerLocation
//        mapView.addAnnotation(annotation)
//        mapView.setRegion(region, animated: true)
        return mapView
    }()

//        .padding(.bottom, -130)
    private let workplaceMainImageView: UIImageView = {
        let imageView = UIImageView()
//        let circularPath = UIBezierPath(roundedRect: bounds.insetBy(dx: 5, dy: 5), cornerRadius: bounds.height / 2)
//        let layer = CAShapeLayer()
//        layer.path = circularPath.cgPath
//        layer.fillColor = UIColor.clear.cgColor
//        layer.strokeColor = UIColor.white.cgColor
//        layer.lineWidth = 4
        // myView.layer.mask = borderLayer
        return imageView
    }()
    
    private let nameLabel: UILabel = .callout(title: "이름")
    private let nameTextField: UITextField = .common(placeholder: "근무지 이름 입력")
    private let nameValidationResultLabel: UILabel = .footnote()
    
    private let contactLabel: UILabel = .callout(title: "연락처")
    private let contactTextField: UITextField = .common(placeholder: "근무지 이름 입력")
    private let contactValidationResultLabel: UILabel = .footnote()
    
    private let addressLabel: UILabel = .callout(title: "주소 등록을 위해, 아래에서 주소를 검색해 주세요")
    private let searchAdressButton: UIButton = .common(title: "주소 검색")

    private let addresssTextField: UITextField =  .common(placeholder: "근무지 주소 입력")
    private let addressValidationResultLabel: UILabel = .footnote()
    
    private let addNewButton = UIButton()
 
    private var viewModel: AddNewWorkplaceViewModel
    
    init(viewModel: AddNewWorkplaceViewModel) {
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
        let pickedImage = phPickerViewController.rx.picked.asSignal()
        // Handle picked image
        Task {
            for await image in pickedImage.values {
                workplaceMainImageView.image = image
            }
        }
        
        let output = viewModel.transform(
            .init(
                mainImage: pickedImage.map { $0.jpegData(compressionQuality: 0.75) ?? Data() },
                name: nameTextField.rx.text.orEmpty.asDriver(),
                contact: contactTextField.rx.text.orEmpty.asDriver(),
                address: addresssTextField.rx.text.orEmpty.asDriver(),
                searchAddress: searchAdressButton.rx.tap.asSignal(),
                addNew: addNewButton.rx.tap.asSignal()
            )
        )
        // Handle Button enabled
        Task {
            for await isEnabled in output.AddNewEnabled.values {
                addNewButton.ext.setEnabled(isEnabled)
            }
        }
        // Handle validation results
        Task {
            for await result in output.validationResult.values {
                switch result {
                case let .name(result):
                    nameValidationResultLabel.ext.setResult(result)
                case let .contact(result):
                    contactValidationResultLabel.ext.setResult(result)
                case let .address(result):
                    addressValidationResultLabel.ext.setResult(result)
                }
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavItem() {
        navigationItem.title = "새 근무지 등록"
    }
    
    private func setupConstraints() {
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 8.0
        
        view.addSubview(contentStack)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(nameTextField)
        contentStack.addArrangedSubview(nameValidationResultLabel)

        contentStack.addArrangedSubview(contactLabel)
        contentStack.addArrangedSubview(contactTextField)
        contentStack.addArrangedSubview(contactValidationResultLabel)

        contentStack.addArrangedSubview(addressLabel)
        contentStack.addArrangedSubview(searchAdressButton)
        contentStack.addArrangedSubview(addresssTextField)
        contentStack.addArrangedSubview(addressValidationResultLabel)

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Constarint validation result message
            nameValidationResultLabel.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            nameValidationResultLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8.0),
            contactValidationResultLabel.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            contactValidationResultLabel.topAnchor.constraint(equalTo: contactTextField.bottomAnchor, constant: 8.0),
            addressValidationResultLabel.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            addressValidationResultLabel.topAnchor.constraint(equalTo: addresssTextField.bottomAnchor, constant: 8.0),
            
            // Constraint buttons height
            searchAdressButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Constraint textFields height
            nameTextField.heightAnchor.constraint(equalToConstant: 48),
            contactTextField.heightAnchor.constraint(equalToConstant: 48),
            addresssTextField.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}
