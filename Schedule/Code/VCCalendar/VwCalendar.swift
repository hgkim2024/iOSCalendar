//
//  VCCalendar.swift
//  Schedule
//
//  Created by Asu on 2020/09/05.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

// 캘린더 Root VC
class VwCalendar: UIView {
    
    // 캘린더 상단 요일 표기하는 뷰
    let VCWeekday = VwCalendarWeekday()
    
    // 월간 캘린더
    let VCpage = VCCalendarMonthPage()
    
    // 일간 캘린더
    let VCDayPage = VCCalendarDayDetailPage()
    
    // 하단에 오늘로 이동하는 버튼
    let vwToday = VwMoveToday()
    
    // 헤더 클릭 시 나타나는 데이터 피커
    let vwDatePicker = VwDatePicker()
    var datePcikerTopConstraint: NSLayoutConstraint?
    let datePickerSize: CGFloat = 300.0
    
    // 이벤트 추가 버튼
    let addEventButton = VwAddEventButton()
    let addButtonSize: CGFloat = 50.0
    
    // 캘린더 접혔을 때 높이
    var minHeight: CGFloat = VwCalendar.getMaxCalendarHeight() * (45.0 / 100.0)
    
    // 캘린더 펼쳤을 때 높이
    var maxHeight: CGFloat = VwCalendar.getMaxCalendarHeight()
    
    // 캘린더 터치 후 스와이프 시 가중치
    let weight: CGFloat = 5.0
    
    // 스와이프 제스쳐
    var swipeUp: UISwipeGestureRecognizer?
    var swipeDown: UISwipeGestureRecognizer?
    
    // true: up, false: down
    var upDownStatus: Bool = true
    
    var calendarHeight: NSLayoutConstraint!
    
    let animationFrame: Int = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addObserver()
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        VCWeekday.translatesAutoresizingMaskIntoConstraints = false
        VCpage.view.translatesAutoresizingMaskIntoConstraints = false
        VCpage.touchDelegate = self
        
        VCDayPage.view.translatesAutoresizingMaskIntoConstraints = false
        VCDayPage.touchDelegate = self
        VCDayPage.view.isHidden = true
        
        vwToday.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickToday))
        vwToday.addGestureRecognizer(tap)
        
        vwDatePicker.translatesAutoresizingMaskIntoConstraints = false
        vwDatePicker.isHidden = true
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(hideDatePicker))
        vwDatePicker.cancelLabel.addGestureRecognizer(cancelTap)
        
        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmDatePicker))
        vwDatePicker.confirmLabel.addGestureRecognizer(confirmTap)
        
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        addEventButton.button.layer.cornerRadius = addButtonSize / 2.0
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(sender:)))
        swipeUp!.direction = .up
        
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(sender:)))
        swipeDown!.direction = .down
        
        addGestureRecognizer(swipeUp!)
        addGestureRecognizer(swipeDown!)
    }
    
    private func displayUI() {
        let margin: CGFloat = Global.calendarMargin
        
        addSubview(VCWeekday)
        addSubview(VCpage.view)
        addSubview(VCDayPage.view)
        addSubview(vwToday)
        addSubview(vwDatePicker)
        addSubview(addEventButton)
        
        calendarHeight = VCpage.view.heightAnchor.constraint(equalToConstant: maxHeight)
        datePcikerTopConstraint = vwDatePicker.topAnchor.constraint(equalTo: bottomAnchor)
        
        NSLayoutConstraint.activate([
            VCWeekday.topAnchor.constraint(equalTo: topAnchor),
            VCWeekday.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            VCWeekday.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            VCWeekday.heightAnchor.constraint(equalToConstant: Global.weekdayHeight),
            
            VCpage.view.topAnchor.constraint(equalTo: VCWeekday.bottomAnchor, constant: -5),
            VCpage.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            VCpage.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            calendarHeight,
            
            VCDayPage.view.topAnchor.constraint(equalTo: VCpage.view.bottomAnchor),
            VCDayPage.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            VCDayPage.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            VCDayPage.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            vwToday.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50.0),
            vwToday.centerXAnchor.constraint(equalTo: centerXAnchor),
            vwToday.widthAnchor.constraint(equalToConstant: 55.0),
            vwToday.heightAnchor.constraint(equalToConstant: 35.0),
            
            datePcikerTopConstraint!,
            vwDatePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            vwDatePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            vwDatePicker.heightAnchor.constraint(equalToConstant: datePickerSize),
            
            addEventButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20.0),
            addEventButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            addEventButton.widthAnchor.constraint(equalToConstant: addButtonSize),
            addEventButton.heightAnchor.constraint(equalToConstant: addButtonSize)
        ])
    }
    
    // MARK: - Functions
    
    static func getMaxCalendarHeight() -> CGFloat {
        let window = Global.getKeyWindow()
        
        let totalHeihgt = UIScreen.main.bounds.height
        let topSafeArea = (window?.safeAreaInsets.top ?? 0.0) + (window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + 30.0
        
        let bottomSafeArea = window?.safeAreaInsets.bottom ?? 0.0
        
        return totalHeihgt - topSafeArea - bottomSafeArea
    }
    
    func showDatePicker() {
        vwDatePicker.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.datePcikerTopConstraint?.constant = -self.datePickerSize
            self.layoutIfNeeded()
        })
    }
    
    @objc func confirmDatePicker() {
        let date = vwDatePicker.datePicker.date
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NamesOfNotification.moveCalendarMonth),
            object: nil,
            userInfo: [
                "date": date,
                "isToday": true
            ]
        )
        
        hideDatePicker()
    }
    
    @objc func hideDatePicker() {
        UIView.animate(withDuration: 0.2, animations: {
            self.datePcikerTopConstraint?.constant = 0.0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.vwDatePicker.isHidden = true
        })
    }
    
    private func changeDayCalendarHeight(isUp: Bool) {
        guard let vc = (self.VCpage.viewControllers?[safe: 0] as? VCCalendarMonth) else { return }
        
        for view in vc.dayViews {
            view.changeAlpha(isUp: isUp)
        }
    }
    
    private func getUpDownStatus(diff: CGFloat) -> Bool {
        let weight: CGFloat = self.weight
        
        if self.upDownStatus {
            if diff > weight
                || ((self.calendarHeight.constant - self.minHeight) < (self.maxHeight - self.minHeight) * (2.0/3.0))  {
                return true
                
            } else {
                return false
            }
        } else {
            if diff < -weight
                || ((self.calendarHeight.constant - self.minHeight) > (self.maxHeight - self.minHeight) * (1.0/3.0)) {
                return false
            } else {
                return true
            }
        }
    }
    
    private func touchEndAnimated(isUp: Bool) {
        VCpage.isUp = isUp
        
        UIView.animate(withDuration: 0.25, animations: {
            if isUp {
                self.calendarHeight.constant = self.minHeight
            } else {
                self.calendarHeight.constant = self.maxHeight
            }
            
            self.changeDayCalendarHeight(isUp: isUp)
            self.layoutIfNeeded()
        }, completion: { _ in
            self.addGestureRecognizer(self.swipeUp!)
            self.addGestureRecognizer(self.swipeDown!)
            self.VCDayPage.view.isHidden = !isUp
            self.VCpage.setDataSource(isOn: true)
        })
    }
    
    @objc private func swipeAction(sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            touchEndAnimated(isUp: true)
        } else if sender.direction == .down {
            touchEndAnimated(isUp: false)
        }
    }
    
    // MARK: - Observer
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceivedDayDateNotification),
            name: NSNotification.Name(rawValue: NamesOfNotification.selectedDayToPostDate),
            object: nil
        )
    }
    
    @objc func didReceivedDayDateNotification(_ notification: Notification) {
        guard let date = notification.userInfo?["date"] as? Date
        else {
                return
        }
        
        if date.startOfDay != Date().startOfDay {
            vwToday.isHidden = false
        } else {
            vwToday.isHidden = true
        }
    }
    
    @objc func clickToday(_ sender: UITapGestureRecognizer) {
        guard let vc = (self.VCpage.viewControllers?[safe: 0] as? VCCalendarMonth) else { return }
        
        let vcDate = vc.getDate().startOfDay
        let curDate = Date().startOfDay
        
        guard vcDate != curDate else { return }
        
        if vcDate.year == curDate.year
            && vcDate.month == curDate.month {
            for view in vc.dayViews {
                if view.date?.day == curDate.day {
                    vc.preSelecedDay?.deselectedDay()
                    view.selectedDay()
                    vc.preSelecedDay = view
                    break
                }
            }
        } else {
            self.VCpage.moveDay(moveDate: Date(), isToday: true)
        }
    }
}


extension VwCalendar: CalendarTouchEventDelegate {
    
    func touchBegin() {
        upDownStatus = (calendarHeight.constant > minHeight) ? true : false
        VCDayPage.view.isHidden = false
        
        removeGestureRecognizer(swipeUp!)
        removeGestureRecognizer(swipeDown!)
    }
    
    func touchMove(diff: CGFloat) {
        guard Int(abs(diff)) > 1 else { return }
        
        if diff > 0.0 {
            if calendarHeight.constant - diff > minHeight {
                // up
                calendarHeight.constant -= diff
                if let vc = (self.VCpage.viewControllers?[safe: 0] as? VCCalendarMonth) {
                    let rate = ((calendarHeight.constant - minHeight) / (maxHeight - minHeight))
                    
                    for view in vc.dayViews {
                        view.changeAlpha(rate: rate)
                    }
                }
            } else {
                calendarHeight.constant = minHeight
            }
            layoutIfNeeded()
        } else {
            if calendarHeight.constant - diff < maxHeight {
                // down
                calendarHeight.constant -= diff
                if let vc = (self.VCpage.viewControllers?[safe: 0] as? VCCalendarMonth) {
                    let rate = ((calendarHeight.constant - minHeight) / (maxHeight - minHeight))
                    
                    for view in vc.dayViews {
                        view.changeAlpha(rate: rate)
                    }
                }
            } else {
                calendarHeight.constant = maxHeight
            }
        }
    }
    
    func touchEnd(diff: CGFloat) {
        let isUp: Bool = self.getUpDownStatus(diff: diff)
        self.touchEndAnimated(isUp: isUp)
    }
}
