//
//  AddNewWorkplaceViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 8/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AddNewWorkplaceViewModel: ViewModel {
    struct Input {
        let mainImage: Driver<Data>
        let name: Driver<String>
        let contact: Driver<String>
        let address: Driver<String>
        let addNew: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let validatedName: Driver<ValidationResult>
        let validatedContact: Driver<ValidationResult>
        let validatedAdress: Driver<ValidationResult>
        let AddNewEnabled: Driver<Bool>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: MainFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    private let validationService: ValidationService
    private let wireframe: Wireframe
    
    // MARK: - Life Cycle

    init(
        dependencies: (
            coordinator: MainFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase,
            validationService: ValidationService,
            wireframe: Wireframe
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workplaceUseCase = dependencies.workplaceUseCase
        self.validationService = dependencies.validationService
        self.wireframe = dependencies.wireframe
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        

        
        // MARK: Output
        
        return Output(
            loading: .empty(),
            validatedName: .empty(),
            validatedContact: .empty(),
            validatedAdress: .empty(),
            AddNewEnabled: .empty()
        )
    }
}
