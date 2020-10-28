//
//  VwCalendarDay + UITableView.swift
//  Schedule
//
//  Created by Asu on 2020/09/22.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension VwCalendarDay: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        return ((list?.count ?? 0) + holidayList.count)
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        if (indexPath.row > self.count - 1
            && tableView.rowHeight == maxHeight)
            || (list?[safe: indexPath.row - holidayList.count]?.key == -1) {
            // 하단 숫자 표기 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: CellCalendarDayCount.identifier, for: indexPath) as! CellCalendarDayCount
            if indexPath.row == self.count
                && list?[safe: indexPath.row - holidayList.count]?.key != -1{
                cell.setTitle(title: "+\((list?.count ?? 0) - count)")
            } else {
                cell.setTitle(title: "")
            }
            return cell
        } else if let item = list?[safe: indexPath.row - holidayList.count],
                  (item.endDate - item.startDate) >= 86400 {
            // 이틀 이상인 경우
            let cell = tableView.dequeueReusableCell(withIdentifier: CellCanlendarTwoDay.identifier, for: indexPath) as! CellCanlendarTwoDay
            let date = Date(timeIntervalSince1970: item.startDate).startOfDay
            if date == self.date?.startOfDay
                || self.date?.weekday == 1
            {
                let item = list?[safe: indexPath.row - holidayList.count]
                cell.setTitle(title: item?.title ?? "")
                cell.item = item
                cell.vcMonthCalendar = vcMonthCalendar
                cell.vwDay = self
                cell.indexPath = indexPath
            }
            cell.selectionStyle = .none
            cell.setColor(isUp: tableView.rowHeight == minHeight)
            return cell
        } else {
            // 일반 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: CellCalendarDay.identifier, for: indexPath) as! CellCalendarDay
            if holidayList.count > indexPath.row
                && holidayList.count != 0 {
                cell.setTitle(title: holidayList[safe: indexPath.row] ?? "")
                cell.setHoliday(isHoliday: true)
            } else {
                cell.setTitle(title: list?[safe: indexPath.row - holidayList.count]?.title ?? "")
                cell.setHoliday(isHoliday: false)
            }
            cell.selectionStyle = .none
            
            cell.setColor(isUp: tableView.rowHeight == minHeight)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let twoDaycell = cell as? CellCanlendarTwoDay else { return }
        if tableView.rowHeight == maxHeight {
            twoDaycell.setUpTitle()
        }
    }
}
