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
    
    func moveToday(date: Date) {
        let curDate = Date().startOfMonth
        let vcDate = date.startOfMonth
        
        guard curDate != vcDate else { return }
        
        let date = Date().startOfMonth
        let firstPage = VCCalendarMonth(date: date)
        firstPage.delegate = self
        
        postTitleNotification(date.dateToString())
        
        if curDate > vcDate {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        } else {
            setViewControllers([firstPage], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceivedAddNotification),
            name: NSNotification.Name(rawValue: NamesOfNotification.refreshCalendar),
            object: nil
        )
    }
    
    @objc func didReceivedAddNotification() {
        viewControllers?[safe: 0]?.viewWillAppear(false)
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
