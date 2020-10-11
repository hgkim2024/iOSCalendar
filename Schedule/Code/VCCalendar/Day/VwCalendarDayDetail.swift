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

class VwCalendarDayDetail: UIView {
    
    let dayString: [String] = [
        "일".localized,
        "월".localized,
        "화".localized,
        "수".localized,
        "목".localized,
        "금".localized,
        "토".localized
    ]
    
    let weekdayLabel = UILabel()
    let emptyLabel = UILabel()
    let separator = UIView()
    let downArrow = UIImageView()
    var tableView: UITableView? = nil
    var date: Date? = nil
    
    weak var delegate: CalendarTouchEventDelegate? = nil
    
    private var beginPoint: CGPoint? = nil
    private var lastPoint: CGPoint? = nil
    
    var preScrollY: CGFloat = 0
    var isScroll: Bool = false
    
    var list: [Item]? = nil {
        didSet {
            setUpTableView()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addObserver()
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLabel() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.05)
        
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchDownArrow))
        downArrow.addGestureRecognizer(tap)
        
        addSubview(weekdayLabel)
        addSubview(emptyLabel)
        addSubview(separator)
        addSubview(downArrow)
        
        let margin: CGFloat = Global.calendarleftMargin + 5
        
        NSLayoutConstraint.activate([
            weekdayLabel.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            weekdayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: Global.separatorSize),
            
            downArrow.topAnchor.constraint(equalTo: topAnchor),
            downArrow.centerXAnchor.constraint(equalTo: centerXAnchor),
            downArrow.widthAnchor.constraint(equalToConstant: 40.0),
            downArrow.heightAnchor.constraint(equalToConstant: 30.0)
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        tableView.rowHeight = UITableView.automaticDimension
        
        addRegister()
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: weekdayLabel.bottomAnchor, constant: 10.0),
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
    
    private func addRegister() {
        tableView?.register(CellCalendarDayDetail.self, forCellReuseIdentifier: CellCalendarDayDetail.identifier)
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
        if beginPoint.y != lastPoint.y {
            delegate?.touchEnd(diff: y)
        }
        self.beginPoint = nil
    }
    
    // MARK: - Observer
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setUpUI),
            name: NSNotification.Name(rawValue: NamesOfNotification.selectedDayDetailNotification),
            object: nil
        )
    }
    
    @objc func setUpUI(_ notification: Notification) {
        guard
            let date = notification.userInfo?["date"] as? Date,
            let weekday = notification.userInfo?["weekday"] as? Int
        else {
                return
        }
        
        self.date = date
        weekdayLabel.setCalendarDayColor(weekday: weekday)
        weekdayLabel.text = "\(date.day).\(dayString[weekday])"
        
        list = Item.getDayList(date: date)
    }
}
