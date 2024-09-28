//
//  ScheduleReminderItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/24/24.
//

import Foundation

struct ScheduleReminderItem {
    
    var reminder: String {
        if inToday.isEmpty {
            return "금일은 근무 일정이 비어있어요"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        let matched = inToday.filter {
            let startDate = dateFormatter.date(from: $0.startTime)
            let endDate = dateFormatter.date(from: $0.endTime)
            return (Date.ext.now < startDate!)
        }
        
        guard let first = matched.first else {
            return "일정은 있지만 다 지난경우 > 멘트 필요"
        }
        
        let firstDate = dateFormatter.date(from: first.startTime)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: Date.ext.now, to: firstDate!)
        if ((components.hour == nil) && (components.hour == 0)) { "\(components.hour)시간 \(components.minute)분 뒤에 \(first.title) 일정이 있어요!"
        } else {
            return "\(components.minute)분 뒤에 \(first.title) 일정이 있어요!"
        }
        
        return "???"
    }
    
    let workScheduleList: [WorkSchedule]
    
    var isRequest: Bool {
        return false
    }
    
    init(workScheduleList: [WorkSchedule]) {
        self.workScheduleList = workScheduleList
    }
    
    var inToday: [WorkSchedule] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date.ext.now)
        guard let today = components.day else { return [] }
        let matched = workScheduleList
            .filter { $0.days.contains(today) }
            .sorted { first, second in
                // TODO: - 애초에 date 로 받기
                let firstDate = dateFormatter.date(from: first.startTime)
                let secondDate = dateFormatter.date(from: second.startTime)
                return firstDate! < secondDate!
            }
        return matched
    }
}
