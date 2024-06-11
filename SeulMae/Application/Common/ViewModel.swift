//
//  ViewModel.swift
//  KoreaFestival
//
//  Created by 조기열 on 6/6/24.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
