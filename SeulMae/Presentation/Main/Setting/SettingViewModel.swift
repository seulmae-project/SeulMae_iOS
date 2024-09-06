//
//  SettingViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel {
    struct Input {
        let showProfile: Signal<()>
    }
    
    struct Output {
        let item: Driver<SettingItem>
    }
    
    struct SettingItem {
        let username: String
        let phoneNumber: String
        // let version: String
    }
    // MARK: - Dependencies
    
    private let coordinator: MainFlowCoordinator
    private let userUseCase: UserUseCase
    
    // MARK: - Life Cycle Methods
    
    init(
        dependency: (
            coordinator: MainFlowCoordinator,
            userUseCase: UserUseCase
        )
    ) {
        self.coordinator = dependency.coordinator
        self.userUseCase = dependency.userUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        let item = userUseCase.fetchMyProfile()
        
        return .init(
            item: .empty()
        )
    }
}

