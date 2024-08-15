//
//  SliderView.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import UIKit

// MARK: - Configuration

public struct SliderConfiguration {
    var contentProperties: ContentProperties = ContentProperties()
    var timeProperties: TimerProperties = TimerProperties()
    var draggingEnabled: Bool = true
    
    public enum ImagePreloadKind {
        case all
        case fixed(offset: Int)
    }
    
    public struct ContentProperties {
        var zoomEnabled: Bool = false
        var maxZoomScale: CGFloat = 2.0
        var minZoomScale: CGFloat = 1.0
        var contentMode: UIView.ContentMode = .scaleAspectFit
        var preloadKind: ImagePreloadKind = .all
    }
    
    public struct TimerProperties {
        public var timeInterval: TimeInterval = 0
    }
}

final class SliderView<Item>: UIView, UIScrollViewDelegate, Sendable {

    // MARK: - Properties
    
    let scrollView: UIScrollView = UIScrollView()
    
    var pageControl: PageControl? {
        didSet {
            oldValue?.removeFromSuperview()
            if let pageControl {
                addSubview(pageControl)
                if let _pageControl = pageControl as? UIControl {
                    _pageControl.addTarget(
                        self,
                        action: #selector(didPageControlValueChanged),
                        for: .valueChanged
                    )
                }
            }
            setNeedsLayout()
        }
    }
    
    var items: [Item] = [] {
        didSet {
            loadContentViews()
            setNeedsLayout()
        }
    }
    
    var onItemTap: ((Item) -> Void)?
    
    var timer: Timer?
    
    var configuration = SliderConfiguration()
    
    var frameCalculator = FrameCalculator() {
        didSet {
            setNeedsLayout()
        }
    }
    
    var itemSize: Double?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    // MARK: - Hierarchy
    
    private func initialSetup() {
        configureHierarchy()
        print("view frame: \(frame.size) ")
        print("scroll view frame: \(scrollView.frame.size)")
        setTimerIfNeeded()
    
    }
    
    func configureHierarchy() {
        autoresizesSubviews = true
        clipsToBounds = true
        
        let pageControlInset: CGFloat = 50
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - pageControlInset)
      
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.autoresizingMask = autoresizingMask
        scrollView.contentInsetAdjustmentBehavior = .never
        // scrollView.isUserInteractionEnabled = configuration.draggingEnabled
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            scrollView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        addSubview(scrollView)

        if pageControl == nil {
            pageControl = UIPageControl()
        }
        pageControl?.numberOfPages = items.count
        // items 가 비어있으면 hide 하도록
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutPageControl()
        layoutScrollView()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        removeTimer()
    }
    
    private func layoutPageControl() {
        guard let pageControl else { return }
        print("🐹 pageControl.numberOfPages: \(pageControl.numberOfPages)")
        pageControl.numberOfPages = items.count
        print("🐹 pageControl.numberOfPages: \(pageControl.numberOfPages)")
        pageControl.isHidden = items.count < 2
        pageControl.sizeToFit()
        pageControl.frame = frameCalculator.caculate(
            from: frame,
            viewSize: pageControl.frame.size,
            edgeInsets: safeAreaInsets
        )
        Swift.print(#function, #fileID, "pageControlFrame: \(pageControl.frame)")
    }
    
    private func layoutScrollView() {
        print("view frame: \(frame.size) ")
        print("scroll view frame: \(scrollView.frame.size)")
        let bottomInset = (pageControl?.frame.size)
            .map { frameCalculator.underPadding(for: $0) } ?? 0
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - bottomInset)
        let width = itemSize ?? scrollView.frame.width
            scrollView.contentSize = CGSize(width: width * CGFloat(items.count), height: scrollView.frame.height)
        layoutContentViews(itemSize: itemSize)
        
        moveTo(pageIndex: 0, animated: false)
    }
    
    private func layoutContentViews(itemSize: Double? = nil) {
        if let contentViews = items as? [UIView] {
            
            Swift.print(#function, #fileID, "items count: \(items)")
            for (index, view) in contentViews.enumerated() {
                let width = itemSize ?? scrollView.frame.width
                view.frame = CGRect(
                    x: width * CGFloat(index),
                    y: 0,
                    width: width,
                    height: scrollView.frame.height
                )
            }
        }
    }
    
    // MARK: - Timer
    
    private func setTimerIfNeeded() {
        guard configuration.timeProperties.timeInterval > 0,
              items.count > 1,
              timer == nil else { return }
        timer = createTimer(with: configuration.timeProperties)
    }
    
    private func createTimer(with properties: SliderConfiguration.TimerProperties) -> Timer {
        return Timer.scheduledTimer(
            timeInterval: properties.timeInterval,
            target: self,
            selector: #selector(timerFireMethod(_:)),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func timerFireMethod(_ timer: Timer) {
        //        var nextPage = scrollView.ext.pageIndex + 1
        //        if nextPage == sources.count { nextPage = 0 }
        //        moveTo(pageIndex: nextPage, animated: true)
    }
    
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Content Load & ReLoad
    
    @objc
    func onItemTapped(_ sender: UITapGestureRecognizer) {
        if let item = sender.view as? Item {
            onItemTap?(item)
        }
    }
    
    func loadContentViews() {
        // item
        
        // onTap?
        // rx로 바꾸기 쉬워야 함
        // item,
        // view -> configuration 들어 있음
        // contentConfiguration
        // Item 자체에 탭을 달 경우 -> view에 들어간 아이템은 뭐로 식별?
        // item.type
//        print("view frame: \(frame.size) ")
//        print("scroll view frame: \(scrollView.frame.size)")
//        // ContentConfiguration
        for item in items {
            if let view = item as? UIView {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onItemTapped(_:)))
                view.addGestureRecognizer(tapGesture)
                scrollView.addSubview(view)
                // dispose 하는 거 만들기..?
                // view.removeGestureRecognizer(tapGesture)
            }
            
            //            let contentView = SliderContentView(
            //                source: source,
            //                activityIndicator: activityIndicator,
            //                properties: configuration.contentProperties
            //            )
            //            sliderContentViews.append(contentView)
            //            scrollView.addSubview(contentView)
        }
        
//        print("view frame: \(frame.size) ")
//        print("scroll view frame: \(scrollView.frame.size)")
    }
    
    func reloadContentViews() {
        //        sliderContentViews.forEach { $0.removeFromSuperview() }
        //        sliderContentViews.removeAll()
        //        loadContentViews()
        //        moveTo(pageIndex: 0, animated: false)
    }
    
    private func loadContentView(pageIndex index: Int) {
        //        let total = sliderContentViews.count
        //
        //        for i in 0..<total {
        //            let contentView = sliderContentViews[i]
        //            switch configuration.contentProperties.preloadKind {
        //            case .all:
        //                contentView.loadImage()
        //            case .fixed(let offset):
        //                let shouldLoad = (abs(i - index) <= offset) || (abs(index - i) >= total - offset)
        //                shouldLoad ? contentView.loadImage() : contentView.clearImage()
        //            }
        //        }
    }
    
    // MARK: - PageControl
    
    @objc private func didPageControlValueChanged() {
        if let pageIndex = pageControl?.currentPage {
            moveTo(pageIndex: pageIndex, animated: true)
        }
    }
    
    private func moveTo(pageIndex index: Int, animated: Bool = true) {
        print("view frame: \(frame.size) ")
        print("scroll view frame: \(scrollView.frame.size)")
        let page = max(index, 0) + 1
        if page <= items.count {
            let visibleSize = scrollView.frame.size
            let visibleRect = CGRect(
                x: visibleSize.width * CGFloat(page),
                y: 0,
                width: visibleSize.width,
                height: visibleSize.height
            )
            scrollView.scrollRectToVisible(visibleRect, animated: animated)
            // loadContentView(pageIndex: index)
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
    
}


extension SliderView {
    
}
