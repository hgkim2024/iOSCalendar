//
//  UITableViewCell.swift
//  Schedule
//
//  Created by Asu on 2020/10/27.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func clickAnimations() {
        let vwClick = UIView()
        contentView.addSubview(vwClick)
        contentView.sendSubviewToBack(vwClick)
        vwClick.translatesAutoresizingMaskIntoConstraints = false
        vwClick.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        NSLayoutConstraint.activate([
            vwClick.topAnchor.constraint(equalTo: contentView.topAnchor),
            vwClick.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            vwClick.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vwClick.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        UIView.animate(withDuration: 0.15, animations: {
            vwClick.alpha = 0.0
        }, completion: { _ in
            vwClick.removeFromSuperview()
        })
    }
}
