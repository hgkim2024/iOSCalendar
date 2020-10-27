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
        
        if title == "시작".localized {
            addStartObserver()
        } else {
            addEndObserver()
        }
    }
    
    func addStartObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setStartDate),
            name: NSNotification.Name(rawValue: NamesOfNotification.setAddEventStartDate),
            object: nil
        )
    }
    
    func addEndObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setEndDate),
            name: NSNotification.Name(rawValue: NamesOfNotification.setAddEventEndDate),
            object: nil
        )
    }
    
    @objc func setStartDate(_ notification: Notification) {
        guard
            let date = notification.userInfo?["date"] as? Date
        else {
                return
        }
        
        if title.text == "시작".localized {
            self.date = date
            delegate?.setStartDate(date: date)
            
            guard let endDate = delegate?.getEndDate() else { return }
            if date > endDate {
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: NamesOfNotification.setAddEventEndDate),
                    object: nil,
                    userInfo: ["date": date]
                )
            }
        }
    }
    
    @objc func setEndDate(_ notification: Notification) {
        guard
            let date = notification.userInfo?["date"] as? Date
        else {
                return
        }
        
        if title.text == "종료".localized {
            self.date = date
            delegate?.setEndDate(date: date)
        
            guard let startDate = delegate?.getStratDate() else { return }
            if date < startDate {
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: NamesOfNotification.setAddEventStartDate),
                    object: nil,
                    userInfo: ["date": date]
                )
            }
        }
    }
}

