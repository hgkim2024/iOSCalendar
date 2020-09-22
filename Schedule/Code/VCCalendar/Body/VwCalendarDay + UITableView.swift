//
//  VwCalendarDay + UITableView.swift
//  Schedule
//
//  Created by Asu on 2020/09/22.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension VwCalendarDay: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(list?.count)")
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellCalendarDay.identifier, for: indexPath) as! CellCalendarDay
        
        cell.setTitle(title: list?[safe: indexPath.row]?.title ?? "")
        cell.selectionStyle = .none
        
        return cell
    }
}
