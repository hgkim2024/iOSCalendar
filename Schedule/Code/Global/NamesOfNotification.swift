//
//  NamesOfNotification.swift
//  Schedule
//
//  Created by Asu on 2020/09/07.
//  Copyright © 2020 Asu. All rights reserved.
//

import Foundation

class NamesOfNotification {
    
    // 메인 캘린더 Notification
    static let setCalendarTitle = "setCalendarTitle"
    static let refreshCalendar = "refreshCalendar"
    static let setToday = "setToday"
    static let selectedDayToPostDate = "selectedDayToPostDate"
    static let calendarIsUp = "calendarIsUp"
    static let selectedDayDetailNotification = "selectedDayDetailNotification"
    static let dayCalendarDidSelectCell = "dayCalendarDidSelectCell"
    static let moveCalendarMonth = "moveCalendarMonth"
    
    // 이벤트 추가 Notification
    static let setAddEventDateTitle = "setAddEventDateTitle"
    static let AddEventMoveCalendarMonth = "AddEventMoveCalendarMonth"
    static let setAddEventDate = "setAddEventDate"
    static let setAddEventStartDate = "setAddEventStartDate"
    static let setAddEventEndDate = "setAddEventEndDate"
}
