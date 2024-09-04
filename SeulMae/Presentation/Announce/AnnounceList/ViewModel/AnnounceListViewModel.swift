//
//  AnnounceViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AnnounceListViewModel: ViewModel {
    struct Input {
        let showAnnounceDetails: Signal<AnnounceListItem>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let items: Driver<[AnnounceListItem]>
    }
    
    private let coordinator: MainFlowCoordinator
    private let noticeUseCase: NoticeUseCase
    
    init(
        coordinator: MainFlowCoordinator,
        noticeUseCase: NoticeUseCase
    ) {
        self.coordinator = coordinator
        self.noticeUseCase = noticeUseCase
    }
    
    @MainActor
    func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let isLoading = indicator.asDriver()
        
        let items = noticeUseCase.fetchAnnounceList(page: 0, size: 30)
            .map { $0.map(AnnounceListItem.init(announce:)) }
            .asDriver()
        
        
        Task {
            for await item in input.showAnnounceDetails.values {
                coordinator.showAnnounceDetail(announceId: item.announce.id)
            }
        }
        
        return Output(
            isLoading: isLoading,
            items: items
        )
    }
}
