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

struct TwoDayProiority {
    var assignFlag: Bool
    var item: Item?
}

protocol CalendarTouchEventDelegate: class {
    func touchBegin()
    func touchMove(diff: CGFloat)
    func touchEnd(diff: CGFloat)
}

class VCCalendarMonth: UIViewController {
    var dayViews: [VwCalendarDay] = []
    private var date = Date()
    private var row: Int = 0
    
    private var holidayList: [TimeInterval] = []
    
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
        setHoliday()
        setAlternativeHoliday()
        sentToDataList()
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
        
        setGestrue()
    }
    
    private func setUpUI() {
        let curDate = Date()
        let today = curDate.startOfDay.day
        let month = curDate.month
        let lastDayMonth = date.startOfMonth.month
        
        let weekday = date.startOfMonth.weekday == 0 ? 7 : date.startOfMonth.weekday
        
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
            dayView.vcMonthCalendar = self
            dayViews.append(dayView)
            
            let alpha: CGFloat = 0.5
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
                        && month == lastDayMonth
                        && curDate.year == self.date.year {
                        let date = self.date.getNextCountDay(count: day - 1)
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
    
    @objc func tapDay(sender: UITapGestureRecognizer) {
        guard
            let view = sender.view as? VwCalendarDay,
            let date = view.date
            else { return }
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NamesOfNotification.moveCalendarMonth),
            object: nil,
            userInfo: ["date": date]
        )
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
        
        let weekday = date.startOfMonth.weekday == 0 ? 7 : date.startOfMonth.weekday
        
        let lastDay = date.startOfMonth.endOfMonth.day
        let prevLastDay = date.prevMonth.endOfMonth.day
        for i in 0..<(row * Global.calendarColumn) {
            if i + 1 >= weekday {
                // 다음달
                if i+1-weekday >= lastDay {
                    let day = i + 1 - weekday - lastDay
                    let nextDate = date.nextMonth.getNextCountDay(count: day)
                    dayViews[safe: i]?.date = nextDate
                } else {
                    // 현재달
                    let day = i + 1 - weekday
                    let date = self.date.getNextCountDay(count: day)
                    dayViews[safe: i]?.date = date
                }
            } else {
                // 이전달
                let day = prevLastDay - weekday + i + 1
                let count = day - prevLastDay
                let preDate = date.getNextCountDay(count: count)
                dayViews[safe: i]?.date = preDate
            }
        }
    }
    
    func setHoliday() {
        guard
            let minDate = dayViews[safe: 0]?.date,
            let maxDate = dayViews[safe: dayViews.count - 1]?.date
        else { return }
        self.holidayList.removeAll()
        let minDay = minDate.dateToMonthDayString()
        let maxDay = maxDate.dateToMonthDayString()
        let holidayKeyList = Holiday.isHoliday(minDay: minDay, maxDay: maxDay)
        let dictionary = Holiday.getHolidayList(stringArray: holidayKeyList)
        
        let lunarMinDay = minDate.dateToLunarString()
        let lunarMaxDay = maxDate.dateToLunarString()
        let lunarHolidayKeyList = Holiday.isHoliday(minDay: lunarMinDay, maxDay: lunarMaxDay, isLunar: true)
        let lunarDictionary = Holiday.getHolidayList(stringArray: lunarHolidayKeyList, isLunar: true)
        
        for view in dayViews {
            var holidayList: [String] = []
            if let date = view.date {
                let dayString = date.dateToMonthDayString()
                if let value = dictionary[dayString] {
                    holidayList.append(value)
                    self.holidayList.append(date.startOfDay.timeIntervalSince1970)
                }
            }
            view.holidayList = holidayList
        }
        
        guard lunarDictionary.count > 0 else { return }
        for (idx, view) in dayViews.enumerated() {
            var holidayList: [String] = []
            if let date = view.date {
                let dayString = date.dateToLunarString()
                if let value = lunarDictionary[dayString] {
                    holidayList.append(value)
                    self.holidayList.append(date.startOfDay.timeIntervalSince1970)
                    view.holidayList = holidayList
                    if value == "설날" {
                        dayViews[safe: idx - 1]?.holidayList = ["설날 연휴"]
                        self.holidayList.append(date.startOfDay.getNextCountDay(count: -1).timeIntervalSince1970)
                    }
                }
            }
        }
    }
    
    func setAlternativeHoliday() {
        guard
            let minDate = dayViews[safe: 0]?.date,
            let maxDate = dayViews[safe: dayViews.count - 1]?.date
        else { return }
        
        guard let date = Holiday.getAlternativeHolidays(minDate: minDate, maxDate: maxDate) else { return }
        
        let month = date.month
        let day = date.day
        
        for view in dayViews {
            let viewMonth = view.date?.month
            let viewDay = view.date?.day
            
            if month == viewMonth
                && day == viewDay {
                self.holidayList.append(date.startOfDay.timeIntervalSince1970)
                view.holidayList = ["\(Holiday.alternativeHolidays)"]
            }
        }
    }
    
    /*
     1. (완료) item list 얻는 방식 2가지로 변경
        a. 일주일간의 이틀 이상 이벤트 리스트 반환 함수
        b. 해당 날만 있는 이벤트 반환 함수
     
     2. (완료) 해당 주에 공휴일리스트, 이틀 이상 리스트를 뽑아옮
     3. (완료) 이틀이상 리스트 수 + 공휴일 리스트 수 만큼의 배열을 만듬
     - 배열 타입은 (bool, Item) 으로 지정
     4. (완료) 3번의 배열을 각 요일별로 만듬
     5. 해당 배열에 공휴일 우선순위를 먼저 넣음
     - 공휴일은 Item() 로 생성하여 넣음
     6. 이틀 이상의 뷰를 0, 1 ... n 인덱스 까지 for 문으로
        들어갈 수 있는 자리를 찾고, 찾았으면 (true, item) 으로 할당
     7. 할당된 배열을 각 요일별로 list.append 하고, 오늘 이벤트를 받아와 append 하여
        각 요일에 배분한다.
     */
    func sentToDataList() {
        let column = Global.calendarColumn
        for i in 0 ..< row {
            guard
                let startDate = dayViews[i * column].date?.startOfDay,
                let endDate = dayViews[i * column + (column - 1)].date?.endOfDay
            else { return }
            let startTime = startDate.timeIntervalSince1970
            let endTime = endDate.timeIntervalSince1970
            
            // 해당 주의 공휴일 리스트
            let holidayList = self.holidayList.filter { (time) -> Bool in
                startTime <= time && time <= endTime
            }
            
            if let twoDayList = Item.getTwoDayList(date: startDate) {
                // 우선순위를 체크할 배열
                var proiorityArray: [[TwoDayProiority]] = []
                
                for _ in 0 ..< column {
                    var list: [TwoDayProiority] = []
                    for _ in 0 ..< holidayList.count + twoDayList.count {
                        list.append(TwoDayProiority(assignFlag: false, item: nil))
                    }
                    proiorityArray.append(list)
                }
                
                // 공휴일 체크
                for timeInterval in holidayList {
                    let date = Date(timeIntervalSince1970: timeInterval)
                    let weekday = date.weekday > 0 ? date.weekday - 1 : 6
                    
                    proiorityArray[weekday][0].assignFlag = true
                }
                
                for item in twoDayList {
                    let start: Date
                    if item.startDate < startDate.timeIntervalSince1970 {
                        start = startDate
                    } else {
                        start = Date(timeIntervalSince1970: item.startDate)
                    }
                    
                    let end: Date
                    if item.endDate > endDate.timeIntervalSince1970 {
                        end = endDate
                    } else {
                        end = Date(timeIntervalSince1970: item.endDate)
                    }
                    
                    let startWeekday = start.weekday > 0 ? start.weekday - 1 : 6
                    let endWeekday = end.weekday > 0 ? end.weekday - 1 : 6
                    
                    var idx: Int = -1
                    
                    for count in 0 ..< holidayList.count + twoDayList.count {
                        for weekday in startWeekday ... endWeekday {
                            if proiorityArray[weekday][count].assignFlag {
                                break
                            }
                            
                            if weekday == endWeekday
                                && proiorityArray[weekday][count].assignFlag == false {
                                idx = count
                                break
                            }
                        }
                        if idx != -1 {
                            break
                        }
                    }
                    
                    for weekday in startWeekday ... endWeekday {
                        proiorityArray[weekday][idx].assignFlag = true
                        proiorityArray[weekday][idx].item = item
                    }
                }
                
                for j in 0 ..< column {
                    if let date = dayViews[(i * column) + j].date {
                        var list: [Item] = []
                        let weekday = date.weekday > 0 ? date.weekday - 1 : 6
                        
                        if var dayList = Item.getDayList(date: date) {
                            for twoDayProiority in proiorityArray[weekday] {
                                if twoDayProiority.assignFlag {
                                    if let item = twoDayProiority.item {
                                        list.append(item)
                                    }
                                } else {
                                    if dayList.count > 0 {
                                        let item = dayList.remove(at: 0)
                                        list.append(item)
                                    } else {
                                        list.append(Item())
                                    }
                                }
                            }
                            
                            dayViews[(i * column) + j].list = list
                        } else {
                            for twoDayProiority in proiorityArray[weekday] {
                                if twoDayProiority.assignFlag {
                                    if let item = twoDayProiority.item {
                                        list.append(item)
                                    }
                                } else {
                                    list.append(Item())
                                }
                            }
                            
                            dayViews[(i * column) + j].list = list
                        }
                    }
                }
            } else {
                for j in 0 ..< column {
                    if let date = dayViews[(i * column) + j].date {
                        dayViews[(i * column) + j].list = Item.getDayList(date: date)
                    }
                }
            }
        }
    }
    
    func setGestrue() {
        for view in dayViews {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapDay(sender:)))
            view.addGestureRecognizer(tap)
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
        let month = today.month
        let todayFlag = (today.startOfMonth == self.date.startOfMonth)
        let todayCount = today.day
        
        guard todayFlag else { return }
        
        for view in dayViews {
            if todayCount == Int(view.label.text ?? "0")
                && month == view.date?.month {
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
