//
//  SearchWorkplaceViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation

import Foundation
import RxSwift
import RxCocoa

final class SearchPlaceViewModel: ViewModel {
    struct Input {
        var query: Driver<String>
        var onSearch: Signal<()>
        var onTap: Signal<()>
        var addNewPlace: Signal<()>
    }
    
    struct Output {
       
    }
    
    // MARK: - Dependency
    
    private let coordinator: AuthFlowCoordinator
    
    private let authUseCase: AuthUseCase
    
    private let validationService: ValidationService
    
    private let wireframe: Wireframe

    
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            validationService: ValidationService,
            wireframe: Wireframe
        )
    ) {
        self.coordinator = dependency.coordinator
        self.authUseCase = dependency.authUseCase
        self.validationService = dependency.validationService
        self.wireframe = dependency.wireframe
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        

        
        return Output(
          
        )
    }
}

