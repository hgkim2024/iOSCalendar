//
//  VwCalendarBody.swift
//  Schedule
//
//  Created by Asu on 2020/09/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VwCalendarBody: UIView {
    var dayViews: [VwCalendarDay] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        // TODO: - 해당 달의 Date 를 넘기도록 수정할 것
        let date = Date()
        let weekday = CalCalendar.shared.calWeekday(date: date.startOfMonth())
        let lastDay = CalCalendar.shared.calMonthLastDay(date: date)
        let prevLastDay = CalCalendar.shared.calMonthLastDay(date: date.prevEndOfMonth())
        let dayCount = Global.dayCount
        
        for i in 0..<(Global.calendarRow * Global.calendarColumn) {
            let dayView = VwCalendarDay()
            dayView.translatesAutoresizingMaskIntoConstraints = false
            dayViews.append(dayView)
            
            // 날짜 setText
            if i + 1 >= weekday {
                // 다음달
                if i+1-weekday >= lastDay {
                    dayView.setText(text: "\(i+2-weekday-lastDay)")
                } else {
                    // 현재달
                    dayView.setText(text: "\(i+2-weekday)")
                }
            } else {
                // 이전달
                dayView.setText(text: "\(prevLastDay-weekday+i+2)")
            }
            
            // 날짜 setColor
            let status = (i + 1) % dayCount
            dayView.setColor(weekday: status)
        }
    }
    
    func displayUI() {
        let dayCount = Global.dayCount
        let rowCount = Global.calendarRow
        for row in 0..<rowCount {
            for column in 0..<Global.calendarColumn {
                let dayView = dayViews[(row * dayCount) + column]
                addSubview(dayView)
                
                if row == 0 {
                    dayView.topAnchor.constraint(equalTo: topAnchor).isActive = true
                } else {
                    dayView.topAnchor.constraint(equalTo: dayViews[((row - 1) * dayCount) + column].bottomAnchor).isActive = true
                }
                
                if column == 0 {
                    dayView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                } else {
                    dayView.leadingAnchor.constraint(equalTo: dayViews[(row * dayCount) + column - 1].trailingAnchor).isActive = true
                }
                
                dayView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0/CGFloat(dayCount)).isActive = true
                dayView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0/CGFloat(rowCount)).isActive = true
            }
        }
    }
}
