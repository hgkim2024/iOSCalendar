//
//  VwCalendarDayDetail.swift
//  Schedule
//
//  Created by Asu on 2020/10/11.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit
import RealmSwift
import RxCocoa
import RxSwift

class VCCalendarDayDetail: UIViewController {
    
    let dayString: [String] = [
        "토".localized,
        "일".localized,
        "월".localized,
        "화".localized,
        "수".localized,
        "목".localized,
        "금".localized,
    ]
    
    let weekdayLabel = UILabel()
    let emptyLabel = UILabel()
    let separator = UIView()
    let downArrow = UIImageView()
    let vwdownArrowDummy = UIView()
    var tableView: UITableView? = nil
    var date: Date = Date()
    
    weak var delegate: CalendarTouchEventDelegate? = nil
    weak var touchDelegate: CalendarTouchEventDelegate? = nil
    
    private var beginPoint: CGPoint? = nil
    private var lastPoint: CGPoint? = nil
    
    var preScrollY: CGFloat = 0
    var isScroll: Bool = false
    
    var list: [Item]? = nil {
        didSet {
            setUpTableView()
        }
    }
    
    var holidayList: [String] = []
    
    convenience init(date: Date) {
        self.init(nibName:nil, bundle:nil)
        self.date = date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
        setUpLabel()
        setHoliday()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        weekdayLabel.setCalendarDayColor(weekday: date.weekday)
        weekdayLabel.text = "\(date.day).\(dayString[date.weekday % 7])"
        
        setHoliday()
        list = Item.getDayList(date: date)
    }
    
    private func setUpLabel() {
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.05)
        
        weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
        weekdayLabel.font = UIFont.boldSystemFont(ofSize: Global.weekdayBigFontSize)
        weekdayLabel.textAlignment = .left
        weekdayLabel.adjustsFontSizeToFitWidth = true
        weekdayLabel.textColor = Theme.font
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.textAlignment = .left
        emptyLabel.adjustsFontSizeToFitWidth = true
        emptyLabel.textColor = .lightGray
        emptyLabel.text = "일정이 없습니다.".localized
        emptyLabel.font = UIFont.systemFont(ofSize: Global.weekdayBigFontSize)
        emptyLabel.isHidden = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = Theme.separator
        
        downArrow.translatesAutoresizingMaskIntoConstraints = false
        downArrow.image = UIImage(systemName: "chevron.compact.down")?.withRenderingMode(.alwaysTemplate)
        downArrow.tintColor = Theme.separator
        downArrow.isUserInteractionEnabled = true
        
        vwdownArrowDummy.translatesAutoresizingMaskIntoConstraints = false
        vwdownArrowDummy.backgroundColor = .clear
        vwdownArrowDummy.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchDownArrow))
        vwdownArrowDummy.addGestureRecognizer(tap)
        
        view.addSubview(weekdayLabel)
        view.addSubview(emptyLabel)
        view.addSubview(separator)
        view.addSubview(downArrow)
        view.addSubview(vwdownArrowDummy)
        
        let margin: CGFloat = Global.calendarleftMargin + 5
        
        NSLayoutConstraint.activate([
            weekdayLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: margin),
            weekdayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            separator.topAnchor.constraint(equalTo: view.topAnchor),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: Global.separatorSize),
            
            downArrow.topAnchor.constraint(equalTo: view.topAnchor),
            downArrow.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downArrow.widthAnchor.constraint(equalToConstant: 40.0),
            downArrow.heightAnchor.constraint(equalToConstant: 30.0),
            
            vwdownArrowDummy.centerXAnchor.constraint(equalTo: downArrow.centerXAnchor),
            vwdownArrowDummy.centerYAnchor.constraint(equalTo: downArrow.centerYAnchor),
            vwdownArrowDummy.widthAnchor.constraint(equalToConstant: 60.0),
            vwdownArrowDummy.heightAnchor.constraint(equalToConstant: 45.0),
        ])
    }
    
    private func setUpTableView() {
        removeTableView()
        guard self.list != nil else {
            emptyLabel.isHidden = false
            return
        }
        
        emptyLabel.isHidden = true
        tableView = UITableView(frame: .zero, style: .plain)
        guard let tableView = tableView else { return }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delaysContentTouches = false
        
        addRegister()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: weekdayLabel.bottomAnchor, constant: 10.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.reloadData()
    }
    
    // MARK: - Functions
    private func removeTableView() {
        guard let tableView = tableView else { return }
        tableView.removeFromSuperview()
        self.tableView = nil
    }
    
    private func addRegister() {
        tableView?.register(CellCalendarDayDetail.self, forCellReuseIdentifier: CellCalendarDayDetail.identifier)
    }
    
    private func setHoliday() {
        holidayList.removeAll()
        if let solarHoliday = Holiday.solarDictionary[date.dateToMonthDayString()] {
            holidayList.append(solarHoliday)
        }
        
        if let lunarHoliday = Holiday.lunarDictionary[date.dateToLunarString()] {
            holidayList.append(lunarHoliday)
        }
        
        if holidayList.count > 0 {
            weekdayLabel.textColor = Theme.sunday
        }
    }
    
    @objc private func touchDownArrow(_ sender: UITapGestureRecognizer) {
        delegate?.touchBegin()
        delegate?.touchEnd(diff: -30.0)
    }
    
    // MARK: - Touch Event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.beginPoint = touch.location(in: touch.view)
        
        delegate?.touchBegin()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            let beginPoint = self.beginPoint
            else { return }
        
        lastPoint = touch.location(in: touch.view)
        let y = beginPoint.y - lastPoint!.y
        delegate?.touchMove(diff: y)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEnd()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEnd()
    }
    
    func touchEnd() {
        guard let beginPoint = self.beginPoint else { return }
        guard let lastPoint = self.lastPoint else { return }
        let y = beginPoint.y - lastPoint.y
        delegate?.touchEnd(diff: y)
        self.beginPoint = nil
    }
    
    // MARK: - Observer
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceivedAddNotification),
            name: NSNotification.Name(rawValue: NamesOfNotification.refreshCalendar),
            object: nil
        )
    }
    
    @objc func didReceivedAddNotification(_ notification: Notification) {
        setHoliday()
        list = Item.getDayList(date: date)
    }
}
