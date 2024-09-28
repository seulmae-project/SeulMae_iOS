//
//  RequestAttendanceViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/28/24.
//

import Foundation

//RequestAttendanceViewModel
// private let attendanceUseCase: AttendanceUseCase

// let dateAndWage = Driver.combineLatest(input.startDate, input.endDate, wage)
//        let isAttend = input.onRequest.withLatestFrom(dateAndWage)
//            .flatMapLatest { [weak self] (start, end, wage) -> Driver<Bool> in
//                guard let strongSelf = self else { return .empty() }
//                let request = strongSelf.workTimeCalculator
//                    .calculate(start: start, end: end, wage: wage)
//                return strongSelf.attendanceUseCase
//                    .attend(request: request)
//                    .trackActivity(indicator)
//                    .asDriver()
//            }
//
//        Task {
//            for await _ in isAttend.values {
//
//            }
//        }
