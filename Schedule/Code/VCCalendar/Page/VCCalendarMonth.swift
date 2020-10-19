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
    var initSelectedDate: Date? = nil
    var isUp: Bool = false
    var preSelecedDay: VwCalendarDay? = nil
    private var preToday: VwCalendarDay? = nil
    
    convenience init(date: Date) {
        self.init(nibName:nil, bundle:nil)
        self.date = date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
        setUpUI()
        displayUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpData()
        setToday()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if initSelectedDate != nil {
            
            for view in dayViews {
                if view.date == initSelectedDate {
                    preSelecedDay?.deselectedDay()
                    view.selectedDay()
                    preSelecedDay = view
                    loadViewIfNeeded()
                    break
                }
            }
            
            initSelectedDate = nil
        }
        
        if preSelecedDay == nil {
            for view in dayViews {
                if view.label.text ?? "0" == "1" {
                    view.selectedDay()
                    preSelecedDay = view
                    loadViewIfNeeded()
                    break
                }
            }
        } else {
            preSelecedDay?.selectedDay()
        }
    }
    
    private func setUpUI() {
        let today = Date().startOfDay.day
        let month = Date().month
        let lastDayMonth = date.startOfMonth.month
        
        let weekday = date.startOfMonth.weekday
        let lastDay = date.startOfMonth.endOfMonth.day
        let prevLastDay = date.prevMonth.endOfMonth.day
        
        let remainder = (weekday + lastDay - 1) % 7
        row = ((weekday + lastDay - 1) / 7) + 1
        
        if remainder == 0 {
            row -= 1
        }
        
        for i in 0..<(row * Global.calendarColumn) {
            let dayView = VwCalendarDay(row: row)
            dayView.translatesAutoresizingMaskIntoConstraints = false
            dayViews.append(dayView)
            
            let alpha: CGFloat = 0.4
            // 날짜 setText
            if i + 1 >= weekday {
                // 다음달
                if i+1-weekday >= lastDay {
                    let day = i + 2 - weekday - lastDay
                    dayView.setText(text: "\(day)")
                    dayView.setAlpha(alpha: alpha)
                } else {
                    // 현재달
                    let day = i + 2 - weekday
                    dayView.setText(text: "\(day)")
                    
                    if today == day
                        && month == lastDayMonth {
                        let date = self.date.getNextCountDay(count: day)
                        dayView.date = date
                        dayView.selectedDay()
                        dayView.setTodayView()
                        preToday = dayView
                        preSelecedDay = dayView
                    }
                }
            } else {
                // 이전달
                let day = prevLastDay - weekday + i + 2
                dayView.setText(text: "\(day)")
                dayView.setAlpha(alpha: alpha)
            }
        }
    }
    
    private func displayUI() {
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
    
    @objc func tapDay2(sender: UITapGestureRecognizer) {
        guard let view = sender.view as? VwCalendarDay else { return }
        guard let date = view.date else { return }
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NamesOfNotification.moveCalendarMonth),
            object: nil,
            userInfo: ["date": date]
        )
        
        delegate?.touchBegin()
        delegate?.touchEnd(diff: 30.0)
    }
    
    @objc func tapDay(sender: UITapGestureRecognizer) {
        guard let view = sender.view as? VwCalendarDay else { return }
        if let selectMonth = view.date?.month,
           date.month != selectMonth {
            guard let date = view.date else { return }
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: NamesOfNotification.moveCalendarMonth),
                object: nil,
                userInfo: ["date": date]
            )
            return
        }
        
        preSelecedDay?.deselectedDay()
        view.selectedDay()
        preSelecedDay = view

        delegate?.touchBegin()
        delegate?.touchEnd(diff: 30.0)
    }
    
    func moveDay(moveDate: Date) {
        DispatchQueue.main.async {
            self.preSelecedDay?.deselectedDay()
            
            for view in self.dayViews {
                if view.date?.startOfDay == moveDate.startOfDay {
                    view.selectedDay()
                    self.preSelecedDay = view
                    break
                }
            }
        }
    }
    
    func setUpData() {
        for view in dayViews {
            view.isUp = self.isUp
        }
        
        let weekday = date.startOfMonth.weekday
        let lastDay = date.startOfMonth.endOfMonth.day
        let prevLastDay = date.prevMonth.endOfMonth.day
        var list: [Item]? = nil
        for i in 0..<(Global.calendarRow * Global.calendarColumn) {
            if i + 1 >= weekday {
                // 다음달
                if i+1-weekday >= lastDay {
                    let day = i + 2 - weekday - lastDay
                    let nextDate = date.nextMonth.getNextCountDay(count: day)
                    list = Item.getDayList(date: nextDate)
                    dayViews[safe: i]?.date = nextDate
                } else {
                    // 현재달
                    let day = i + 2 - weekday
                    let date = self.date.getNextCountDay(count: day)
                    list = Item.getDayList(date: date)
                    dayViews[safe: i]?.date = date
                }
            } else {
                // 이전달
                let day = prevLastDay - weekday + i + 2
                let count = day - prevLastDay
                let preDate = date.getNextCountDay(count: count)
                list = Item.getDayList(date: preDate)
                dayViews[safe: i]?.date = preDate
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapDay(sender:)))
            dayViews[safe: i]?.addGestureRecognizer(tap)
            dayViews[safe: i]?.list = list
        }
    }
    
    // MARK: - Touch Event
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
        if beginPoint.y != lastPoint.y {
            delegate?.touchEnd(diff: y)
        }
        self.beginPoint = nil
    }
    
    // MARK: - Observer
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setTodayNotification),
            name: NSNotification.Name(rawValue: NamesOfNotification.setToday),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setIsUp),
            name: NSNotification.Name(rawValue: NamesOfNotification.calendarIsUp),
            object: nil
        )
    }
    
    @objc func setTodayNotification() {
        setToday()
    }
    
    func setToday() {
        let today = Date()
        let todayFlag = (today.startOfMonth == self.date.startOfMonth)
        let todayCount = today.day
        
        guard todayFlag else { return }
        
        for view in dayViews {
            if todayCount == Int(view.label.text ?? "0") {
                preToday?.removeTodayView()
                view.setTodayView()
                preToday = view
                loadViewIfNeeded()
                break
            } else {
                view.todayFlag = false
            }
        }
    }
    
    @objc func setIsUp(_ notification: Notification) {
        guard let isUp = notification.userInfo?["isUp"] as? Bool
        else {
                return
        }
        
        self.isUp = isUp
    }
}
