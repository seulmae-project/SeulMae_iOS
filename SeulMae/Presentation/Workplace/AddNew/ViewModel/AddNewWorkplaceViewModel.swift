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
        let mainImage: Signal<Data>
        let name: Driver<String>
        let contact: Driver<String>
        let address: Driver<String>
        let searchAddress: Signal<()>
        let addNew: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let validationResult: Driver<AddNewWorkplaceValidationResult>
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
        
        let validatedName = input.name.flatMapLatest { name -> Driver<AddNewWorkplaceValidationResult> in
            let trimmed = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmed.isEmpty {
                return .just(.name(result: .empty(message: "empty")))
            }
            
            return .just(.name(result: .ok(message: "ok")))
        }
        
        let validatedContact = input.name.flatMapLatest { name -> Driver<AddNewWorkplaceValidationResult> in
            let trimmed = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmed.isEmpty {
                return .just(.contact(result: .empty(message: "empty")))
            }
            
            return .just(.contact(result: .ok(message: "ok")))
        }
        
        let validationResult = Driver.merge(validatedName, validatedContact)
        
        let AddNewEnabled = Driver.combineLatest(
            validatedName, validatedContact, loading) { name, contact, loading in
                name.result.isValid &&
                contact.result.isValid &&
                !loading
            }
            .distinctUntilChanged()
        
        let image = input.mainImage.asDriver()
        
        let combined = Driver.combineLatest(
            image, input.name, input.contact, input.address) { (image: $0, name: $1, contact: $2, address: $3) }
        
        _ = input.addNew.withLatestFrom(combined)
            .flatMapLatest { [weak self] combined -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                let request = AddWorkplaceRequest(workplaceName: combined.name, mainAddress: combined.address, subAddress: "", tel: combined.contact)
                return strongSelf.workplaceUseCase
                    .addNewWorkplace(request: request)
                    .asDriver()
            }
    
        // MARK: Output
        
        return Output(
            loading: loading,
            validationResult: validationResult,
            AddNewEnabled: AddNewEnabled
        )
    }
}
