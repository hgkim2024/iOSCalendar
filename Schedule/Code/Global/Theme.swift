//
//  Theme.swift
//  Schedule
//
//  Created by Asu on 2020/09/05.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class Theme {
    
    static var isDarkMode: Bool = {
        UITraitCollection.current.userInterfaceStyle == .dark
    }()
    
    static var bar: UIColor = {
        (isDarkMode ? UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1) : .white)
    }()
    
    static var font: UIColor = {
        isDarkMode ? UIColor(hexString: "#FAFAFA") : UIColor(hexString: "#202020")
    }()

    // TODO: - 색상보고 변경할 것
    static var lightFont: UIColor = {
        isDarkMode ? .lightGray : .lightGray
    }()
    
    static var rootBackground: UIColor = {
        isDarkMode ? .black : UIColor(hexString: "#FAFAFA")
    }()
    
    static var background: UIColor = {
        isDarkMode ? UIColor(hexString: "#202020") : UIColor(hexString: "#FAFAFA")
    }()
    
    static var accent: UIColor = {
        isDarkMode ? UIColor(hexString: "#FAFAFA") : UIColor(hexString: "#202020")
    }()
//        UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
    
    static var separator: UIColor = UIColor.lightGray.withAlphaComponent(0.2)
    static var sunday: UIColor = UIColor.init(hexString: "#ff3333")
    static var saturday: UIColor = UIColor.init(hexString: "#3333ff")
}
