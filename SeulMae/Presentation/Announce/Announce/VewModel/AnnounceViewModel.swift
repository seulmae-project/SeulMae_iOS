//
//  AnnounceViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AnnounceViewModel: ViewModel {
    struct Input {
        let selectedItem: Signal<AnnounceItem>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let items: Driver<[AnnounceItem]>
    }
    
    private let coordinator: TabBarFlowCoordinator
    private let noticeUseCase: NoticeUseCase
    
    init(
        dependencies: (
            coordinator: TabBarFlowCoordinator,
            noticeUseCase: NoticeUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.noticeUseCase = dependencies.noticeUseCase
    }
    
    @MainActor
    func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let isLoading = indicator.asDriver()
        
        let items = Driver.just(["전체", "필독"])
            .map { $0.map(AnnounceItem.init(title:)) }
        
        Task {
            for await selected in input.selectedItem.values {
                Swift.print("Selected category: \(selected.title)")
            }
        }
        
        return Output(
            isLoading: isLoading,
            items: items
        )
    }
}

