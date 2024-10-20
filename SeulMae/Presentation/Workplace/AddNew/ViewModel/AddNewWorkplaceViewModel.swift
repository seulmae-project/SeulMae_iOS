//
//  AddNewWorkplaceViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 8/13/24.
//

import UIKit.UIImage
import RxSwift
import RxCocoa

final class AddNewWorkplaceViewModel: ViewModel {
    struct Input {
        let image: Driver<UIImage>
        let name: Driver<String>
        let contact: Driver<String>
        let address: Driver<String>
        let subAddress: Driver<String>
        let onCreate: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let validationResult: Driver<AddNewWorkplaceValidationResult>
        let createEnabled: Driver<Bool>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: FinderFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    private let validationService: ValidationService
    private let wireframe: Wireframe
    
    // MARK: - Life Cycle

    init(
        dependencies: (
            coordinator: FinderFlowCoordinator,
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
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()

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


        let inputs = Driver.combineLatest(input.image, input.name, input.contact, input.address, input.subAddress) { (image: $0, name: $1, contact: $2, address: $3, subAddress: $4) }

        let isCreate = input.onCreate
            .withLatestFrom(inputs)
            .withUnretained(self) { (self, inputs) in
                self.workplaceUseCase
                    .addNewWorkplace(image: inputs.image, name: inputs.name, contact: inputs.contact, address: inputs.address, subAddress: inputs.subAddress)
                    .trackActivity(tracker)
                    .asDriver()
            }

        // TODO: 알림 처리

        Task {
            for await isCreate in isCreate.values {

            }
        }


        // MARK: Coordinator

        return Output(
            loading: loading,
            validationResult: validationResult,
            createEnabled: AddNewEnabled
        )
    }
}
