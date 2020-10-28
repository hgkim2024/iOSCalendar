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
    
    let btnTitle = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
        setUpUI()
        displayUI()
    }
    
    func setUpUI() {
        view.backgroundColor = Theme.background
        
        calendar = VwCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.addEventButton.button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        guard let bar = navigationController?.navigationBar else { return }
        bar.isTranslucent = true
        bar.setBackgroundImage(UIImage(), for: .default)
        bar.shadowImage = UIImage()
        
        btnTitle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        btnTitle.setTitleColor(Theme.font, for: .normal)
//        let image = UIImage(systemName: "chevron.down")
//        btnTitle.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
//        btnTitle.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
        btnTitle.tintColor = Theme.font
//        btnTitle.semanticContentAttribute = .forceRightToLeft
        navigationItem.titleView = btnTitle
        
        btnTitle.addTarget(self, action: #selector(tapTitle), for: .touchUpInside)
    }
    
    func displayUI() {
        view.addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceivedDayCalendarDidSelectCellNotification),
            name: NSNotification.Name(rawValue: NamesOfNotification.dayCalendarDidSelectCell),
            object: nil
        )
    }
    
    // MARK: - Functions
    @objc func didReceivedTitleNotification(_ notification: Notification) {
        guard let title = notification.userInfo?["title"] as? String
        else {
                return
        }
        self.btnTitle.setTitle(title, for: .normal)
    }
    
    @objc func didReceivedDayDateNotification(_ notification: Notification) {
        guard let date = notification.userInfo?["date"] as? Date
        else {
                return
        }
        
        selectedDate = date
    }
    
    @objc func didReceivedDayCalendarDidSelectCellNotification(_ notification: Notification) {
        guard let item = notification.userInfo?["item"] as? Item
        else {
                return
        }
        
        presentVCAddItem(date: Date(), item: item)
    }
    
    @objc func tapTitle() {
        
//        if var transform = self.btnTitle.imageView?.transform {
//            UIView.animate(withDuration:0.3, animations: { () -> Void in
//                if  transform == .identity {
//                    transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.999))
//                } else {
//                    transform = .identity
//                }
//            })
//            view.layoutIfNeeded()
//        }
        if calendar.vwDatePicker.isHidden {
            calendar.showDatePicker()
        }
    }
    
    @objc func addTapped(_ sender: Any) {
        guard let date = selectedDate else { return }
        presentVCAddItem(date: date)
    }
    
    func presentVCAddItem(date: Date, item: Item? = nil) {
        let vc: VCAddItem
        if item == nil {
            vc = VCAddItem(item: item, startDate: date, endDate: date)
        } else {
            vc = VCAddItem(item: item, startDate: Date(timeIntervalSince1970: item!.startDate), endDate: Date(timeIntervalSince1970: item!.endDate))
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isModalInPresentation = true
        nvc.presentationController?.delegate = vc
        present(nvc, animated: true, completion: nil)
    }
}


