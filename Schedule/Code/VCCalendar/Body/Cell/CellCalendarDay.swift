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
        vwRoot.layer.cornerRadius = 1
        vwRoot.backgroundColor = Theme.item.withAlphaComponent(0.1)
        
        vwEdge.translatesAutoresizingMaskIntoConstraints = false
        vwEdge.backgroundColor = Theme.item.withAlphaComponent(0.8)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = Theme.font
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: Global.headerFontSize)
    }
    
    func displayUI() {
        let topMargin: CGFloat = 1
        let leftMargin: CGFloat = 2
        let edge: CGFloat = 2.2
        
        addSubview(vwRoot)
        vwRoot.addSubview(vwEdge)
        vwRoot.addSubview(title)
        
        NSLayoutConstraint.activate([
            vwRoot.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
            vwRoot.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin),
            vwRoot.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftMargin),
            vwRoot.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topMargin),
            
            vwEdge.topAnchor.constraint(equalTo: vwRoot.topAnchor),
            vwEdge.leadingAnchor.constraint(equalTo: vwRoot.leadingAnchor),
            vwEdge.bottomAnchor.constraint(equalTo: vwRoot.bottomAnchor),
            vwEdge.widthAnchor.constraint(equalToConstant: edge),
            
            title.topAnchor.constraint(equalTo: vwRoot.topAnchor),
            title.leadingAnchor.constraint(equalTo: vwEdge.trailingAnchor, constant: leftMargin),
            title.bottomAnchor.constraint(equalTo: vwRoot.bottomAnchor),
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
            vwRoot.backgroundColor = Theme.item.withAlphaComponent(0.8)
        } else {
            // go to max
            title.isHidden = false
            vwEdge.isHidden = false
            vwRoot.backgroundColor = Theme.item.withAlphaComponent(0.1)
        }
    }
}
