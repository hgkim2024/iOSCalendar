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
    
    // 반환 값: 해당 달의 마지막 날짜, 오류 -1
    // TODO: - 현재 날짜와 마지막 날짜가 같은 경우 다음달 마지막 날짜를 가져옴
    // TODO: - 코드 변경할 것
    func calMonthLastDay(date: Date) -> Int {
        let calendar = Calendar.current
        let components = DateComponents(day:1)
        
        guard let startOfNextMonth = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)
        else {
            return -1
        }
        
        guard let dayDate = calendar.date(byAdding:.day, value: -1, to: startOfNextMonth)
        else {
                return -1
        }
        
        let day = Calendar.current.component(.day, from: dayDate)
        return day
    }
    
    // 이전/다음 날/달/년 구하는 함수
}
