//
//  VCAddItem + TableView.swift
//  Schedule
//
//  Created by Asu on 2020/09/11.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension VCAddItem: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch itemList[indexPath.section][indexPath.row] {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellAddItemTitle.identifier, for: indexPath) as! CellAddItemTitle
            cell.setTitle(title: self.item?.title ?? "")
            cell.setTvPlaceHolder()
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellAddItemDelete.identifier, for: indexPath) as! CellAddItemDelete
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNormalMagnitude
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch itemList[indexPath.section][indexPath.row] {
        case .title:
            if let cell = tableView.cellForRow(at: indexPath) as? CellAddItemTitle {
                cell.tvBecomeFirstResponder()
            }
        case .delete:
            if let _ = tableView.cellForRow(at: indexPath) as? CellAddItemDelete {
                self.deleteAlert()
            }
        }
    }
}

// MARK: - CellAddItemTitleDelegate

extension VCAddItem: CellAddItemTitleDelegate {
    func updateCellHeight() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func textViewDidChange(title: String) {
        if title == "제목".localized {
            eventTitle = ""
        } else {
            eventTitle = title
        }
        
        add.isEnabled = isEdit()
    }
}

