//
//  VCCalendarMonth.swift
//  Schedule
//
//  Created by Asu on 2020/09/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit
import RealmSwift
import RxCocoa
import RxSwift

protocol CalendarTouchEventDelegate: class {
    func touchBegin()
    func touchMove(diff: CGFloat)
    func touchEnd(diff: CGFloat)
}

class VCCalendarMonth: UIViewController {
    var dayViews: [VwCalendarDay] = []
    private var date = Date()
    private var row: Int = 0
    
    private var beginPoint: CGPoint? = nil
    private var lastPoint: CGPoint? = nil
    
    weak var delegate: CalendarTouchEventDelegate? = nil
    
    var isUp: Bool = false
    
    convenience init(date: Date) {
        self.init(nibName:nil, bundle:nil)
        self.date = date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        displayUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("isUp: \(isUp)")
        for view in dayViews {
            view.isUp = self.isUp
        }
        setUpData()
    }
    
    func setUpUI() {
        let weekday = CalCalendar.shared.calWeekday(date: date.startOfMonth)
        let lastDay = CalCalendar.shared.calMonthLastDay(date: date.startOfMonth)
        let prevLastDay = CalCalendar.shared.calMonthLastDay(date: date.prevMonth)
        let dayCount = Global.dayCount
        
        let remainder = (weekday + lastDay - 1) % 7
        row = ((weekday + lastDay - 1) / 7) + 1
        
        if remainder == 0 {
            row -= 1
        }
        
        for i in 0..<(row * Global.calendarColumn) {
            let dayView = VwCalendarDay()
            dayView.translatesAutoresizingMaskIntoConstraints = false
            dayViews.append(dayView)
            
            let status = (i + 1) % dayCount
            let alpha: CGFloat = 0.4
            // 날짜 setText
            if i + 1 >= weekday {
                // 다음달
                if i+1-weekday >= lastDay {
                    let day = i + 2 - weekday - lastDay
                    dayView.setText(text: "\(day)")
                    dayView.setColor(weekday: status, alpha: alpha)
                } else {
                    // 현재달
                    let day = i + 2 - weekday
                    dayView.setText(text: "\(day)")
                    dayView.setColor(weekday: status)
                }
            } else {
                // 이전달
                let day = prevLastDay - weekday + i + 2
                dayView.setText(text: "\(day)")
                dayView.setColor(weekday: status, alpha: alpha)
            }
        }
    }
    
    func displayUI() {
        let dayCount = Global.dayCount
        for row in 0..<row {
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
                dayView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0/CGFloat(self.row)).isActive = true
            }
        }
    }
    
    // MARK: - Functions
    
    func getDate() -> Date {
        return date
    }
    
    func setUpData() {
        let weekday = CalCalendar.shared.calWeekday(date: date.startOfMonth)
        let lastDay = CalCalendar.shared.calMonthLastDay(date: date.startOfMonth)
        let prevLastDay = CalCalendar.shared.calMonthLastDay(date: date.prevMonth)
        var list: [Item]? = nil
        for i in 0..<(Global.calendarRow * Global.calendarColumn) {
            if i + 1 >= weekday {
                // 다음달
                if i+1-weekday >= lastDay {
                    let day = i + 2 - weekday - lastDay
                    let nextDate = date.nextMonth.getNextCountDay(count: day)
                    list = Item.getDayList(date: nextDate)
                } else {
                    // 현재달
                    let day = i + 2 - weekday
                    let date = self.date.getNextCountDay(count: day)
                    list = Item.getDayList(date: date)
                }
            } else {
                // 이전달
                let day = prevLastDay - weekday + i + 2
                let count = day - prevLastDay
                let preDate = date.getNextCountDay(count: count)
                list = Item.getDayList(date: preDate)
            }
            dayViews[safe: i]?.list = list
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.beginPoint = touch.location(in: touch.view)
        
        delegate?.touchBegin()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            let beginPoint = self.beginPoint
            else { return }
        
        lastPoint = touch.location(in: touch.view)
        let y = beginPoint.y - lastPoint!.y
        delegate?.touchMove(diff: y)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEnd()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEnd()
    }
    
    func touchEnd() {
        guard let beginPoint = self.beginPoint else { return }
        guard let lastPoint = self.lastPoint else { return }
        let y = beginPoint.y - lastPoint.y
        delegate?.touchEnd(diff: y)
        self.beginPoint = nil
    }
}
