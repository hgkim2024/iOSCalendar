//
//  UILabel.swift
//  Schedule
//
//  Created by Asu on 2020/10/11.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension UILabel {
    func setCalendarDayColor(weekday: Int, alpha: CGFloat = 1.0) {
        switch weekday {
        case 1:
            textColor = Theme.sunday.withAlphaComponent(alpha)
        case 0, 7:
            textColor = Theme.saturday.withAlphaComponent(alpha)
        default:
            textColor = Theme.font.withAlphaComponent(alpha)
        }
    }
}
