//
//  VCCalendarMonth.swift
//  Schedule
//
//  Created by Asu on 2020/09/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VCCalendarMonth: UIViewController {
    private var dayViews: [VwCalendarDay] = []
    private var date = Date()
    
    convenience init(date: Date) {
        self.init(nibName:nil, bundle:nil)
        self.date = date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        displayUI()
    }
    
    func setUpUI() {
        let weekday = CalCalendar.shared.calWeekday(date: date.startOfMonth)
        let lastDay = CalCalendar.shared.calMonthLastDay(date: date.startOfMonth)
        let prevLastDay = CalCalendar.shared.calMonthLastDay(date: date.prevMonth)
        let dayCount = Global.dayCount
        
        for i in 0..<(Global.calendarRow * Global.calendarColumn) {
            let dayView = VwCalendarDay()
            dayView.translatesAutoresizingMaskIntoConstraints = false
            dayViews.append(dayView)
            
            let status = (i + 1) % dayCount
            
            // 날짜 setText
            if i + 1 >= weekday {
                // 다음달
                if i+1-weekday >= lastDay {
                    dayView.setText(text: "\(i+2-weekday-lastDay)")
                    dayView.setColor(weekday: status, alpha: 0.3)
                } else {
                    // 현재달
                    dayView.setText(text: "\(i+2-weekday)")
                    dayView.setColor(weekday: status)
                }
            } else {
                // 이전달
                dayView.setText(text: "\(prevLastDay-weekday+i+2)")
                dayView.setColor(weekday: status, alpha: 0.3)
            }
        }
    }
    
    func displayUI() {
        let dayCount = Global.dayCount
        let rowCount = Global.calendarRow
        for row in 0..<rowCount {
            for column in 0..<Global.calendarColumn {
                let dayView = dayViews[(row * dayCount) + column]
                view.addSubview(dayView)
                
                if row == 0 {
                    dayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                } else {
                    dayView.topAnchor.constraint(equalTo: dayViews[((row - 1) * dayCount) + column].bottomAnchor).isActive = true
                }
                
                if column == 0 {
                    dayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                } else {
                    dayView.leadingAnchor.constraint(equalTo: dayViews[(row * dayCount) + column - 1].trailingAnchor).isActive = true
                }
                
                dayView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0/CGFloat(dayCount)).isActive = true
                dayView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0/CGFloat(rowCount)).isActive = true
            }
        }
    }
    
    // MARK: - Functions
    
    func getDate() -> Date {
        return date
    }
}
