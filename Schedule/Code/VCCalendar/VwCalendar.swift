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
    
    let header = VwCalendarHeader()
    let body = VCCalendarMonthPage()
    
    var minHeight: CGFloat = 300.0
    var maxHeight: CGFloat = 812.0
    let weight: CGFloat = 20.0
    
    var swipeUp: UISwipeGestureRecognizer?
    var swipeDown: UISwipeGestureRecognizer?
    
    // true: up, false: down
    var upDownStatus: Bool = true
    
    var calendarHeight: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        minHeight = getMaxCalendarHeight() / 2.0
        maxHeight = getMaxCalendarHeight()
        
        header.translatesAutoresizingMaskIntoConstraints = false
        body.view.translatesAutoresizingMaskIntoConstraints = false
        body.touchDelegate = self
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(sender:)))
        swipeUp!.direction = .up
        
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(sender:)))
        swipeDown!.direction = .down
        
        addGestureRecognizer(swipeUp!)
        addGestureRecognizer(swipeDown!)
    }
    
    func displayUI() {
        addSubview(header)
        addSubview(body.view)
        
        calendarHeight = body.view.heightAnchor.constraint(equalToConstant: maxHeight)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: Global.headerHeight),
            
            body.view.topAnchor.constraint(equalTo: header.bottomAnchor, constant: -5),
            body.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            body.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendarHeight,
        ])
    }
    
    // MARK: - Functions
    
    private func getMaxCalendarHeight() -> CGFloat {
        let window = Global.getKeyWindow()
        
        let totalHeihgt = UIScreen.main.bounds.height
        let topSafeArea = (window?.safeAreaInsets.top ?? 0.0) + (window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + 30.0
        
        let bottomSafeArea = window?.safeAreaInsets.bottom ?? 0.0
        
        return totalHeihgt - topSafeArea - bottomSafeArea
    }
    
    private func changeDayCalendarHeight(isUp: Bool) {
        guard let vc = (self.body.viewControllers?[safe: 0] as? VCCalendarMonth) else { return }
        
        for view in vc.dayViews {
            view.changeHeight(isUp: isUp)
        }
    }
    
    private func changeDayCellStatus(isUp: Bool) {
        guard let vc = (self.body.viewControllers?[safe: 0] as? VCCalendarMonth) else { return }
        for view in vc.dayViews {
            view.changeCellStatus(isUp: isUp)
        }
    }
    
    private func getUpDownStatus(diff: CGFloat) -> Bool {
        let weight: CGFloat = self.weight
        
        if self.upDownStatus {
            if diff > weight ||
                ((self.calendarHeight.constant - self.minHeight) < (self.maxHeight - self.minHeight) * (2.0/3.0))  {
                return true
                
            } else {
                return false
            }
        } else {
            if diff < -weight ||
                ((self.calendarHeight.constant - self.minHeight) > (self.maxHeight - self.minHeight) / 3.0) {
                return false
            } else {
                return true
            }
        }
    }
    
    private func touchEndAnimated(isUp: Bool) {
        body.isUp = isUp
        
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
        })
    }
    
    @objc private func swipeAction(sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            touchEndAnimated(isUp: true)
        } else if sender.direction == .down {
            self.changeDayCellStatus(isUp: false)
            self.layoutIfNeeded()
            touchEndAnimated(isUp: false)
        }
    }
}


extension VwCalendar: CalendarTouchEventDelegate {
    
    func touchBegin() {
        upDownStatus = (calendarHeight.constant > minHeight) ? true : false
        
        removeGestureRecognizer(swipeUp!)
        removeGestureRecognizer(swipeDown!)
    }
    
    func touchMove(diff: CGFloat) {
        guard abs(Int(diff)) > 1 else {
            return
        }
        
        if diff > 0.0 {
            if calendarHeight.constant - diff > minHeight {
                // up
                calendarHeight.constant -= diff
                if let vc = (self.body.viewControllers?[safe: 0] as? VCCalendarMonth) {
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
                if let vc = (self.body.viewControllers?[safe: 0] as? VCCalendarMonth) {
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
        
        self.touchEndAnimated(isUp: isUp)
        addGestureRecognizer(swipeUp!)
        addGestureRecognizer(swipeDown!)
    }
}
