//
//  CellAddItemTime.swift
//  Schedule
//
//  Created by Asu on 2020/10/23.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class CellAddItemTime: UITableViewCell {
    static let identifier: String = "CellAddItemTime"
    
    weak var delegate: AddItemDateDelegate?
    
    private let title = UILabel()
    private let timeLabel = UILabel()
    
    var topSeparator: UIView? = nil
    var bottomSeparator: UIView? = nil
    
    private var dateInitFlag = true
    var date: Date? = nil {
        didSet {
            if let date = self.date {
                timeLabel.text = date.LocaleYYYYMMDDToString()
                dateInitFlag = false
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
        displayUI()
        topSeparator = contentView.addTopSeparator()
        bottomSeparator = contentView.addBottomSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: Global.fontSize + 2)
        title.textAlignment = .left
        title.textColor = Theme.font
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.systemFont(ofSize: Global.fontSize)
        timeLabel.textAlignment = .right
        timeLabel.textColor = Theme.font
    }
    
    private func displayUI() {
        let topMargin: CGFloat = 12
        let leftMargin: CGFloat = 15
        
        addSubview(title)
        addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin),
            title.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topMargin),
            
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftMargin),
            timeLabel.topAnchor.constraint(equalTo: title.topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: title.bottomAnchor),
        ])
    }
    
    // MARK: - Functions
    
    func setTitle(title: String) {
        self.title.text = title
    }
}

