//
//  VwCalendarDay.swift
//  Schedule
//
//  Created by Asu on 2020/09/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VwCalendarDay: UIView {
    let label = UILabel()
    // TODO: - 일과 등록 시 표현할 TableView
//    var tableView: UITableView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Global.headerFontSize)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Theme.font
        
        // TODO: - 일과 표기 뷰 추가
    }
    
    func displayUI() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: Global.calendarleftMargin),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Global.calendarleftMargin),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // TODO: - 일과 표기 뷰 추가
        ])
    }
    
    // MARK: - Functions
    
    func setColor(weekday: Int, alpha: CGFloat = 1.0) {
        switch weekday {
        case 1:
            label.textColor = Theme.sunday.withAlphaComponent(alpha)
        case 0, 7:
            label.textColor = Theme.saturday.withAlphaComponent(alpha)
        default:
            label.textColor = Theme.font.withAlphaComponent(alpha)
        }
    }
    
    func setText(text: String) {
        label.text = text
    }
}
