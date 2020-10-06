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
            guard let vcs = viewControllers else { return }
            for vc in vcs {
                if let vc = vc as? VCCalendarMonth {
                    vc.isUp = self.isUp
                }
            }
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
