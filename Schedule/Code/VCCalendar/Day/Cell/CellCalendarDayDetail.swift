//
//  CellCalendarDayDetail.swift
//  Schedule
//
//  Created by Asu on 2020/10/11.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class CellCalendarDayDetail: UITableViewCell {
    static let identifier: String = "CellCalendarDayDetail"
    
    let vwDot = UIView()
    let title = UILabel()
    
    let dotSize: CGFloat = 8
    
    private var beginPoint: CGPoint? = nil
    private var lastPoint: CGPoint? = nil
    
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
        isUserInteractionEnabled = true
        
        vwDot.translatesAutoresizingMaskIntoConstraints = false
        vwDot.layer.cornerRadius = dotSize / 2.0
        vwDot.backgroundColor = Theme.item.withAlphaComponent(0.8)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: Global.fontSize)
        title.textColor = Theme.font
        title.textAlignment = .left
        title.numberOfLines = 0
    }
    
    func displayUI() {
        let topMargin: CGFloat = 10.0
        let leftMargin: CGFloat = 35.0
        
        addSubview(vwDot)
        addSubview(title)
        
        NSLayoutConstraint.activate([
            vwDot.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            vwDot.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin),
            vwDot.widthAnchor.constraint(equalToConstant: dotSize),
            vwDot.heightAnchor.constraint(equalToConstant: dotSize),
            
            title.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topMargin),
            title.leadingAnchor.constraint(equalTo: vwDot.centerXAnchor, constant: leftMargin - 10.0),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftMargin)
        ])
    }
    
    // MARK: - Functions
    
    func setTitle(title: String) {
        self.title.text = title
    }
}
