//
//  VwCalendarDayDetail + UITableView.swift
//  Schedule
//
//  Created by Asu on 2020/10/11.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension VCCalendarDayDetail: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list?.count ?? 0) + holidayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellCalendarDayDetail.identifier, for: indexPath) as! CellCalendarDayDetail
        
        if holidayList.count > indexPath.row
            && holidayList.count != 0 {
            cell.setTitle(title: holidayList[safe: indexPath.row] ?? "")
            cell.setHoliday(isHoliday: true)
        } else {
            cell.setTitle(title: list?[safe: indexPath.row - holidayList.count]?.title ?? "")
            cell.setHoliday(isHoliday: false)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = list?[safe: indexPath.row - holidayList.count] else { return }
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NamesOfNotification.dayCalendarDidSelectCell),
            object: nil,
            userInfo: ["item": item]
        )
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        touchDelegate?.touchBegin()
        isScroll = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isScroll else { return }
        let y = scrollView.contentOffset.y
        preScrollY = y
        touchDelegate?.touchMove(diff: y)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isScroll = false
        let y = scrollView.contentOffset.y
        touchDelegate?.touchEnd(diff: y)
    }
}
