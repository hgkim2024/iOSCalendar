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
    var weekday: Int = 2
    var todayFlag: Bool = false
    var date: Date? = nil
    
    var list: [Item]? = nil {
        didSet {
            setUpTableView()
            
            if !todayFlag &&  todayView != nil {
                removeTodayView()
            }
        }
    }
    
    let minHeight: CGFloat = 4
    let maxHeight: CGFloat = 17
    var isUp: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: Global.headerFontSize)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Theme.font
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: Global.calendarleftMargin),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Global.calendarleftMargin),
        ])
    }
    
    func setUpTableView() {
        removeTableView()
        guard self.list != nil else { return }
        
        tableView = UITableView(frame: .zero, style: .plain)
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
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 2),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        tableView.reloadData()
    }
    
    func removeTableView() {
        guard let tableView = tableView else { return }
        tableView.removeFromSuperview()
        self.tableView = nil
    }
    
    // MARK: - Functions
    
    func addRegister() {
        tableView?.register(CellCalendarDay.self, forCellReuseIdentifier: CellCalendarDay.identifier)
    }
    
    func setColor(weekday: Int, alpha: CGFloat = 1.0) {
        self.weekday = weekday
        
        switch weekday {
        case 1:
            label.textColor = Theme.sunday.withAlphaComponent(alpha)
        case 0, 7:
            label.textColor = Theme.saturday.withAlphaComponent(alpha)
        default:
            label.textColor = Theme.font.withAlphaComponent(alpha)
        }
    }
    
    func selectedDay() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.init(hexString: "#00cc00").withAlphaComponent(0.8).cgColor
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
        setColor(weekday: weekday)
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
    
    func changeCellStatus(isUp: Bool) {
        self.isUp = isUp
        tableView?.reloadData()
    }
}
