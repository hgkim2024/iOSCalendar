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
        
        if indexPath.row > self.count - 1
            && !self.isUp {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellCalendarDayCount.identifier, for: indexPath) as! CellCalendarDayCount
            if indexPath.row == self.count {
                cell.setTitle(title: "+\((list?.count ?? 0) - count)")
            } else {
                cell.setTitle(title: "")
            }
            return cell
        } else {
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
            
            cell.setColor(isUp: self.isUp)
            return cell
        }
    }
}
