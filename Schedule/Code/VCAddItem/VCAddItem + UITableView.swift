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
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .startTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellAddItemTime.identifier, for: indexPath) as! CellAddItemTime
            cell.selectionStyle = .none
            cell.date = self.startDate
            cell.setTitle(title: "시작".localized)
            cell.delegate = self
            cell.topSeparator?.isHidden = false
            cell.bottomSeparator?.isHidden = true
            self.startTimeCell = cell
            return cell
        case .endTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellAddItemTime.identifier, for: indexPath) as! CellAddItemTime
            cell.selectionStyle = .none
            cell.date = self.endDate
            cell.setTitle(title: "종료".localized)
            cell.delegate = self
            if isStart {
                cell.topSeparator?.isHidden = true
                cell.bottomSeparator?.isHidden = false
            } else {
                cell.topSeparator?.isHidden = true
                cell.bottomSeparator?.isHidden = true
            }
            self.endTimeCell = cell
            return cell
        case .dateSelect:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellAddItemSelectTime.identifier, for: indexPath) as! CellAddItemSelectTime
            cell.selectionStyle = .none
            cell.isStart = self.isStart
            if let date = self.selectDate {
                cell.vwSelect.datePicker.date = date
            }
            if self.isStart {
                cell.bottomSeparator?.isHidden = true
            } else {
                cell.bottomSeparator?.isHidden = false
            }
            cell.vwSelect.delegate = self
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
        case .startTime:
            view.endEditing(true)
            guard
                let cell = tableView.cellForRow(at: indexPath) as? CellAddItemTime,
                let list = self.itemList[safe: 1]
            else { return }
            cell.clickAnimations()
            if list.contains(.dateSelect) {
                for (idx, item) in list.enumerated() {
                    if item == .dateSelect {
                        itemList[1].remove(at: idx)
                        break
                    }
                }
            }
            
            for (idx, item) in list.enumerated() {
                if item == .startTime {
                    itemList[1].insert(.dateSelect, at: idx + 1)
                    self.selectDate = cell.date
                    break
                }
            }
            self.isStart = true
            tableView.reloadSections([1], with: .automatic)
        case .endTime:
            view.endEditing(true)
            guard
                let cell = tableView.cellForRow(at: indexPath) as? CellAddItemTime,
                let list = self.itemList[safe: 1]
            else { return }
            cell.clickAnimations()
            if list.contains(.dateSelect) {
                for (idx, item) in list.enumerated() {
                    if item == .dateSelect {
                        itemList[1].remove(at: idx)
                        break
                    }
                }
            }
            
            for (idx, item) in list.enumerated() {
                if item == .endTime {
                    itemList[1].insert(.dateSelect, at: idx)
                    self.selectDate = cell.date
                    break
                }
            }
            self.isStart = false
            tableView.reloadSections([1], with: .automatic)
        case .dateSelect:
            view.endEditing(true)
            break
        case .delete:
            if let _ = tableView.cellForRow(at: indexPath) as? CellAddItemDelete {
                self.deleteAlert()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: - CellAddItemTitleDelegate

extension VCAddItem: CellAddItemTitleDelegate {
    func textViewDidChange(title: String) {
        if title == "제목".localized {
            eventTitle = ""
        } else {
            eventTitle = title
        }
        
        add.isEnabled = isEdit()
    }
}

extension VCAddItem: AddItemDateDelegate {
    func getStratDate() -> Date {
        return self.startDate!
    }
    
    func setStartDate(date: Date) {
        self.startDate = date
        add.isEnabled = isEdit()
        
        startTimeCell?.date = date
        guard let endDate = endTimeCell?.date else { return }
        if date > endDate {
            setEndDate(date: date)
        }
    }
    
    func getEndDate() -> Date {
        return self.endDate!
    }
    
    func setEndDate(date: Date) {
        self.endDate = date
        add.isEnabled = isEdit()
        
        endTimeCell?.date = date
        
        guard let startDate = startTimeCell?.date else { return }
        if date < startDate {
            setStartDate(date: date)
        }
    }
}
