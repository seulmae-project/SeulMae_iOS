//
//  SettingViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel: ViewModel {
    struct Input {
        let showProfile: Signal<()>
        let selectedItem: Driver<SettingListItem>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let item: Driver<SettingItem>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: SettingFlowCoordinator
    private let userUseCase: UserUseCase
    
    // MARK: - Life Cycle Methods
    
    init(
        dependencies: (
            coordinator: SettingFlowCoordinator,
            userUseCase: UserUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.userUseCase = dependencies.userUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        let item = userUseCase.fetchMyProfile()
            .trackActivity(indicator)
            .map(SettingItem.init(user:))
            .asDriver()
        
        Task {
            for await _ in input.showProfile.values {
                Swift.print("Did selected setting view showProfileButton)")
            }
        }
        
        Task {
            for await selected in input.selectedItem.values {
                Swift.print("Did selected setting tab collection view item: \(selected.title)")
            }
        }
        
        return .init(
            loading: loading,
            item: item
        )
    }
}

