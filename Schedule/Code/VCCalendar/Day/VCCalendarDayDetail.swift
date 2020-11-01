//
//  VwCalendarDayDetail.swift
//  Schedule
//
//  Created by Asu on 2020/10/11.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit
import RealmSwift
import RxCocoa
import RxSwift

class VCCalendarDayDetail: UIViewController {
    
    let dayString: [String] = [
        "토".localized,
        "일".localized,
        "월".localized,
        "화".localized,
        "수".localized,
        "목".localized,
        "금".localized,
    ]
    
    let weekdayLabel = UILabel()
    let emptyLabel = UILabel()
    let separator = UIView()
    let downArrow = UIImageView()
    let vwdownArrowDummy = UIView()
    var tableView: UITableView? = nil
    var date: Date = Date()
    
    weak var delegate: CalendarTouchEventDelegate? = nil
    weak var touchDelegate: CalendarTouchEventDelegate? = nil
    
    private var beginPoint: CGPoint? = nil
    private var lastPoint: CGPoint? = nil
    
    var preScrollY: CGFloat = 0
    var isScroll: Bool = false
    
    var list: [Item]? = nil {
        didSet {
            guard
                let list = self.list,
                let preList = self.preList
            else {
                setUpTableView()
                self.preList = self.list
                return
            }
            if list.count == preList.count {
                for item in list {
                    if preList.contains(item) {
                        continue
                    } else {
                        setUpTableView()
                        break
                    }
                }
            } else {
                setUpTableView()
            }
            
            self.preList = self.list
        }
    }
    
    var preList: [Item]? = nil
    
    var holidayList: [String] = []
    var holidayTimeIntervalList: [TimeInterval] = []
    
    convenience init(date: Date) {
        self.init(nibName:nil, bundle:nil)
        self.date = date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
        setUpLabel()
        
        weekdayLabel.setCalendarDayColor(weekday: date.weekday)
        weekdayLabel.text = "\(date.day).\(dayString[date.weekday])"
        
        setHoliday()
        sentToDataList(date: self.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setUpLabel() {
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        
        weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
        weekdayLabel.font = UIFont.boldSystemFont(ofSize: Global.weekdayBigFontSize)
        weekdayLabel.textAlignment = .left
        weekdayLabel.adjustsFontSizeToFitWidth = true
        weekdayLabel.textColor = Theme.font
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.textAlignment = .left
        emptyLabel.adjustsFontSizeToFitWidth = true
        emptyLabel.textColor = .lightGray
        emptyLabel.text = "일정이 없습니다.".localized
        emptyLabel.font = UIFont.systemFont(ofSize: Global.weekdayBigFontSize)
        emptyLabel.isHidden = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = Theme.separator
        
        downArrow.translatesAutoresizingMaskIntoConstraints = false
        downArrow.image = UIImage(systemName: "chevron.compact.down")?.withRenderingMode(.alwaysTemplate)
        downArrow.tintColor = UIColor.lightGray.withAlphaComponent(0.4)
        downArrow.isUserInteractionEnabled = true
        downArrow.isHidden = true
        
        vwdownArrowDummy.translatesAutoresizingMaskIntoConstraints = false
        vwdownArrowDummy.backgroundColor = .clear
        vwdownArrowDummy.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchDownArrow))
        vwdownArrowDummy.addGestureRecognizer(tap)
        
        view.addSubview(weekdayLabel)
        view.addSubview(emptyLabel)
        view.addSubview(separator)
        view.addSubview(downArrow)
        view.addSubview(vwdownArrowDummy)
        
        let margin: CGFloat = Global.calendarleftMargin + 5
        
        NSLayoutConstraint.activate([
            weekdayLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: margin),
            weekdayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            separator.topAnchor.constraint(equalTo: view.topAnchor),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: Global.separatorSize),
            
            downArrow.topAnchor.constraint(equalTo: view.topAnchor),
            downArrow.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downArrow.widthAnchor.constraint(equalToConstant: 40.0),
            downArrow.heightAnchor.constraint(equalToConstant: 30.0),
            
            vwdownArrowDummy.centerXAnchor.constraint(equalTo: downArrow.centerXAnchor),
            vwdownArrowDummy.centerYAnchor.constraint(equalTo: downArrow.centerYAnchor),
            vwdownArrowDummy.widthAnchor.constraint(equalToConstant: 60.0),
            vwdownArrowDummy.heightAnchor.constraint(equalToConstant: 45.0),
        ])
    }
    
    private func setUpTableView() {
        removeTableView()
        guard
            self.list?.count ?? 0 > 0
                || holidayList.count > 0
        else {
            emptyLabel.isHidden = false
            return
        }
        
        emptyLabel.isHidden = true
        tableView = UITableView(frame: .zero, style: .plain)
        guard let tableView = tableView else { return }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delaysContentTouches = false
        
        addRegister()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: weekdayLabel.bottomAnchor, constant: 10.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.reloadData()
    }
    
    // MARK: - Functions
    private func removeTableView() {
        guard let tableView = tableView else { return }
        tableView.removeFromSuperview()
        self.tableView = nil
    }
    
    private func addRegister() {
        tableView?.register(CellCalendarDayDetail.self, forCellReuseIdentifier: CellCalendarDayDetail.identifier)
    }
    
    private func setHoliday() {
        holidayList.removeAll()
        if let solarHoliday = Holiday.solarDictionary[date.dateToMonthDayString()] {
            holidayList.append(solarHoliday)
        }
        
        if let lunarHoliday = Holiday.lunarDictionary[date.dateToLunarString()] {
            holidayList.append(lunarHoliday)
        }
        
        if let lunarHoliday = Holiday.lunarDictionary[date.nextDay.dateToLunarString()] {
            if lunarHoliday == "설날" {
                holidayList = ["설날 연휴"]
            }
        }
        
        if let date = Holiday.getAlternativeHolidays(minDate: date.startOfDay, maxDate: date.endOfDay) {
            if self.date.startOfDay == date.startOfDay {
                holidayList.append(Holiday.alternativeHolidays)
            }
        }
        
        if holidayList.count > 0 {
            weekdayLabel.textColor = Theme.sunday
        }
        
        setHolidayTimeInterval()
        setAlternativeHolidayTimeInterval()
    }
    
    func setHolidayTimeInterval() {
        let minDate = self.date.startOfDay.startOfWeek
        let maxDate = self.date.endOfDay.endOfWeek
        let minDay = minDate.dateToMonthDayString()
        let maxDay = maxDate.dateToMonthDayString()
        let holidayKeyList = Holiday.isHoliday(minDay: minDay, maxDay: maxDay)
        let dictionary = Holiday.getHolidayList(stringArray: holidayKeyList)
        
        let lunarMinDay = minDate.dateToLunarString()
        let lunarMaxDay = maxDate.dateToLunarString()
        let lunarHolidayKeyList = Holiday.isHoliday(minDay: lunarMinDay, maxDay: lunarMaxDay, isLunar: true)
        let lunarDictionary = Holiday.getHolidayList(stringArray: lunarHolidayKeyList, isLunar: true)
        
        for idx in 0 ..< 7 {
            let date = self.date.startOfDay.getNextCountDay(count: idx)
            let dayString = date.dateToMonthDayString()
            if let _ = dictionary[dayString] {
                self.holidayTimeIntervalList.append(date.timeIntervalSince1970)
            }
        }
        
        guard lunarDictionary.count > 0 else { return }
        for idx in 0 ..< 7 {
            var holidayList: [String] = []
            let date = self.date.startOfDay.getNextCountDay(count: idx)
            let dayString = date.dateToLunarString()
            if let value = lunarDictionary[dayString] {
                holidayList.append(value)
                self.holidayTimeIntervalList.append(date.timeIntervalSince1970)
                if value == "설날" {
                    self.holidayTimeIntervalList.append(date.startOfDay.getNextCountDay(count: -1).timeIntervalSince1970)
                }
            }
        }
    }
    
    func setAlternativeHolidayTimeInterval() {
        let minDate = self.date.startOfDay.startOfWeek
        let maxDate = self.date.endOfDay.endOfWeek
        guard let date = Holiday.getAlternativeHolidays(minDate: minDate, maxDate: maxDate) else { return }
        
        let month = date.month
        let day = date.day
        
        for idx in 0 ..< 7 {
            let date = self.date.startOfDay.getNextCountDay(count: idx)
            let viewMonth = date.month
            let viewDay = date.day
            
            if month == viewMonth
                && day == viewDay {
                self.holidayTimeIntervalList.append(date.startOfDay.timeIntervalSince1970)
            }
        }
    }
    
    @objc private func touchDownArrow(_ sender: UITapGestureRecognizer) {
        delegate?.touchBegin()
        delegate?.touchEnd(diff: -30.0)
    }
    
    func sentToDataList(date: Date) {
        let column = Global.calendarColumn
        let startDate = date.startOfDay.startOfWeek
        let endDate = date.endOfDay.endOfWeek
        let startTime = startDate.timeIntervalSince1970
        let endTime = endDate.timeIntervalSince1970
        
        // 해당 주의 공휴일 리스트
        let holidayList = self.holidayTimeIntervalList.filter { (time) -> Bool in
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
            
            var list: [Item] = []
            let weekday = date.weekday > 0 ? date.weekday - 1 : 6
            let date = startDate.getNextCountDay(count: weekday)
            
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
                        }
                    }
                }
                
                for item in dayList {
                    list.append(item)
                }
                
                self.list = list
            } else {
                for twoDayProiority in proiorityArray[weekday] {
                    if twoDayProiority.assignFlag {
                        if let item = twoDayProiority.item {
                            list.append(item)
                        }
                    }
                }
                self.list = list
            }
        } else {
            let weekday = date.weekday > 0 ? date.weekday - 1 : 6
            let date = startDate.getNextCountDay(count: weekday)
            self.list = Item.getDayList(date: date)
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
            selector: #selector(didReceivedAddNotification),
            name: NSNotification.Name(rawValue: NamesOfNotification.refreshCalendar),
            object: nil
        )
    }
    
    @objc func didReceivedAddNotification(_ notification: Notification) {
        setHoliday()
        sentToDataList(date: self.date)
    }
}
