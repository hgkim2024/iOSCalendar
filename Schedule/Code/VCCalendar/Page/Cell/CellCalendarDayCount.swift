//
//  CellCalendarDayCount.swift
//  Schedule
//
//  Created by Asu on 2020/10/10.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class CellCalendarDayCount: UITableViewCell {
    static let identifier: String = "CellCalendarDayCount"
    
    let vwRoot = UIView()
    let title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        backgroundColor = .clear
        vwRoot.translatesAutoresizingMaskIntoConstraints = false
        vwRoot.clipsToBounds = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .lightGray
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: Global.weekdayFontSize - 2)
    }
    
    func displayUI() {
        let topMargin: CGFloat = 1.0
        let leftMargin: CGFloat = 3.0
        
        addSubview(vwRoot)
        vwRoot.addSubview(title)
        
        NSLayoutConstraint.activate([
            vwRoot.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
            vwRoot.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin),
            vwRoot.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftMargin),
            vwRoot.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topMargin),
            
            title.leadingAnchor.constraint(equalTo: vwRoot.leadingAnchor),
            title.centerYAnchor.constraint(equalTo: vwRoot.centerYAnchor),
        ])
    }
    
    // MARK: - Functions
    
    func setTitle(title: String) {
        self.title.text = title
    }
}
