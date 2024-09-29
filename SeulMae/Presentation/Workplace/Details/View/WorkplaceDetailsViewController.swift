//
//  WorkplaceDetailsViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/14/24.
//

import UIKit
import MapKit

final class WorkplaceDetailsViewController: BaseViewController {
    
    // MARK: - UI
    
    private let refreshControl = UIRefreshControl()
   
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        let inset = CGFloat(20)
        scrollView.directionalLayoutMargins = .init(top: 0, leading: inset, bottom: 0, trailing: inset)
        return scrollView
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.isUserInteractionEnabled = false
        return mapView
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 125
        imageView.layer.cornerCurve = .continuous
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 8.0
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowRadius = 7.0
        imageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(hexCode: "EEEEEE")
        return imageView
    }()
    
    private let _nameLabel: UILabel = .callout(title: "근무지")
    private let nameLabel: UILabel = .callout(title: "")
    
    private let workplaceManagerLabel: UILabel = .callout(title: "매니저")
    
    private let _contactLabel: UILabel = .callout(title: "연락처")
    private let contactLabel: UILabel = .callout(title: "연락처")

    private let _addressLabel: UILabel = .callout(title: "주소")
    private let addressLabel: UILabel = .footnote(title: "주소")
    
    private let _membersCountLabel: UILabel = .callout(title: "참여인원")
    private let membersCountLabel: UILabel = .footnote(title: "-명")
    
    private let joinWorkplaceButton: UIButton = .common(title: "입장하기")
    
    // MARK: - Properties
 
    private var viewModel: WorkplaceDetailsViewModel
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: WorkplaceDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        bindSubviews()
    }
    
    private func bindSubviews() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                joinWorkplace: joinWorkplaceButton.rx.tap.asSignal()
            )
        )
        
        // handle loading
        Task {
            for await loading in output.loading.values {
                loadingIndicator.ext.isAnimating(loading)
            }
        }
        
        // Handle workplace details information
        Task {
            for await item in output.item.values {
                if let imageURL = URL(string: item.imageUrl) {
                    mainImageView.kf.setImage(
                        with: imageURL,
                        options: [
                           .onFailureImage(UIImage()),
                           .cacheOriginalImage
                       ])
                }
                nameLabel.ext.setText(item.name)
                contactLabel.ext.setText(item.contact)
                addressLabel.ext.setText(item.address)
                workplaceManagerLabel.ext.setText(item.manager)
                navigationItem.title = item.name
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 8.0
        let views = [
            _nameLabel,
            nameLabel,
            _contactLabel,
            contactLabel,
            _addressLabel,
            addressLabel,
            _membersCountLabel,
            membersCountLabel,
            joinWorkplaceButton
        ]
        views.forEach(contentStack.addArrangedSubview(_:))
        
        view.addSubview(scrollView)
            
        scrollView.addSubview(mapView)
        scrollView.addSubview(mainImageView)
        scrollView.addSubview(contentStack)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // scrollView
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    
            // mapView
            mapView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 300),
            
            // mainImageView
            mainImageView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -130),
            mainImageView.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            mainImageView.widthAnchor.constraint(equalToConstant: 250),
            mainImageView.heightAnchor.constraint(equalToConstant: 250),
            
            // contentStack
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            contentStack.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 20),
            contentStack.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // Constraint buttons height
            joinWorkplaceButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}
