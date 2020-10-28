//
//  VCCalendarDayDetailPage.swift
//  Schedule
//
//  Created by Asu on 2020/10/19.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VCCalendarDayDetailPage: UIPageViewController {
    weak var touchDelegate: CalendarTouchEventDelegate? = nil {
        didSet {
            (viewControllers?[safe: 0] as? VCCalendarDayDetail)?.touchDelegate = self.touchDelegate
        }
    }
    
    var date: Date = Date()
    
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
        
        let firstPage = VCCalendarDayDetail(date: date.startOfDay)
        firstPage.delegate = self
        firstPage.touchDelegate = touchDelegate
        
        setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
    }
    
    func setPageUI(vc: VCCalendarDayDetail, date: Date) {
        vc.weekdayLabel.setCalendarDayColor(weekday: date.weekday)
        vc.weekdayLabel.text = "\(date.day).\(vc.dayString[date.weekday])"
        
        vc.list = Item.getDayList(date: date)
    }
    
    // MARK: - Observer
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setUpPageUI),
            name: NSNotification.Name(rawValue: NamesOfNotification.selectedDayDetailNotification),
            object: nil
        )
    }
    
    @objc func setUpPageUI(_ notification: Notification) {
        guard
            let date = notification.userInfo?["date"] as? Date
        else {
                return
        }
        
        self.date = date
        let firstPage = VCCalendarDayDetail(date: date)
        firstPage.delegate = self
        firstPage.touchDelegate = touchDelegate
        
        setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension VCCalendarDayDetailPage: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let vc = viewController as? VCCalendarDayDetail
            else {
                return nil
        }
        let date = vc.date
        let prevVC = VCCalendarDayDetail(date: date.prevDay)
        prevVC.delegate = self
        prevVC.touchDelegate = touchDelegate
        return prevVC
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let vc = viewController as? VCCalendarDayDetail
            else {
                return nil
        }
        let date = vc.date
        let nextVC = VCCalendarDayDetail(date: date.nextDay)
        nextVC.delegate = self
        nextVC.touchDelegate = touchDelegate
        return nextVC
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let vc = pageViewController.viewControllers?[safe: 0] as? VCCalendarDayDetail
        else {
                return
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NamesOfNotification.moveCalendarMonth),
            object: nil,
            userInfo: ["date": vc.date]
        )
    }
}

// MARK: - CalendarTouchEventDelegate
extension VCCalendarDayDetailPage: CalendarTouchEventDelegate {
    
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
