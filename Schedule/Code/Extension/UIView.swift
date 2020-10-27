//
//  UIView.swift
//  Schedule
//
//  Created by Asu on 2020/10/14.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension UIView {
    func addTopSeparator() -> UIView {
        let topSeparator = UIView()
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.backgroundColor = Theme.separator
        
        addSubview(topSeparator)
        
        NSLayoutConstraint.activate([
            topSeparator.topAnchor.constraint(equalTo: topAnchor),
            topSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: Global.separatorSize)
        ])
        
        return topSeparator
    }
    
    func addBottomSeparator() -> UIView {
        let bottomSeparator = UIView()
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparator.backgroundColor = Theme.separator
        
        addSubview(bottomSeparator)
        
        NSLayoutConstraint.activate([
            bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: Global.separatorSize)
        ])
        
        return bottomSeparator
    }
}
