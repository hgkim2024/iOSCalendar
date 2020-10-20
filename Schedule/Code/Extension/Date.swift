//
//  Date.swift
//  Schedule
//
//  Created by Asu on 2020/09/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import Foundation

extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
         return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
         return Calendar.current.component(.day, from: self)
    }
    
    var prevDay: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self.startOfDay)!
    }
    
    var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self.startOfDay)!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var weekday: Int {
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday], from: self)

        if let weekday = comps.weekday {
            return weekday
        } else {
            return -1
        }
    }
    
//    var startOfWeek: Date? {
//        let gregorian = Calendar(identifier: .gregorian)
//        guard let sunday = gregorian.date(
//            from: gregorian.dateComponents(
//                [.yearForWeekOfYear, .weekOfYear],
//                from: self)
//            ) else { return nil }
//        return gregorian.date(byAdding: .day, value: 1, to: sunday)
//    }
//
//    var endOfWeek: Date? {
//        let gregorian = Calendar(identifier: .gregorian)
//        guard let sunday = gregorian.date(
//            from: gregorian.dateComponents(
//                [.yearForWeekOfYear, .weekOfYear],
//                from: self)
//            ) else { return nil }
//        return gregorian.date(byAdding: .day, value: 7, to: sunday)
//    }
    
    var startOfMonth: Date {
        let from = Calendar.current.startOfDay(for: self)
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: from)
        return Calendar.current.date(from: dateComponents)!
    }

    var endOfMonth: Date {
        let dateComponents = DateComponents(month: 1, day: -1)
        return Calendar.current.date(
            byAdding: dateComponents,
            to: self.startOfMonth)!
    }
    
    var nextMonth: Date {
        let dateComponents = DateComponents(month: 1, day: 0)
        return Calendar.current.date(
            byAdding: dateComponents,
            to: self.startOfMonth)!
    }
    
    var prevMonth: Date {
        let dateComponents = DateComponents(month: -1, day: 0)
        return Calendar.current.date(
            byAdding: dateComponents,
            to: self.startOfMonth)!
    }
    
    func getNextCountDay(count: Int) -> Date {
        let dateComponents = DateComponents(day: count - 1)
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    func dateToString() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy.MM"
        return format.string(from: self)
    }
    
    func dateToMonthDayString() -> String {
        let format = DateFormatter()
        format.dateFormat = "MMdd"
        return format.string(from: self)
    }
    
    func dateToLunarString() -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.calendar = Calendar(identifier: .chinese)
        dateFormatter.dateFormat = "MMdd"
        return dateFormatter.string(from: self)
    }
}
