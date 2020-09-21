//
//  String.swift
//  Schedule
//
//  Created by Asu on 2020/09/12.
//  Copyright © 2020 Asu. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: self)
    }
}
