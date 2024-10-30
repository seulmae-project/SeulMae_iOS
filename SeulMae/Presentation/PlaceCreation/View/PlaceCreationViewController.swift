//
//  PlaceCreationViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI
import MapKit
import NMapsMap
import Then

final class PlaceCreationViewController: BaseViewController {

    private lazy var scrollView: UIScrollView = Ext.common(refreshControl: refreshControl)

    private var naverMapView = NMFNaverMapView().then {
        $0.showZoomControls = false
        $0.showLocationButton = false
        $0.mapView.positionMode = .disabled
        $0.mapView.isScrollGestureEnabled = false
        $0.mapView.isZoomGestureEnabled = false
        $0.mapView.isTiltGestureEnabled = false
        $0.mapView.isRotateGestureEnabled = false
        $0.mapView.zoomLevel = 16.0
    }

    private let phPickerViewController: PHPickerViewController = Ext.common()
    private let mainImageView: UIImageView = Ext.image(.store, width: 144, height: 144, cornerRadius: 72, bolderWidth: 8.0, bolderColor: .white)
    private let cameraIconImageView: UIImageView = Ext.image(.placeCreationCamera, width: 48, height: 48)

    private let nameInputFormView = TextInputFormView(title: "근무지 이름", placeholder: "상가명을 입력해주세요")
    private let contactInputFormView = TextInputFormView(title: "점포 연락처", placeholder: "점포 전화번호를 입력해주세요")
    private let addressInputFormView = AddressInputFormView()
    
    private let addNewButton: UIButton = .common(title: "생성하기")

    // MARK: - Properties

    private let addressRelay = PublishRelay<String>()
    private var markers = [NMFMarker]()
    // MARK: - Dependencies

    private var viewModel: PlaceCreationiewModel!

    // MARK: - Life Cycle Methods

    convenience init(viewModel: PlaceCreationiewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        
        configureNavItem()
        configureHierarchy()
        bindInternalSubviews()
    }

    // MARK: - Binding Data

    private func bindInternalSubviews() {
        // move to initial location
        let initialLocation = NMGLatLng(lat: 37.5665, lng: 126.9780)
        moveMapView(target: initialLocation)
        
        // handle taps evnets in main image view
        let tapGesture = UITapGestureRecognizer()
        mainImageView.addGestureRecognizer(tapGesture)
        mainImageView.isUserInteractionEnabled = true
        tapGesture.rx.event.asSignal()
            .withUnretained(self)
            .emit(onNext: { (self, _) in
                self.present(self.phPickerViewController, animated: true)
            })
            .disposed(by: disposeBag)

        // handle picked image
        let pickedImage = phPickerViewController.rx.picked.asDriver()
        pickedImage
            .drive(mainImageView.rx.image)
            .disposed(by: disposeBag)

        // handle recived location
        addressInputFormView.onChange = { [weak self] lat, lng, roadAdress in
            // move map view
            if let lat = Double(lat), let lng = Double(lng) { self?.moveMapView(lat: lat, lng: lng)
            }
            // send address to view model
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

        output.loading.drive(loadingIndicator.ext.isAnimating)
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

        let views = [naverMapView, mainImageView, contentStack, cameraIconImageView]
        views.forEach {
            scrollView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    
            naverMapView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            naverMapView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            naverMapView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            naverMapView.heightAnchor.constraint(equalToConstant: 300),

            mainImageView.topAnchor.constraint(equalTo: naverMapView.bottomAnchor, constant: -76),
            mainImageView.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),

            cameraIconImageView.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -8.0),
            cameraIconImageView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -8.0),

            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: view.widthAnchor),

            addNewButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }

    // MARK: - Private Map Methods

    private func moveMapView(lat: Double, lng: Double) {
        let searchedLocation = NMGLatLng(lat: lat, lng: lng)
        moveMapView(target: searchedLocation)
        updateMarker(target: searchedLocation)
    }

    private func moveMapView(target: NMGLatLng) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: target).then {
            $0.animation = .easeIn
        }

        DispatchQueue.main.async { [weak self] in
            self?.naverMapView.mapView.moveCamera(cameraUpdate)
        }
    }

    private func updateMarker(target: NMGLatLng, caption: String = "") {
        deleteAllMarker()
        let marker = NMFMarker(position: target).then {
            $0.captionText = caption
            $0.iconImage = NMFOverlayImage(image: .placeCreationMapMarker)
        }

        marker.isHideCollidedSymbols = true
        markers.append(marker)
        DispatchQueue.main.async {
            marker.mapView = self.naverMapView.mapView
        }
    }

    private func deleteAllMarker() {
        markers.forEach { $0.mapView = nil }
    }
}
