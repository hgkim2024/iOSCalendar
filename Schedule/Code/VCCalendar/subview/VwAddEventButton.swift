//
//  VwAddEventButton.swift
//  Schedule
//
//  Created by Asu on 2020/10/22.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VwAddEventButton: UIView {
    let button = UIButton()
    let shadow = UIView()
    
    init() {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Theme.background
        button.backgroundColor = Theme.saturday
        button.clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        
        
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
