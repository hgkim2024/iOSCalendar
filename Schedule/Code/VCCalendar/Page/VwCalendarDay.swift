//
//  VwCalendarDay.swift
//  Schedule
//
//  Created by Asu on 2020/09/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VwCalendarDay: UIView {
    weak var vcMonthCalendar: VCCalendarMonth? = nil
    
    let label = UILabel()
    var minTableView: UITableView? = nil
    var maxTableView: UITableView? = nil
    var todayView: UIView? = nil
    
    var todayFlag: Bool = false
    var date: Date? = nil {
        didSet {
            guard let date = self.date else { return }
            label.setCalendarDayColor(weekday: date.weekday)
        }
    }
    
    var twoDayTitleList: [UILabel] = []
    
    var list: [Item]? = nil {
        didSet {
            setUpTableView()
            
            if !todayFlag &&  todayView != nil {
                removeTodayView()
            }
            
            if holidayList.count > 0 {
                label.setCalendarDayColor(weekday: 1)
            }
        }
    }
    
    var holidayList: [String] = []
    
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
        guard
            self.list != nil
                || holidayList.count > 0
        else { return }
        
        minTableView = UITableView(frame: .zero, style: .plain)
        guard let minTableView = minTableView else { return }
        minTableView.translatesAutoresizingMaskIntoConstraints = false
        minTableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        
        minTableView.separatorStyle = .none
        minTableView.isScrollEnabled = false
        minTableView.showsVerticalScrollIndicator = false
        minTableView.bounces = false
        
        minTableView.delegate = self
        minTableView.dataSource = self
        minTableView.backgroundColor = .clear
        minTableView.isUserInteractionEnabled = false

        minTableView.rowHeight = minHeight
        
        maxTableView = UITableView(frame: .zero, style: .plain)
        guard let maxTableView = maxTableView else { return }
        maxTableView.translatesAutoresizingMaskIntoConstraints = false
        maxTableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        
        maxTableView.separatorStyle = .none
        maxTableView.isScrollEnabled = false
        maxTableView.showsVerticalScrollIndicator = false
        maxTableView.bounces = false
        
        maxTableView.delegate = self
        maxTableView.dataSource = self
        maxTableView.backgroundColor = .clear
        maxTableView.isUserInteractionEnabled = false

        maxTableView.rowHeight = maxHeight
        
        changeAlpha(isUp: self.isUp)
        addRegister()
        
        addSubview(minTableView)
        addSubview(maxTableView)
        NSLayoutConstraint.activate([
            minTableView.topAnchor.constraint(equalTo: topAnchor, constant: Global.calendarleftMargin + Global.weekdayFontSize + 2),
            minTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            minTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            minTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            maxTableView.topAnchor.constraint(equalTo: topAnchor, constant: Global.calendarleftMargin + Global.weekdayFontSize + 2),
            maxTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            maxTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            maxTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        UIView.animate(withDuration: 0.0, animations: {
            minTableView.reloadData()
            maxTableView.reloadData()
        }, completion: { _ in
            self.setTwoDayAlpha(isUp: self.isUp)
        })
    }
    
    private func removeTableView() {
        guard
            let minTableView = minTableView,
            let maxTableView = maxTableView
        else { return }
        minTableView.removeFromSuperview()
        maxTableView.removeFromSuperview()
        self.minTableView = nil
        self.maxTableView = nil
    }
    
    // MARK: - Functions
    
    private func addRegister() {
        minTableView?.register(CellCalendarDay.self, forCellReuseIdentifier: CellCalendarDay.identifier)
        minTableView?.register(CellCalendarDayCount.self, forCellReuseIdentifier: CellCalendarDayCount.identifier)
        minTableView?.register(CellCanlendarTwoDay.self, forCellReuseIdentifier: CellCanlendarTwoDay.identifier)
        
        maxTableView?.register(CellCalendarDay.self, forCellReuseIdentifier: CellCalendarDay.identifier)
        maxTableView?.register(CellCalendarDayCount.self, forCellReuseIdentifier: CellCalendarDayCount.identifier)
        maxTableView?.register(CellCanlendarTwoDay.self, forCellReuseIdentifier: CellCanlendarTwoDay.identifier)
    }
    
    func setAlpha(alpha: CGFloat = 1.0) {
        self.alpha = alpha
    }
    
    func setTwoDayAlpha(isUp: Bool) {
        for title in twoDayTitleList {
            if isUp {
                title.alpha = 0.0
            } else {
                title.alpha = 1.0
            }
        }
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
        label.textColor = Theme.background
        
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
    
    func changeAlpha(isUp: Bool) {
        guard
            let minTableView = minTableView,
            let maxTableView = maxTableView
        else { return }
        if isUp {
            minTableView.alpha = 1.0
            maxTableView.alpha = 0.0
            for label in twoDayTitleList {
                label.alpha = 0.0
            }
        } else {
            minTableView.alpha = 0.0
            maxTableView.alpha = 1.0
            for label in twoDayTitleList {
                label.alpha = 1.0
            }
        }
    }
    
    func changeAlpha(rate: CGFloat) {
        guard
            let minTableView = minTableView,
            let maxTableView = maxTableView
        else { return }
        
        minTableView.alpha = 1 - rate
        maxTableView.alpha = rate
        for label in twoDayTitleList {
            label.alpha = rate
        }
    }
}
