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
    let Body = VCCalendarMonthPage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        header.translatesAutoresizingMaskIntoConstraints = false
        Body.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func displayUI() {
        addSubview(header)
        addSubview(Body.view)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: Global.headerHeight),
            
            Body.view.topAnchor.constraint(equalTo: header.bottomAnchor, constant: -5),
            Body.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            Body.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            Body.view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
