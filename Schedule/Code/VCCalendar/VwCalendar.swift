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
    let vwToday = vwMoveToday()
    
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
        
        calendarHeight = VCpage.view.heightAnchor.constraint(equalToConstant: maxHeight)
        
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
    
    private func changeDayCalendarHeight(isUp: Bool) {
        guard let vc = (self.VCpage.viewControllers?[safe: 0] as? VCCalendarMonth) else { return }
        
        for view in vc.dayViews {
            view.changeHeight(isUp: isUp)
        }
    }
    
    private func changeDayCellStatus(isUp: Bool) {
        guard let vc = (self.VCpage.viewControllers?[safe: 0] as? VCCalendarMonth) else { return }
        for view in vc.dayViews {
            view.changeCellStatus(isUp: isUp)
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
    
    // TODO: - 아이폰 X 이전 폰에서 현재 swipeAnimated 함수 사용 시 버벅거린다면 아래 함수 사용 할 것
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
            if isUp {
                self.changeDayCellStatus(isUp: isUp)
            }
            self.addGestureRecognizer(self.swipeUp!)
            self.addGestureRecognizer(self.swipeDown!)
            self.VCDayPage.view.isHidden = !isUp
        })
    }
    
    private func swipeAnimated(isUp: Bool) {
        VCpage.isUp = isUp
        let count: Int = self.animationFrame
        
        VCpage.setDataSource(isOn: false)
        if let vc = (self.VCpage.viewControllers?[safe: 0] as? VCCalendarMonth) {
            for view in vc.dayViews {
                view.saveRowHeight()
            }
        }
        recursiveSwipeAnimations(count: count, isUp: isUp, totalCount: count, height: self.calendarHeight.constant)
    }
    
    private func recursiveSwipeAnimations(count: Int, isUp: Bool, totalCount: Int, height: CGFloat) {
        if count < 0 {
            if isUp {
                self.changeDayCellStatus(isUp: isUp)
            }
            VCpage.setDataSource(isOn: true)
            self.addGestureRecognizer(self.swipeUp!)
            self.addGestureRecognizer(self.swipeDown!)
            VCDayPage.view.isHidden = !isUp
            return
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.003) {
                let rate = 1.0 / CGFloat(totalCount)
                
                if isUp {
                    let diff = (((self.maxHeight - self.minHeight) - (self.maxHeight - height)) * rate)
                    if self.calendarHeight.constant - diff <= self.minHeight {
                        self.calendarHeight.constant = self.minHeight
                    } else {
                        self.calendarHeight.constant -= diff
                    }
                } else {
                    let diff = (((self.maxHeight - self.minHeight) - (height - self.minHeight)) * rate)
                    if self.calendarHeight.constant + diff >= self.maxHeight {
                        self.calendarHeight.constant = self.maxHeight
                    } else {
                        self.calendarHeight.constant += diff
                    }
                }
                
                if let vc = (self.VCpage.viewControllers?[safe: 0] as? VCCalendarMonth) {
                    for view in vc.dayViews {
                        view.touchEndChangeHeight(isUp: isUp, rate: rate, last: count == 0)
                    }
                }
                
                self.layoutIfNeeded()
                self.recursiveSwipeAnimations(count: count - 1, isUp: isUp, totalCount: totalCount, height: height)
            }
        }
    }
    
    @objc private func swipeAction(sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            swipeAnimated(isUp: true)
//            touchEndAnimated(isUp: true)
        } else if sender.direction == .down {
            self.changeDayCellStatus(isUp: false)
            self.layoutIfNeeded()
//            touchEndAnimated(isUp: false)
            swipeAnimated(isUp: false)
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
        if diff > 0.0 {
            if calendarHeight.constant - diff > minHeight {
                // up
                calendarHeight.constant -= diff
                if let vc = (self.VCpage.viewControllers?[safe: 0] as? VCCalendarMonth) {
                    let rate = ((calendarHeight.constant - minHeight) / (maxHeight - minHeight))
                    
                    for view in vc.dayViews {
                        view.changeHeight(isUp: true, rate: rate)
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
                        view.changeHeight(isUp: false, rate: rate)
                    }
                }
            } else {
                calendarHeight.constant = maxHeight
            }
        }
    }
    
    func touchEnd(diff: CGFloat) {
        let isUp: Bool = self.getUpDownStatus(diff: diff)
        if !isUp {
            self.changeDayCellStatus(isUp: isUp)
            self.layoutIfNeeded()
        }
        
//        self.touchEndAnimated(isUp: isUp)
        self.swipeAnimated(isUp: isUp)
    }
}
