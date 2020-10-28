//
//  VwDatePicker.swift
//  Schedule
//
//  Created by Asu on 2020/10/27.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VwDatePicker: UIView {
    
    let vwTop = UIView()
    let confirmLabel = UILabel()
    let cancelLabel = UILabel()
    let datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        backgroundColor = Theme.background
        vwTop.translatesAutoresizingMaskIntoConstraints = false
        vwTop.backgroundColor = Theme.background
        _ = vwTop.addTopSeparator()
        _ = vwTop.addBottomSeparator()
        
        confirmLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmLabel.text = "완료".localized
        confirmLabel.textColor = Theme.item
        confirmLabel.textAlignment = .right
        confirmLabel.isUserInteractionEnabled = true
        confirmLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        
        cancelLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelLabel.text = "취소".localized
        cancelLabel.textColor = Theme.sunday
        cancelLabel.textAlignment = .left
        cancelLabel.isUserInteractionEnabled = true
        cancelLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = Theme.hideViewColor
    }
    
    private func displayUI() {
        addSubview(vwTop)
        addSubview(confirmLabel)
        addSubview(cancelLabel)
        addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            vwTop.topAnchor.constraint(equalTo: topAnchor),
            vwTop.leadingAnchor.constraint(equalTo: leadingAnchor),
            vwTop.trailingAnchor.constraint(equalTo: trailingAnchor),
            vwTop.heightAnchor.constraint(equalToConstant: 40.0),
            
            confirmLabel.centerYAnchor.constraint(equalTo: vwTop.centerYAnchor),
            confirmLabel.trailingAnchor.constraint(equalTo: vwTop.trailingAnchor, constant: -15.0),
            
            cancelLabel.centerYAnchor.constraint(equalTo: vwTop.centerYAnchor),
            cancelLabel.leadingAnchor.constraint(equalTo: vwTop.leadingAnchor, constant: 15.0),
            
            datePicker.topAnchor.constraint(equalTo: vwTop.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
