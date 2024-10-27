//
//  PlaceCreationiewModel.swift
//  SeulMae
//
//  Created by 조기열 on 8/13/24.
//

import UIKit.UIImage
import RxSwift
import RxCocoa

final class PlaceCreationiewModel: ViewModel {
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
        let validationResult: Driver<PlaceCreationValidationResults>
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

        let validatedName = input.name.flatMapLatest { name -> Driver<PlaceCreationValidationResults> in
            let trimmed = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmed.isEmpty {
                return .just(.name(result: .empty(message: "empty")))
            }
            
            return .just(.name(result: .ok(message: "ok")))
        }
        
        let validatedContact = input.name.flatMapLatest { name -> Driver<PlaceCreationValidationResults> in
            let trimmed = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmed.isEmpty {
                return .just(.contact(result: .empty(message: "empty")))
            }
            
            return .just(.contact(result: .ok(message: "ok")))
        }
        
        let validationResult = Driver.merge(validatedName, validatedContact)

        let createEnabled = Driver.combineLatest(
            // 주소까지 
            validatedName, validatedContact, loading) { name, contact, loading in
                name.result.isValid &&
                contact.result.isValid &&
                !loading
            }
            .distinctUntilChanged()

        let startEmptyImage = input.image.startWith(UIImage())
        let inputs = Driver.combineLatest(startEmptyImage, input.name, input.contact, input.address, input.subAddress) { (image: $0, name: $1, contact: $2, address: $3, subAddress: $4) }

        let action = input.onCreate
            .withLatestFrom(inputs)
            .withUnretained(self) 
            .flatMapLatest { (self, inputs) -> Driver<String> in
                self.workplaceUseCase
                    .addNewWorkplace(image: inputs.image, name: inputs.name, contact: inputs.contact, address: inputs.address, subAddress: inputs.subAddress)
                    .trackActivity(tracker)
                    .flatMapLatest { isCreated -> Observable<String> in
                        let title = isCreated ? "근무지 생성 완료" : "근무지 생성 실패"
                        let message = isCreated ? "근무 일정을 추가할 수 있어요" : "잠시 뒤 다시 시도해주세요"
                        let actions = isCreated ? ["추가하기", "다음에"] : ["확인"]
                        return self.wireframe
                            .promptAlert(title, message: message, actions: actions)
                    }
                    .asDriver()
            }

        // TODO: 알림 처리

        Task {
            for await action in action.values {
                if action == "추가하기" {
                    coordinator.moveToScheduleCreation()
                }
            }
        }


        // MARK: Coordinator

        return Output(
            loading: loading,
            validationResult: validationResult,
            createEnabled: createEnabled
        )
    }
}
