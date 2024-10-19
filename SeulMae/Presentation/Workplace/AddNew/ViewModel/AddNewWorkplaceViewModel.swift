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
        let detailAddress: Driver<String>
        let searchAddress: Signal<()>
        let addNew: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let validationResult: Driver<AddNewWorkplaceValidationResult>
        let viewState: Driver<AddNewWorkplaceViewController.ViewState>
        let data: Driver<[String: Any]>
        let AddNewEnabled: Driver<Bool>
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
        
        let data = input.searchAddress.flatMapLatest { _ -> Driver<[String: Any]> in
            self.wireframe.searchAddress()
                .asDriver()
        }
        
        let viewState = Driver.combineLatest(
            input.detailAddress, data) { address, data -> AddNewWorkplaceViewController.ViewState in
                return (address.isEmpty &&
                        data.isEmpty) ? .initial : .detailAdress
        }
            .startWith(.initial) // 있는 것과 없는 것의 차이 확인
        
        let AddNewEnabled = Driver.combineLatest(
            validatedName, validatedContact, loading) { name, contact, loading in
                name.result.isValid &&
                contact.result.isValid &&
                !loading
            }
            .distinctUntilChanged()
        
        let image = input.mainImage.asDriver()
            .startWith(Data())
        
        let combined = Driver.combineLatest(
            image, input.name, input.contact, input.detailAddress, data) { (image: $0, name: $1, contact: $2, detailAddress: $3, address: $4["address"]) }
        
        let isAdded = input.addNew.withLatestFrom(combined)
            .flatMapLatest { [weak self] combined -> Driver<Bool> in
                Swift.print("😡😡😡😡😡add😡😡😡😡😡")
                guard let strongSelf = self else { return .empty() }
                let request = AddNewWorkplaceRequest(
                    workplaceName: combined.name,
                    mainAddress: (combined.address as! String),
                    subAddress: combined.detailAddress,
                    workplaceTel: combined.contact)
                return strongSelf.workplaceUseCase
                    .addNewWorkplace(request: request)
                    .asDriver()
                // TODO: - API Error 핸들링 필요
            }
        
        Task {
            for await isAdded in isAdded.values {
                Swift.print(#line, "isAdded: \(isAdded)")
            }
        }
    
        
        // MARK: Coordinator
        
        
      
        
        
        // MARK: Output
        
        return Output(
            loading: loading,
            validationResult: validationResult,
            viewState: viewState,
            data: data,
            AddNewEnabled: AddNewEnabled
        )
    }
}
