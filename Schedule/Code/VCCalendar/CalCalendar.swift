//
//  CalculationCalendar.swift
//  Schedule
//
//  Created by Asu on 2020/09/05.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class CalCalendar {
    
    static let error: Int = -1
    static var sharedCalCalendar: CalCalendar? = nil
    static var shared: CalCalendar {
        if let copySharedCalCalendar = sharedCalCalendar {
            return copySharedCalCalendar
        } else {
            sharedCalCalendar = CalCalendar()
            return sharedCalCalendar!
        }
    }
    
    // 반환 값: 일요일 1 ~ 토요일 7, 오류 -1
    func calWeekday(date: Date) -> Int {
        let cal = Calendar(identifier: .gregorian)
        let now = date
        let comps = cal.dateComponents([.weekday], from: now)

        if let weekday = comps.weekday {
            return weekday
        } else {
            return -1
        }
    }
    
    func calMonthLastDay(date: Date) -> Int {
        return date.endOfMonth.day
    }
}
