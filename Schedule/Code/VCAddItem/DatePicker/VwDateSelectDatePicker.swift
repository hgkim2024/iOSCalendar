//
//  VwDateSelectDatePicker.swift
//  Schedule
//
//  Created by Asu on 2020/10/26.
//  Copyright © 2020 Asu. All rights reserved.
//


import UIKit

class VwDateSelectDatePicker: UIView {
    
    var datePicker = UIDatePicker()
    var isStart: Bool = false
    
    weak var delegate: AddItemDateDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    func displayUI() {
        addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: - Functions
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        if isStart {
            delegate?.setStartDate(date: sender.date)
        } else {
            delegate?.setEndDate(date: sender.date)
        }
    }
}

