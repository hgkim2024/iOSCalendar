//
//  CellAddItemSelectTime.swift
//  Schedule
//
//  Created by Asu on 2020/10/23.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class CellAddItemSelectTime: UITableViewCell {
    static let identifier: String = "CellAddItemSelectTime"
    
    let vwSelect = VwDateSelectDatePicker()
    private let vwDummy = UIView()
    var bottomSeparator: UIView? = nil
    
    var isStart: Bool = false {
        didSet {
            vwSelect.isStart = self.isStart
        }
    }
    
    var date: Date? = nil {
        didSet {
            guard let date = self.date else { return }
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: NamesOfNotification.setAddEventDate),
                object: nil,
                userInfo: ["date": date]
            )
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
        displayUI()
        bottomSeparator = contentView.addBottomSeparator()
        bottomSeparator?.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        vwSelect.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func displayUI() {
        contentView.addSubview(vwSelect)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 330.0),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            vwSelect.topAnchor.constraint(equalTo: contentView.topAnchor),
            vwSelect.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            vwSelect.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            vwSelect.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}


