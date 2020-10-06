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
    func updateCellHeight()
    func textViewDidChange(title: String)
}

class CellAddItemTitle: UITableViewCell {
    static let identifier: String = "CellAddItemTitle"
    
    var delegate: CellAddItemTitleDelegate?
    
    private var tv: UITextView!
    private var vwDummy: UIView!
    private var tvConstraint: NSLayoutConstraint!
    private var previousRect: CGRect?
    
    private let minHeight: CGFloat = 34
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.showsVerticalScrollIndicator = false
        
        tv.textColor = Theme.font
        tv.textAlignment = .left
        tv.font = UIFont.systemFont(ofSize: Global.fontSize - 1)
        tv.text = ""
        tv.delegate = self
        tv.isUserInteractionEnabled = true
        
        vwDummy = UIView()
        vwDummy.translatesAutoresizingMaskIntoConstraints = false
        vwDummy.backgroundColor = .clear
    }
    
    private func displayUI() {
        let topMargin: CGFloat = 6
        let leftMargin: CGFloat = 10
        let height: CGFloat = getTvHeight()
        
        addSubview(tv)
        addSubview(vwDummy)
        tvConstraint = tv.heightAnchor.constraint(equalToConstant: height)
        NSLayoutConstraint.activate([
            tv.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
            tv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin),
            tv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftMargin),
            tvConstraint,
            
            vwDummy.topAnchor.constraint(equalTo: tv.bottomAnchor),
            vwDummy.leadingAnchor.constraint(equalTo: tv.leadingAnchor),
            vwDummy.trailingAnchor.constraint(equalTo: tv.trailingAnchor),
            vwDummy.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topMargin),
        ])
    }
    
    // MARK: - Functions
    
    func setTitle(title: String = "") {
        tv.text = title
    }
    
    func setTvPlaceHolder() {
        if tv.text.isEmpty {
            tv.text = "제목".localized
            tv.textColor = .lightGray
        } else if tv.text == "제목".localized {
            tv.textColor = Theme.font
            tv.text = ""
        }
    }
    
    func getTvHeight() -> CGFloat {
        if tv.contentSize.height > minHeight {
            return tv.contentSize.height
        } else {
            return minHeight
        }
    }
    
    func tvBecomeFirstResponder() {
        tv.becomeFirstResponder()
    }
}

// MARK: - UITextViewDelegate
extension CellAddItemTitle: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView == self.tv else { return }
        setTvPlaceHolder()
        
        delegate?.textViewDidChange(title: textView.text)
        tvConstraint?.constant = getTvHeight()
        delegate?.updateCellHeight()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView == self.tv else { return }
        setTvPlaceHolder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView == self.tv else { return }
        
        if textView.text.isEmpty {
            textView.text = "제목".localized
            textView.textColor = .lightGray
        } else if textView.textColor == .lightGray {
            if textView.text.count > "제목".localized.count {
                textView.textColor = Theme.font
                textView.text = "" + textView.text.dropFirst("제목".localized.count)
            } else {
                textView.text = "제목".localized
                textView.textColor = .lightGray
            }
        }
        delegate?.textViewDidChange(title: textView.text)
        
        let pos = textView.endOfDocument
        let currentRect = textView.caretRect(for: pos)
        
        guard let previousRect = self.previousRect else {
            self.previousRect = currentRect
            return
        }
        
        if currentRect.origin.y != previousRect.origin.y {
            tvConstraint?.constant = getTvHeight()
            delegate?.updateCellHeight()
            self.previousRect = currentRect
        }
    }
}
