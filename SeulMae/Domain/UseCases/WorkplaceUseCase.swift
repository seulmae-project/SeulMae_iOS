//
//  WorkplaceUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation

protocol WorkplaceUseCase {
    /// - Tag: Main

}

class DefaultWorkplaceUseCase: WorkplaceUseCase {
    
    private let workplaceRepository: WorkplaceRepository
    
    init(workplaceRepository: WorkplaceRepository) {
        self.workplaceRepository = workplaceRepository
    }
    
    
}
