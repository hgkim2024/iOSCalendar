//
//  vwMoveToday.swift
//  Schedule
//
//  Created by Asu on 2020/10/14.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VwMoveToday: UIView {
    let vwRoot = UIView()
    let title = UILabel()
    
    let height: CGFloat = 35
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        vwRoot.translatesAutoresizingMaskIntoConstraints = false
        vwRoot.backgroundColor = Theme.background.withAlphaComponent(0.8)
        vwRoot.layer.cornerRadius = height / 2.0
        
        vwRoot.layer.shadowColor = UIColor.black.cgColor
        vwRoot.layer.shadowRadius = 5.0
        vwRoot.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        vwRoot.layer.shadowOpacity = 0.2
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "오늘".localized
        title.font = UIFont.systemFont(ofSize: Global.fontSize)
        title.textAlignment = .left
    }
    
    func displayUI() {
        addSubview(vwRoot)
        addSubview(title)
        
        NSLayoutConstraint.activate([
            vwRoot.centerXAnchor.constraint(equalTo: centerXAnchor),
            vwRoot.centerYAnchor.constraint(equalTo: centerYAnchor),
            vwRoot.heightAnchor.constraint(equalToConstant: height),
            vwRoot.widthAnchor.constraint(equalTo: title.widthAnchor, multiplier: 1.0, constant: 28.0),
            
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
