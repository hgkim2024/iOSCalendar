//
//  Global.swift
//  Schedule
//
//  Created by Asu on 2020/09/05.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class Global {
    static let calendarMargin: CGFloat = 10
    static let calendarleftMargin: CGFloat = 10
    
    static let weekdayBigFontSize: CGFloat = 20
    static let weekdayFontSize: CGFloat = 12
    static let weekdayHeight: CGFloat = 35
    static let dayCount: Int = 7
    static let calendarRow: Int = 6
    static let calendarColumn: Int = 7
    
    static let fontSize: CGFloat = 15
    
    static let separatorSize: CGFloat = 0.7
    
    static let locale: Locale = Locale(identifier: Locale.current.languageCode ?? "EN")
    
    static func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

