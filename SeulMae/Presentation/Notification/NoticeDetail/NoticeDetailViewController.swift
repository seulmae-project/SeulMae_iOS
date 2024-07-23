//
//  NoticeDetailViewController.swift
//  SeulMae
//
//  Created by 조기열 on 7/23/24.
//

import UIKit

final class NoticeDetailViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: NoticeDetailViewModel) -> NoticeDetailViewController {
        let vc = NoticeDetailViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    // MARK: - UI
    
    private let _noticeKindLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    private let noticeKindSegment: UISegmentedControl = {
        let sg = UISegmentedControl()
        
        return sg
    }()
    
    private let _titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    private let _contentLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    private let contentLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    // MARK: - Dependencies
    
    private var viewModel: NoticeDetailViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onLayout()
    }
    
    func onLayout() {
        
    }
}
