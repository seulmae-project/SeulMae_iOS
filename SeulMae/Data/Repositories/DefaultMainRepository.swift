//
//  DefaultMainRepository.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Moya
import RxMoya
import RxSwift

class DefaultMainRepository: MainRepository {
   
    // MARK: - Dependancies
    
    private let network: MainNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: MainNetworking) {
        self.network = network
    }
    
    // MARK: - Signin
   
}
