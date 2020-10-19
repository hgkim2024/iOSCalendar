//
//  VCCalendarMonthPage.swift
//  Schedule
//
//  Created by Asu on 2020/09/07.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VCCalendarMonthPage: UIPageViewController {
    
    weak var touchDelegate: CalendarTouchEventDelegate? = nil
    
    var isUp: Bool = false {
        didSet {
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: NamesOfNotification.calendarIsUp),
                object: nil,
                userInfo: ["isUp": self.isUp]
            )
        }
    }
    
    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey : Any]? = nil
    ) {
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: navigationOrientation,
            options: options
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        addObserver()
    }
    
    func setUpUI() {
        delegate = self
        dataSource = self
        
        let date = Date().startOfMonth
        let firstPage = VCCalendarMonth(date: date)
        firstPage.delegate = self
        
        setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
        
        postTitleNotification(date.dateToString())
    }
    
    // MARK: - Functions
    
    func postTitleNotification(_ title: String) {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NamesOfNotification.setCalendarTitle),
            object: nil,
            userInfo: ["title": title]
        )
    }
    
    func moveDay(moveDate: Date) {
        guard let curDate = (viewControllers?[safe: 0] as? VCCalendarMonth)?.getDate() else { return }
        
        guard curDate.month != moveDate.month else { return }
        
        let date = moveDate.startOfMonth
        let firstPage = VCCalendarMonth(date: date)
        firstPage.delegate = self
        firstPage.isUp = self.isUp
        firstPage.initSelectedDate = moveDate.startOfDay
        
        postTitleNotification(date.dateToString())
        var direction: NavigationDirection
        var animated: Bool = true
        if view.bounds.size.height >= VwCalendar.getMaxCalendarHeight() {
            animated = false
            touchDelegate?.touchBegin()
            touchDelegate?.touchEnd(diff: 30)
        }
        
        if curDate < moveDate {
            direction = .forward
        } else {
            direction = .reverse
        }
        
        setViewControllers([firstPage], direction: direction, animated: animated, completion: nil)
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceivedAddNotification),
            name: NSNotification.Name(rawValue: NamesOfNotification.refreshCalendar),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceivedMoveCalendarMonth),
            name: NSNotification.Name(rawValue: NamesOfNotification.moveCalendarMonth),
            object: nil
        )
    }
    
    @objc func didReceivedAddNotification() {
        viewControllers?[safe: 0]?.viewWillAppear(false)
    }
    
    @objc func didReceivedMoveCalendarMonth(_ notification: Notification) {
        guard let date = notification.userInfo?["date"] as? Date
        else {
                return
        }
        
        moveDay(moveDate: date)
    }
    
    func setDataSource(isOn: Bool) {
        if isOn {
            dataSource = self
        } else {
            dataSource = nil
        }
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension VCCalendarMonthPage: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let vc = viewController as? VCCalendarMonth
            else {
                return nil
        }
        let date = vc.getDate()
        let prevVC = VCCalendarMonth(date: date.prevMonth)
        prevVC.isUp = self.isUp
        prevVC.delegate = self
        return prevVC
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let vc = viewController as? VCCalendarMonth
            else {
                return nil
        }
        let date = vc.getDate()
        let nextVC = VCCalendarMonth(date: date.nextMonth)
        nextVC.isUp = self.isUp
        nextVC.delegate = self
        return nextVC
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let vc = pageViewController.viewControllers?[safe: 0] as? VCCalendarMonth
        else {
                return
        }
        postTitleNotification(vc.getDate().dateToString())
    }
}


// MARK: - CalendarTouchEventDelegate
extension VCCalendarMonthPage: CalendarTouchEventDelegate {
    
    func touchBegin() {
        touchDelegate?.touchBegin()
        dataSource = nil
    }
    
    func touchMove(diff: CGFloat) {
        touchDelegate?.touchMove(diff: diff)
    }
    
    func touchEnd(diff: CGFloat) {
        touchDelegate?.touchEnd(diff: diff)
        dataSource = self
    }
}
