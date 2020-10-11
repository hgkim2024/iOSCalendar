//
//  VwCalendarWeekday.swift
//  Schedule
//
//  Created by Asu on 2020/09/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit


class VwCalendarWeekday: UIView {
    
    let dayString: [String] = [
        "일".localized,
        "월".localized,
        "화".localized,
        "수".localized,
        "목".localized,
        "금".localized,
        "토".localized
    ]
    
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        collectionView.register(VwCalendarWeekdayCell.self, forCellWithReuseIdentifier: VwCalendarWeekdayCell.identifier)
    }
    
    func displayUI() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension VwCalendarWeekday: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        Global.dayCount
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VwCalendarWeekdayCell.identifier, for: indexPath) as! VwCalendarWeekdayCell
        
        cell.setText(text: dayString[indexPath.row])
        cell.setColor(weekday: indexPath.row + 1)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = collectionView.bounds.size
        let width = size.width / CGFloat(Global.dayCount)
        return CGSize(width: width, height: Global.weekdayHeight)
    }
}
