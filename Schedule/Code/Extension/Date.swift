//
//  Date.swift
//  Schedule
//
//  Created by Asu on 2020/09/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import Foundation

extension Date {
    func startOfMonth() -> Date {
        let from = Calendar.current.startOfDay(for: self)
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: from)
        return Calendar.current.date(from: dateComponents)!
    }

    func endOfMonth() -> Date {
        let dateComponents = DateComponents(month: 1, day: -1)
        return Calendar.current.date(
            byAdding: dateComponents,
            to: self.startOfMonth())!
    }
    
    func prevEndOfMonth() -> Date {
        let dateComponents = DateComponents(month: 0, day: -1)
        return Calendar.current.date(
            byAdding: dateComponents,
            to: self.startOfMonth())!
    }
}
