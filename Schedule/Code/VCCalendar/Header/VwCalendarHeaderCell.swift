//
//  VwCalendarHeaderCell.swift
//  Schedule
//
//  Created by Asu on 2020/09/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VwCalendarHeaderCell: UICollectionViewCell {
    static let identifier: String = "VwCalendarHeaderCell"
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        displayUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Global.headerFontSize)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Theme.font
    }
    
    func displayUI() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Global.calendarleftMargin),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func setColor(weekday: Int) {
        switch weekday {
        case 1:
            label.textColor = Theme.sunday
        case 7:
            label.textColor = Theme.saturday
        default:
            label.textColor = Theme.font
        }
    }
    
    func setText(text: String) {
        label.text = text
    }
}
