//
//  VwKeyboardTop.swift
//  Schedule
//
//  Created by Asu on 2020/10/27.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VwKeyboardTop: UIView {
    
    let vwDown = UIImageView()
    let height: CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        backgroundColor = Theme.hideViewColor
        let _ = addTopSeparator()
        let _ = addBottomSeparator()
        
        vwDown.translatesAutoresizingMaskIntoConstraints = false
        vwDown.image = UIImage(systemName: "keyboard.chevron.compact.down")?.withRenderingMode(.alwaysTemplate)
        vwDown.tintColor = Theme.item
    }
    
    private func displayUI() {
        addSubview(vwDown)
        
        NSLayoutConstraint.activate([
            vwDown.centerYAnchor.constraint(equalTo: centerYAnchor),
            vwDown.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            vwDown.widthAnchor.constraint(equalToConstant: 30.0),
            vwDown.heightAnchor.constraint(equalToConstant: 20.0),
        ])
    }
}
