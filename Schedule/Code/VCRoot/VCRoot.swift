//
//  VCRoot.swift
//  Schedule
//
//  Created by Asu on 2020/09/03.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VCRoot: UIViewController {
    
    var calendar: VwCalendar!
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
        setUpUI()
        displayUI()
    }
    
    func setUpUI() {
        view.backgroundColor = Theme.rootBackground
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add]
        
        calendar = VwCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func displayUI() {
        let margin: CGFloat = Global.calendarMargin
        
        view.addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin),
            calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin),
            calendar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceivedTitleNotification),
            name: NSNotification.Name(rawValue: NamesOfNotification.setCalendarTitle),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceivedDayDateNotification),
            name: NSNotification.Name(rawValue: NamesOfNotification.selectedDayToPostDate),
            object: nil
        )
    }
    
    // MARK: - Functions
    @objc func didReceivedTitleNotification(_ notification: Notification) {
        guard let title = notification.userInfo?["title"] as? String
        else {
                return
        }
        
        self.title = title
    }
    
    @objc func didReceivedDayDateNotification(_ notification: Notification) {
        guard let date = notification.userInfo?["date"] as? Date
        else {
                return
        }
        
        selectedDate = date
        print("selected Date: \(date)")
    }
    
    @objc func addTapped(_ sender: Any) {
        guard let date = selectedDate else { return }
        let vc = VCAddItem(date: date)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isModalInPresentation = true
        nvc.presentationController?.delegate = vc
        present(nvc, animated: true, completion: nil)
    }
}


