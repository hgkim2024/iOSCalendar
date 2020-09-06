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
    let Body = VwCalendarBody()
    
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
        Body.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func displayUI() {
        addSubview(header)
        addSubview(Body)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: Global.headerHeight),
            
            Body.topAnchor.constraint(equalTo: header.bottomAnchor),
            Body.leadingAnchor.constraint(equalTo: leadingAnchor),
            Body.trailingAnchor.constraint(equalTo: trailingAnchor),
            Body.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
