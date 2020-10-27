//
//  CellAddItemTitle.swift
//  Schedule
//
//  Created by Asu on 2020/09/11.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

// MARK: - VCWeeklyListItemCellDelegate
protocol CellAddItemTitleDelegate: class {
    func textViewDidChange(title: String)
}

class CellAddItemTitle: UITableViewCell {
    static let identifier: String = "CellAddItemTitle"
    
    var delegate: CellAddItemTitleDelegate?
    
    private let tv = UITextField()
    
    private var topSeparator: UIView? = nil
    private var bottomSeparator: UIView? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
        displayUI()
        topSeparator = contentView.addTopSeparator()
        bottomSeparator = contentView.addBottomSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        tv.textColor = Theme.font
        tv.textAlignment = .left
        tv.font = UIFont.systemFont(ofSize: Global.fontSize + 2)
        tv.text = ""
        tv.placeholder = "제목".localized
        tv.isUserInteractionEnabled = true
        
        tv.addTarget(self, action: #selector(tvTextDidChange), for: .editingChanged)
    }
    
    private func displayUI() {
        let topMargin: CGFloat = 12
        let leftMargin: CGFloat = 10
        
        addSubview(tv)
        
        NSLayoutConstraint.activate([
            tv.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
            tv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin),
            tv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftMargin),
            tv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topMargin)
        ])
    }
    
    // MARK: - Functions
    
    func setTitle(title: String = "") {
        tv.text = title
    }
    
    func tvBecomeFirstResponder() {
        tv.becomeFirstResponder()
    }
    
    @objc func tvTextDidChange(tv: UITextField) {
        guard let text = tv.text else { return }
        delegate?.textViewDidChange(title: text)
    }
}
