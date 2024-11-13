//
//  ManagerHomeViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ManagerHomeViewController: BaseViewController {
    
    // MARK: - Internal Types

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, JoinApplication>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, JoinApplication>

    // MARK: - UI Properties
    private let notiRightBarButton = UIBarButtonItem(image: .bell, style: .plain, target: nil, action: nil)
    private lazy var scrollView = UIScrollView.ext
        .common(refreshControl: refreshControl)
    private let placeNameLabel = UILabel.ext
        .config(font: .pretendard(size: 14, weight: .regular), color: .ext.hex("4C71F5"))
    private let todayDateLabel = UILabel.ext
        .config(font: .pretendard(size: 20, weight: .medium))

    private let attPageControl = AttListPageControl()
    private let attPageViewController = AttListPageViewController()
    private let searchHistoryButton = UIButton.ext
        .common(title: "근무 이력 조회")

    private let appSectionTitleLabel = UILabel.ext
        .common("가입 승인 대기", font: .pretendard(size: 16, weight: .semibold))
    private let appSectionDescriptionLabel = UILabel.ext
        .common("직원이 가입승인을 기다리고 있어요!", font: .pretendard(size: 12, weight: .regular), textColor: .ext.hex("BCC7DD"))

    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    private var viewModel: ManagerHomeViewModel!
    private var pages = [UIViewController]()
    

    convenience init(viewModel: ManagerHomeViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ext.hex("F2F3F5")
        setupNavItem()
        configurePageView()
        configurePageControl()
        configureScrollView()
        configureHierarchy()
        setupDataSource()
        bindSubviews()
    }

    private func configurePageControl() {
        attPageControl.onChange = { [weak self] index in
            guard let self else { return }
            let viewController = self.pages[index]
            self.attPageViewController.setViewControllers([viewController], direction: (0 == index) ? .reverse : .forward, animated: true)
        }
    }

    private func configurePageView() {
        attPageViewController.delegate = self
        attPageViewController.dataSource = self
        let handledAtt = HandledAttListViewController()
        let uhAttListVC = UnhandledAttListViewController()
        // load view
        _ = handledAtt.view
        _ = uhAttListVC.view
        pages = [handledAtt, uhAttListVC]
        attPageViewController.setViewControllers([pages[0]], direction: .forward, animated: true)
    }

    // MARK: - Configure Hierarchy

    private func configureHierarchy() {
        addChild(attPageViewController)
        attPageViewController.didMove(toParent: self)
        let pageView = attPageViewController.view!

        let attStack = UIStackView()
        attStack.backgroundColor = .white
        attStack.axis = .vertical
        attStack.spacing = 4.0
        attStack.ext.round(radius: 12)
        attStack.directionalLayoutMargins = .ext.all(16)
        attStack.isLayoutMarginsRelativeArrangement = true
        [placeNameLabel, todayDateLabel, attPageControl, pageView, searchHistoryButton]
            .forEach(attStack.addArrangedSubview(_:))
        attStack.setCustomSpacing(0, after: attPageControl)

        collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true

        let applicationStack = UIStackView()
        applicationStack.backgroundColor = .white
        applicationStack.axis = .vertical
        applicationStack.spacing = 4.0
        applicationStack.ext.round(radius: 12)
        applicationStack.directionalLayoutMargins = .ext.all(16)
        applicationStack.isLayoutMarginsRelativeArrangement = true
        [appSectionTitleLabel, appSectionDescriptionLabel, collectionView]
            .forEach(applicationStack.addArrangedSubview(_:))

        let views = [attStack, applicationStack]
        views.forEach {
            scrollView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let insets = CGFloat(16)
        NSLayoutConstraint.activate([
            attStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * insets),
            attStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: insets),
            attStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -insets),
            attStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: insets),

            pageView.heightAnchor.constraint(equalTo: pageView.widthAnchor, multiplier: 0.75),

            applicationStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: insets),
            applicationStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -insets),
            applicationStack.topAnchor.constraint(equalTo: attStack.bottomAnchor, constant: insets),
            applicationStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -insets),

            collectionView.heightAnchor.constraint(equalToConstant: 116),
        ])
    }

    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Data Binding

    private func bindSubviews() {
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                onRefresh: onRefresh,
                showNotis: notiRightBarButton.rx.tap.asSignal(),
                showDetails: searchHistoryButton.rx.tap.asSignal()
            )
        )

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 M월 d일 EEEE"
        todayDateLabel.text = dateFormatter.string(from: .ext.now)

        output.workplaceInfo
            .map(\.name)
            .drive(placeNameLabel.rx.text)
            .disposed(by: disposeBag)

        output.attendanceInfoList
            .drive(with: self, onNext: { (self, item) in
                self.bindToPage(atts: item)
            })
            .disposed(by: disposeBag)

        output.joinApplicationList
            .drive(with: dataSource, onNext: { (dataSource, items) in
                print("items: \(items)")
                var snapshot = Snapshot()
                snapshot.appendSections([0])
                snapshot.appendItems(items)
                dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)

        output.loading
            .drive(loadingIndicator.ext.isAnimating)
            .disposed(by: disposeBag)
    }
    
    // MARK: - DataSource
    
    private func setupDataSource() {
        let applicationCellRegistration = makeApplicationCellRegistration()

        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) in
            return collectionView.dequeueConfiguredReusableCell(using: applicationCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    // MARK: - Cell Registration
    
    private func makeApplicationCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, JoinApplication> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, JoinApplication> { cell, indexPath, itemIdentifier in
            print(itemIdentifier.username)
            var content = JoinApplicationContentView.Configuration()
            content.application = itemIdentifier
            cell.contentConfiguration = content
            cell.backgroundConfiguration = .clear()
        }
    }

    // MARK: - Configure Nav

    private func setupNavItem() {
        let iconImageView: UIImageView = .common(image: .signinAppIcon)
        navigationItem.titleView = iconImageView
        navigationItem.rightBarButtonItem = notiRightBarButton
    }

    // MARK: - UICollectionViewLayout
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            return ManagerHomeViewController.createApplicationListSection()
        }
    }

    static func createApplicationListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .estimated(116))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8.0
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return section
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension ManagerHomeViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func bindToPage(atts: [Attendance]) {
        let handled = atts.filter(\.isManagerCheck)
        let unhandled = atts.filter { !$0.isManagerCheck }
        (pages[0] as? HandledAttListViewController)?.applySnapshot(handled)
        (pages[1] as? UnhandledAttListViewController)?.applySnapshot(unhandled)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first,
              let currentIndex = pages.firstIndex(of: viewController) else { return }
        attPageControl.currentPage = currentIndex
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        guard currentIndex > 0 else { return nil }
        let previousIndex = currentIndex - 1
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        guard currentIndex < (pages.count - 1) else { return nil }
        let nextIndex = currentIndex + 1
        return pages[nextIndex]
    }
}
