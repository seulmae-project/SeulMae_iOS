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
    
    enum ViewState {
        case initial
        case detailAdress
    }
    
    private let phPickerViewController: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        return pickerViewController
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.isUserInteractionEnabled = false
        return mapView
    }()

    private let mainImageView: UIImageView = {
        // TODO: - 기본 이미지 그림자 추가해야함
        let imageView = UIImageView()
        let rect = CGRect(x: 0, y: 0, width: 250, height: 250)
        let circularPath = UIBezierPath(ovalIn: rect)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = circularPath.cgPath
        imageView.layer.mask = maskLayer
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = circularPath.cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        shadowLayer.strokeColor = UIColor.clear.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 3)
        shadowLayer.shadowRadius = 7.0
        shadowLayer.shadowOpacity = 0.5
        imageView.layer.addSublayer(shadowLayer)
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = circularPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineWidth = 8.0
        imageView.layer.addSublayer(borderLayer)

        imageView.contentMode = .scaleAspectFill
        imageView.image = .empty
        return imageView
    }()
    
    private let scrollView = UIScrollView()
    
    private let nameLabel: UILabel = .headline(title: "이름")
    private let nameTextField: UITextField = .common(placeholder: "근무지 이름 입력")
    private let nameValidationResultLabel: UILabel = .footnote()
    
    private let contactLabel: UILabel = .headline(title: "연락처")
    private let contactTextField: UITextField = .common(placeholder: "근무지 연락처 입력")
    private let contactValidationResultLabel: UILabel = .footnote()
    
    private let addressLabel: UILabel = .headline(title: "주소 등록을 위해, 아래에서 주소를 검색해 주세요")
    private let searchedAddressLabel: UILabel = .body()
    private let searchAddressButton: UIButton = .common(title: "주소 검색")
    private let resesarchAddressButton: UIButton = .callout(title: "재검색")
    
    private let detailAddressLabel: UILabel = .headline(title: "상세 주소")
    private let detailAddresssTextField: UITextField =  .common(placeholder: "상세 주소(건물명 / 호)")
    private let detailAddressValidationResultLabel: UILabel = .footnote()
    
    private let addNewButton: UIButton = .common(title: "생성하기")
 
    private var viewModel: AddNewWorkplaceViewModel
    
    init(viewModel: AddNewWorkplaceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        setupNavItem()
        setupConstraints()
        bindSubviews()
        moveMapView(title: "구미시", lat: 36.119485, lng: 128.3445734)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindSubviews() {
        let pickedImage = phPickerViewController.rx.picked.asSignal()
        // Handle picked image
        Task {
            for await image in pickedImage.values {
                mainImageView.image = image
            }
        }
        
        let output = viewModel.transform(
            .init(
                mainImage: pickedImage.map { $0.jpegData(compressionQuality: 0.75) ?? Data() },
                name: nameTextField.rx.text.orEmpty.asDriver(),
                contact: contactTextField.rx.text.orEmpty.asDriver(),
                detailAddress: detailAddresssTextField.rx.text.orEmpty.asDriver(),
                searchAddress: searchAddressButton.rx.tap.asSignal(),
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
                    detailAddressValidationResultLabel.ext.setResult(result)
                }
            }
        }
        
        Task {
            for await state in output.viewState.values {
                Swift.print(#line, "viewState: \(state)")
                switch state {
                case .initial:
                    // 주소를 검색하기 전
                    addressLabel.text = "주소 등록을 위해, 아래에서 주소를 검색해 주세요"
                    searchAddressButton.isHidden = true
                    searchAddressButton.isHidden = false
                    resesarchAddressButton.isHidden = true
                    detailAddressLabel.isHidden = true
                    detailAddresssTextField.isHidden = true
                    detailAddressValidationResultLabel.isHidden = true
                    // TODO: 나중에 하나로 합치기..
                case .detailAdress:
                    // 주소가 있는 경우
                    addressLabel.text = "주소"
                    searchAddressButton.isHidden = false
                    searchAddressButton.isHidden = true
                    resesarchAddressButton.isHidden = false
                    detailAddressLabel.isHidden = false
                    detailAddresssTextField.isHidden = false
                    detailAddressValidationResultLabel.isHidden = false
                }
            }
        }
        
        
        // Handle Button enabled
        Task {
            for await data in output.data.values {
                Swift.print(#line, "searched: \(data)")
                if let lat = data["kakaoLat"] as? String,
                   let lng = data["kakaoLng"] as? String {
                    moveMapView(lat: Double(lat)!, lng: Double(lng)!)
                } else {
                    Swift.print(#function)
                }
                let address = data["address"] as? String
                searchedAddressLabel.text = address
            }
        }
    }
    
    func moveMapView(title: String = "", lat: Double, lng: Double) {
        Swift.print(#function)
        // Remove existing annotations
        let existing = mapView.annotations
        mapView.removeAnnotations(existing)
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let center = CLLocationCoordinate2D(latitude: lat - (25 / 111_000), longitude: lng)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 100, longitudinalMeters: 100)
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
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
        
        scrollView.showsVerticalScrollIndicator = false

        view.addSubview(scrollView)
            
        scrollView.addSubview(mapView)
        scrollView.addSubview(mainImageView)
        scrollView.addSubview(contentStack)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(nameTextField)
        contentStack.addArrangedSubview(nameValidationResultLabel)

        contentStack.addArrangedSubview(contactLabel)
        contentStack.addArrangedSubview(contactTextField)
        contentStack.addArrangedSubview(contactValidationResultLabel)

        contentStack.addArrangedSubview(addressLabel) //
        contentStack.addArrangedSubview(searchedAddressLabel) // h
        contentStack.addArrangedSubview(searchAddressButton) //
        contentStack.addArrangedSubview(resesarchAddressButton) // h
        contentStack.addArrangedSubview(detailAddressLabel) // h
        contentStack.addArrangedSubview(detailAddresssTextField) // h
        contentStack.addArrangedSubview(detailAddressValidationResultLabel) // h
        contentStack.addArrangedSubview(addNewButton) //

        // contentStack.setCustomSpacing(16, after: addressLabel)
        // contentStack.setCustomSpacing(16, after: searchAddressButton)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    
            mapView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 300),
            
            mainImageView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -130),
            mainImageView.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            mainImageView.widthAnchor.constraint(equalToConstant: 250),
            mainImageView.heightAnchor.constraint(equalToConstant: 250),
            
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            contentStack.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 20),
            contentStack.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // Constarint validation result message
            nameValidationResultLabel.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            nameValidationResultLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8.0),
            contactValidationResultLabel.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            contactValidationResultLabel.topAnchor.constraint(equalTo: contactTextField.bottomAnchor, constant: 8.0),
            detailAddressValidationResultLabel.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            detailAddressValidationResultLabel.topAnchor.constraint(equalTo: detailAddresssTextField.bottomAnchor, constant: 8.0),
            
            // Constraint buttons height
            searchAddressButton.heightAnchor.constraint(equalToConstant: 56),
            addNewButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Constraint textFields height
            nameTextField.heightAnchor.constraint(equalToConstant: 48),
            contactTextField.heightAnchor.constraint(equalToConstant: 48),
            detailAddresssTextField.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}
