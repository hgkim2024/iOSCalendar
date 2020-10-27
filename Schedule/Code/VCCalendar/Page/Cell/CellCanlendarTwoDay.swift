//
//  CellCanlendarTwoDay.swift
//  Schedule
//
//  Created by Asu on 2020/10/27.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class CellCanlendarTwoDay: UITableViewCell {
    static let identifier: String = "CellCanlendarTwoDay"
    
    let vwRoot = UIView()
    let title = UILabel()
    var titleFlag: Bool = true
    
    var item: Item? = nil
    let leftMargin: CGFloat = 2.5
    
    weak var vcMonthCalendar: VCCalendarMonth? = nil
    weak var vwDay: VwCalendarDay? = nil
    var indexPath: IndexPath? = nil
    var isUp: Bool = false
    
    deinit {
        title.removeFromSuperview()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        clipsToBounds = false
        contentView.clipsToBounds = false
        backgroundColor = .clear
        vwRoot.translatesAutoresizingMaskIntoConstraints = false
        vwRoot.backgroundColor = Theme.item.withAlphaComponent(0.8)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = UIColor(hexString: "#FAFAFA")
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: Global.weekdayFontSize - 1)
        title.isHidden = true
        // ellipsis
        title.lineBreakMode = .byCharWrapping
    }
    
    func displayUI() {
        let topMargin: CGFloat = 1.0
        
        addSubview(vwRoot)
        
        NSLayoutConstraint.activate([
            vwRoot.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
            vwRoot.leadingAnchor.constraint(equalTo: leadingAnchor),
            vwRoot.trailingAnchor.constraint(equalTo: trailingAnchor),
            vwRoot.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topMargin),
        ])
    }
    
    // MARK: - Functions
    
    func setTitle(title: String) {
        self.title.text = title
    }
    
    func setColor(isUp: Bool) {
        if isUp {
            // go to min
            title.isHidden = true
        } else {
            // go to max
            title.isHidden = false
        }
    }
    
    // TODO: - 현재 쓰이지 않음 추 후에 서브뷰의 정확한 위치를 알고자 할 때 사용할 것
    func getPoint() -> CGPoint? {
        guard let superView = vcMonthCalendar?.view else { return nil }
        superView.addSubview(title)
        let point = vwRoot.convert(vwRoot.frame.origin, to: superView)
        
        return point
    }
    
    func setUpTitle() {
        if titleFlag && title.text != "" {
            guard
                let superView = vcMonthCalendar?.view,
                let vwDay = self.vwDay,
                let indexPath = self.indexPath,
                let item = self.item,
                let date = vwDay.date
            else { return }
            if isUp {
                title.isHidden = true
            } else {
                title.isHidden = false
            }
            superView.addSubview(title)
            titleFlag = false
            var widthCount: CGFloat = 1.0
            
            let topMargin: CGFloat = Global.calendarleftMargin + Global.weekdayFontSize + 3
            let topWeight: CGFloat = 16.0
            let topTotalMargin: CGFloat = topMargin + (topWeight * CGFloat(indexPath.row))
            
            let endDate = Date(timeIntervalSince1970: item.endDate)
            let weekday = date.weekday == 0 ? 7 : date.weekday
            let endWeekday = endDate.weekday == 0 ? 7 : endDate.weekday
            
            if date.startOfDay.timeIntervalSince1970 + TimeInterval(86400 * (7 - weekday)) < endDate.timeIntervalSince1970 {
                // max
                widthCount = CGFloat(7 - weekday + 1)
            } else {
                widthCount = CGFloat(endWeekday - weekday + 1)
            }
            
            let widthWeight = (UIScreen.main.bounds.size.width - (Global.calendarMargin * 2)) / CGFloat(Global.calendarColumn)
            
            let widthSize = (widthWeight * widthCount) - leftMargin
            vwDay.twoDayTitleList.append(title)
            
            vwDay.changeAlpha(isUp: vwDay.isUp)
            
            NSLayoutConstraint.activate([
                title.topAnchor.constraint(equalTo: vwDay.topAnchor, constant: topTotalMargin),
                title.leadingAnchor.constraint(equalTo: vwDay.leadingAnchor, constant: leftMargin),
                title.heightAnchor.constraint(equalToConstant: 14.0),
                title.widthAnchor.constraint(equalToConstant: widthSize)
            ])
        }
    }
}

