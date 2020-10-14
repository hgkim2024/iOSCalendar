//
//  CellAddItemDelete.swift
//  Schedule
//
//  Created by Asu on 2020/10/14.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class CellAddItemDelete: UITableViewCell {
    static let identifier: String = "CellAddItemDelete"
    
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
        displayUI()
        contentView.addTopSeparator()
        contentView.addBottomSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이벤트 삭제".localized
        label.font = UIFont.systemFont(ofSize: Global.fontSize)
        label.textAlignment = .center
        label.textColor = Theme.item
    }
    
    private func displayUI() {
        let margin: CGFloat = 10.0
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
        ])
    }
}
