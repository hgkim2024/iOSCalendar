//
//  VCAddItem + TableView.swift
//  Schedule
//
//  Created by Asu on 2020/09/11.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension VCAddItem: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TODO: - 셀 분할 열거체 만들어서 구분 할 것
        let cell = tableView.dequeueReusableCell(withIdentifier: CellAddItemTitle.identifier, for: indexPath) as! CellAddItemTitle
        cell.setTitle()
        cell.setTvPlaceHolder()
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNormalMagnitude
        default:
            return 30
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
        
        if eventTitle.count > 0 {
            add.isEnabled = true
        } else {
            add.isEnabled = false
        }
    }
}

