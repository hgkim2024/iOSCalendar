//
//  VCRoot.swift
//  Schedule
//
//  Created by Asu on 2020/09/03.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VCRoot: UIViewController {
    
    var calendar = VwCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        displayUI()
    }
    
    func setUpUI() {
        view.backgroundColor = Theme.rootBackground
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func displayUI() {
        let margin: CGFloat = Global.calendarMargin
        
        view.addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin),
            calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin),
            calendar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}
