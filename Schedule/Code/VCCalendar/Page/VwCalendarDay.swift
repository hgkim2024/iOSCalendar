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
    var tableView: UITableView? = nil
    var todayView: UIView? = nil
    
    var todayFlag: Bool = false
    var date: Date? = nil {
        didSet {
            guard let date = self.date else { return }
            label.setCalendarDayColor(weekday: date.weekday % 7)
        }
    }
    
    var tableViewAlpha: CGFloat = 1.0
    
    var list: [Item]? = nil {
        didSet {
            setUpTableView()
            
            if !todayFlag &&  todayView != nil {
                removeTodayView()
            }
        }
    }
    
    let minHeight: CGFloat = 4
    let maxHeight: CGFloat = 16
    var isUp: Bool = false
    var count: Int = 0
    var rowHeight: CGFloat = 16
    
    convenience init(row: Int) {
        self.init(frame: .zero)
        let vwDayMaxHeight =
            (VwCalendar.getMaxCalendarHeight() / CGFloat(row))
                - (Global.calendarleftMargin
                    + Global.weekdayFontSize
                    + 2
                )
        self.count = Int((vwDayMaxHeight - 12.0) / self.maxHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: Global.weekdayFontSize)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Theme.font
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: Global.calendarleftMargin - 2.0),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Global.calendarleftMargin),
        ])
    }
    
    private func setUpTableView() {
        removeTableView()
        guard self.list != nil else { return }
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.alpha = tableViewAlpha
        guard let tableView = tableView else { return }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = false

        if isUp {
            tableView.rowHeight = minHeight
        } else {
            tableView.rowHeight = maxHeight
        }
        
        addRegister()
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: Global.calendarleftMargin + Global.weekdayFontSize + 2),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        tableView.reloadData()
    }
    
    private func removeTableView() {
        guard let tableView = tableView else { return }
        tableView.removeFromSuperview()
        self.tableView = nil
    }
    
    // MARK: - Functions
    
    private func addRegister() {
        tableView?.register(CellCalendarDay.self, forCellReuseIdentifier: CellCalendarDay.identifier)
        tableView?.register(CellCalendarDayCount.self, forCellReuseIdentifier: CellCalendarDayCount.identifier)
    }
    
    func setAlpha(alpha: CGFloat = 1.0) {
        self.alpha = alpha
    }
    
    func selectedDay() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.init(hexString: "#00cc00").withAlphaComponent(0.8).cgColor
        
        guard let date = self.date else { return }
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NamesOfNotification.selectedDayToPostDate),
            object: nil,
            userInfo: ["date": date]
        )
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NamesOfNotification.selectedDayDetailNotification),
            object: nil,
            userInfo: ["date": date]
        )
    }
    
    func deselectedDay() {
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }
    
    func setTodayView() {
        todayFlag = true
        label.textColor = .white
        
        let size: CGFloat = label.font.pointSize + 6
        todayView = UIView()
        guard let todayView = todayView else { return }
        todayView.translatesAutoresizingMaskIntoConstraints = false
        todayView.layer.cornerRadius = size / 2.0
        todayView.backgroundColor = Theme.today
        
        addSubview(todayView)
        NSLayoutConstraint.activate([
            todayView.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            todayView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            todayView.widthAnchor.constraint(equalToConstant: size),
            todayView.heightAnchor.constraint(equalToConstant: size)
        ])
        sendSubviewToBack(todayView)
    }
    
    func removeTodayView() {
        todayFlag = false
        todayView?.removeFromSuperview()
        todayView = nil
    }
    
    func setText(text: String) {
        label.text = text
    }
    
    func changeHeight(isUp: Bool) {
        guard let tableView = tableView else { return }
        if isUp {
            tableView.rowHeight = minHeight
            tableView.beginUpdates()
            tableView.endUpdates()
        } else {
            tableView.rowHeight = maxHeight
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func changeHeight(isUp: Bool, rate: CGFloat) {
        guard let tableView = tableView else { return }
        
        if isUp {
            tableView.rowHeight = minHeight + ((maxHeight - minHeight) * rate)
        } else {
            tableView.rowHeight = minHeight + ((maxHeight - minHeight) * rate)
            if self.isUp != isUp {
                self.isUp = isUp
                tableView.reloadData()
                tableView.layoutIfNeeded()
            }
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func touchEndChangeHeight(isUp: Bool, rate: CGFloat, last: Bool = false) {
        guard let tableView = tableView else { return }
        
        if isUp {
            if tableView.rowHeight <= minHeight {
                tableView.rowHeight = minHeight
            } else {
                tableView.rowHeight -= ((maxHeight - minHeight) - (maxHeight - rowHeight)) * rate
            }
        } else {
            if tableView.rowHeight >= maxHeight {
                tableView.rowHeight = maxHeight
            } else {
                tableView.rowHeight += ((maxHeight - minHeight) - (rowHeight - minHeight)) * rate
                if self.isUp != isUp {
                    self.isUp = isUp
                    tableView.reloadData()
                    tableView.layoutIfNeeded()
                }
            }
        }
        
        if last {
            tableView.rowHeight = isUp ? minHeight : maxHeight
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func saveRowHeight() {
        guard let tableView = self.tableView else { return }
        self.rowHeight = tableView.rowHeight
    }
    
    func changeCellStatus(isUp: Bool) {
        self.isUp = isUp
        tableView?.reloadData()
    }
}
