//
//  ManagerHomeViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ManagerHomeViewModel {
    
    // MARK: - Internal Types
    
    typealias Item = ManagerHomeItem
    
    struct Input {
        let onLoad: Signal<()>
        let onRefresh: Signal<()>
        let showNotis: Signal<()>
        let showDetails: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let item: Driver<Item>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: HomeFlowCoordinator
    private let attendnaceUseCase: AttendanceUseCase
        
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: HomeFlowCoordinator,
            attendnaceUseCase: AttendanceUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.attendnaceUseCase = dependencies.attendnaceUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        let onLoad = Signal.merge(.just(()), input.onLoad, input.onRefresh)
        let requestList = onLoad.flatMapLatest { [weak self] _ -> Driver<[AttendanceRequest]> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.attendnaceUseCase
                .fetchAttendanceRequsetList2(date: Date.ext.now)
                .asDriver()
        }
        
        let status = requestList.map { requestList in
            let approvedCount = requestList
                .filter(\.isRequestApprove)
                .count
            let pendingCount = requestList
                .filter { (!$0.isRequestApprove && !$0.isManagerCheck) }
                .count
            return Item(leftCount: pendingCount, doneCount: approvedCount)
        }
        
        let listItem = requestList.map { $0.map(ManagerHomeListItem.init(attendanceRequest:)) }
            .map(Item.init(listItem: ))
       
        let item = Driver.merge(status, listItem)
        
        return Output(
            loading: loading,
            item: item
        )
    }
}
