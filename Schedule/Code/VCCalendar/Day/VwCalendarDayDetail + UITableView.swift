//
//  VwCalendarDayDetail + UITableView.swift
//  Schedule
//
//  Created by Asu on 2020/10/11.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension VwCalendarDayDetail: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellCalendarDayDetail.identifier, for: indexPath) as! CellCalendarDayDetail
        
        if let title = list?[safe: indexPath.row]?.title {
            cell.setTitle(title: title)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = list?[safe: indexPath.row] else { return }
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.touchBegin()
        isScroll = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isScroll else { return }
        let y = scrollView.contentOffset.y
        preScrollY = y
        delegate?.touchMove(diff: y)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isScroll = false
        let y = scrollView.contentOffset.y
        delegate?.touchEnd(diff: y)
    }
}
