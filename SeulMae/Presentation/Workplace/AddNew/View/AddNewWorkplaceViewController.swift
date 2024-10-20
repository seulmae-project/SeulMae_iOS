//
//  AddNewWorkplaceViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI
import MapKit

final class AddNewWorkplaceViewController: BaseViewController {

    private let refreshControl = UIRefreshControl()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        let insets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        scrollView.directionalLayoutMargins = insets
        return scrollView
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.isUserInteractionEnabled = false
        return mapView
    }()

    private let phPickerViewController: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        return pickerViewController
    }()

    private let mainImageView: UIImageView = {
        let imageView = UIImageView.common(image: .store)
        imageView.layer.cornerRadius = 72
        imageView.layer.cornerCurve = .continuous
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 8.0
        imageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(hexCode: "EEEEEE")
        return imageView
    }()

    private let nameInputFormView = TextInputFormView(title: "근무지 이름", placeholder: "상가명을 입력해주세요")
    private let contactInputFormView = TextInputFormView(title: "점포 연락처", placeholder: "점포 전화번호를 입력해주세요")
    private let addressInputFormView = AddressInputFormView()
    
    private let addNewButton: UIButton = .common(title: "생성하기")

    // MARK: - Properties

    private let addressRelay = PublishRelay<String>()

    // MARK: - Dependencies

    private var viewModel: AddNewWorkplaceViewModel

    // MARK: - Life Cycle Methods

    init(viewModel: AddNewWorkplaceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configureNavItem()
        configureHierarchy()
        bindInternalSubviews()
        moveMapView(title: "구미시", lat: 36.119485, lng: 128.3445734)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Binding Data

    private func bindInternalSubviews() {
        let tapGesture = UITapGestureRecognizer()
        mainImageView.addGestureRecognizer(tapGesture)
        mainImageView.isUserInteractionEnabled = true
        tapGesture.rx.event.asSignal()
            .withUnretained(self)
            .emit(onNext: { (self, _) in
                self.present(self.phPickerViewController, animated: true)
            })
            .disposed(by: disposeBag)

        let pickedImage = phPickerViewController.rx.picked.asDriver()
        pickedImage
            .drive(mainImageView.rx.image)
            .disposed(by: disposeBag)

        addressInputFormView.onChange = { [weak self] lat, lng, roadAdress in
            self?.moveMapView(lat: Double(lat)!, lng: Double(lng)!)
            self?.addressRelay.accept(roadAdress)
        }

        let output = viewModel.transform(
            .init(
                image: pickedImage,
                name: nameInputFormView.textField.rx.text.orEmpty.asDriver(),
                contact: contactInputFormView.textField.rx.text.orEmpty.asDriver(),
                address: addressRelay.asDriver(),
                subAddress: addressInputFormView.subAddresssTextField.rx.text.orEmpty.asDriver(),
                onCreate: addNewButton.rx.tap.asSignal()
            )
        )

        output.createEnabled
            .drive(with: self, onNext: { (self, isEnabled) in
                self.addNewButton.ext.setEnabled(isEnabled)
            })
            .disposed(by: disposeBag)

        output.validationResult
            .drive(with: self, onNext: { (self, result) in
                switch result {
                case let .name(result):
                    self.nameInputFormView.validationResultsLabel.ext.setResult(result)
                case let .contact(result):
                    self.contactInputFormView.validationResultsLabel.ext.setResult(result)
                case let .address(result):
                    self.addressInputFormView.subAddressValidationResultsLabel.ext.setResult(result)
                }
            })
            .disposed(by: disposeBag)

        output.loading
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }

    private func configureNavItem() {
        navigationItem.title = "새 근무지 등록"
    }

    // MARK: - Configure Hierarchy

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 20
        let margins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        contentStack.directionalLayoutMargins = margins
        contentStack.isLayoutMarginsRelativeArrangement = true

        [addressInputFormView, nameInputFormView, contactInputFormView, addNewButton]
            .forEach(contentStack.addArrangedSubview(_:))

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [mapView, mainImageView, contentStack]
        views.forEach {
            scrollView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    
            mapView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 300),

            mainImageView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -76),
            mainImageView.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            mainImageView.widthAnchor.constraint(equalToConstant: 144),
            mainImageView.heightAnchor.constraint(equalToConstant: 144),

            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: view.widthAnchor),

            addNewButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }

    // MARK: - Private Map Methods

    private func moveMapView(title: String = "", lat: Double, lng: Double) {
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
}
