//
//  WorkplaceDetailsViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkplaceDetailsViewModel: ViewModel {
    struct Input {
        let joinWorkplace: Signal<()>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let details: Driver<Workplace>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: MainFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    private let validationService: ValidationService
    private let wireframe: Wireframe
    private let workplaceID: Workplace.ID
    
    // MARK: - Life Cycle

    init(
        dependencies: (
            coordinator: MainFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase,
            validationService: ValidationService,
            wireframe: Wireframe,
            workplaceID: Workplace.ID
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workplaceUseCase = dependencies.workplaceUseCase
        self.validationService = dependencies.validationService
        self.wireframe = dependencies.wireframe
        self.workplaceID = dependencies.workplaceID
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let isLoading = indicator.asDriver()
        
        let onLoad = Driver.just(())
        
        let details = onLoad.flatMapLatest { [weak self] _ -> Driver<Workplace> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.workplaceUseCase
                .fetchWorkplaceDetail(workplaceID: strongSelf.workplaceID)
                .trackActivity(indicator)
                .asDriver()
        }
        
        let isJoined = input.joinWorkplace
            .flatMapLatest { [weak self] _ -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.workplaceUseCase
                    .submitApplication(workplaceID: strongSelf.workplaceID)
                    .trackActivity(indicator)
                    .asDriver()
                // TODO: - API Error 핸들링 필요
            }
        
        Task {
            for await isJoined in isJoined.values {
                Swift.print(#line, "isJoined: \(isJoined)")
            }
        }
        
        // MARK: Output
        
        return Output(
            isLoading: isLoading,
            details: details
        )
    }
}
