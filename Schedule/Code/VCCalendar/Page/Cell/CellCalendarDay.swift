//
//  CellCalendarDay.swift
//  Schedule
//
//  Created by Asu on 2020/09/22.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class CellCalendarDay: UITableViewCell {
    static let identifier: String = "CellAddItemTitle"
    
    let vwRoot = UIView()
    let vwEdge = UIView()
    let title = UILabel()
    var isHoliday: Bool = false
    
    var titleLeadingAnchor: NSLayoutConstraint?
    var titleHolidayLeadingAnchor: NSLayoutConstraint?
    
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
        vwRoot.backgroundColor = Theme.item.withAlphaComponent(0.1)
        
        vwEdge.translatesAutoresizingMaskIntoConstraints = false
        vwEdge.backgroundColor = Theme.item.withAlphaComponent(0.8)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = Theme.font
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: Global.weekdayFontSize - 1)
    }
    
    func displayUI() {
        let topMargin: CGFloat = 1.0
        let leftMargin: CGFloat = 2.5
        let edge: CGFloat = 2.0
        
        addSubview(vwRoot)
        vwRoot.addSubview(vwEdge)
        vwRoot.addSubview(title)
        
        titleLeadingAnchor = title.leadingAnchor.constraint(equalTo: vwEdge.trailingAnchor, constant: leftMargin)
        
        titleHolidayLeadingAnchor = title.leadingAnchor.constraint(equalTo: vwRoot.leadingAnchor, constant: leftMargin)
        
        NSLayoutConstraint.activate([
            vwRoot.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
            vwRoot.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin),
            vwRoot.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftMargin),
            vwRoot.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topMargin),
            
            vwEdge.topAnchor.constraint(equalTo: vwRoot.topAnchor),
            vwEdge.leadingAnchor.constraint(equalTo: vwRoot.leadingAnchor),
            vwEdge.bottomAnchor.constraint(equalTo: vwRoot.bottomAnchor),
            vwEdge.widthAnchor.constraint(equalToConstant: edge),
            
            titleLeadingAnchor!,
            title.centerYAnchor.constraint(equalTo: vwRoot.centerYAnchor),
        ])
    }
    
    // MARK: - Functions
    
    func setTitle(title: String) {
        self.title.text = title
    }
    
    func setColor(isUp: Bool) {
        if isUp {
            // go to min
            title.isHidden = true
            vwEdge.isHidden = true
            if isHoliday {
                vwRoot.backgroundColor = Theme.sunday.withAlphaComponent(0.8)
            } else {
                vwRoot.backgroundColor = Theme.item.withAlphaComponent(0.8)
            }
        } else {
            // go to max
            title.isHidden = false
            if isHoliday {
                vwEdge.isHidden = true
                title.textColor = Theme.sunday
                titleLeadingAnchor?.isActive = false
                titleHolidayLeadingAnchor?.isActive = true
                vwRoot.backgroundColor = Theme.sunday.withAlphaComponent(0.1)
            } else {
                vwEdge.isHidden = false
                title.textColor = Theme.font
                titleLeadingAnchor?.isActive = true
                titleHolidayLeadingAnchor?.isActive = false
                vwRoot.backgroundColor = .clear
            }
        }
    }
    
    func setHoliday(isHoliday: Bool) {
        self.isHoliday = isHoliday
    }
}
