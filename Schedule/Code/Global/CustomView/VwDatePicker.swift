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
        vwTop.backgroundColor = Theme.hideViewColor
        
        confirmLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmLabel.text = "완료".localized
        confirmLabel.textColor = .black
        confirmLabel.textAlignment = .right
        confirmLabel.isUserInteractionEnabled = true
        
        cancelLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelLabel.text = "취소".localized
        cancelLabel.textColor = .black
        cancelLabel.textAlignment = .left
        cancelLabel.isUserInteractionEnabled = true
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
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
