//
//  UIView.swift
//  Schedule
//
//  Created by Asu on 2020/10/14.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension UIView {
    func addTopSeparator() {
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
    }
    
    func addBottomSeparator() {
        let BottomSeparator = UIView()
        BottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        BottomSeparator.backgroundColor = Theme.separator
        
        addSubview(BottomSeparator)
        
        NSLayoutConstraint.activate([
            BottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            BottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            BottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            BottomSeparator.heightAnchor.constraint(equalToConstant: Global.separatorSize)
        ])
    }
}
