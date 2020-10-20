//
//  LunarToSolar.swift
//  Schedule
//
//  Created by Asu on 2020/10/20.
//  Copyright © 2020 Asu. All rights reserved.
//

import Foundation

class Holiday {
    
    static let solarDictionary: [String : String] = [
        "0101":"새해 첫날",
        "0301":"삼일절",
        "0505":"어린이날",
        "0606":"현충일",
        "0815":"광복절",
        "1003":"개천절",
        "1009":"한글날",
        "1225":"크리스마스"
    ]
    
    static let lunarDictionary: [String : String] = [
        // 설날
        "0101":"설날",
        "0102":"설날 연휴",
        
        // 부처님오신날
        "0408":"부처님 오신 날",
        
        //추석
        "0814":"추석 연휴",
        "0815":"추석",
        "0816":"추석 연휴"
    ]
    
    static func isHoliday(
        minDay: String,
        maxDay: String,
        isLunar: Bool = false
    ) -> [String] {
        
        var stringArray: [String] = []
        var dictionary = [String: String]()
        
        if isLunar {
            dictionary = lunarDictionary
        } else {
            dictionary = solarDictionary
        }
        
        if minDay > maxDay {
            for key in dictionary.keys {
                if minDay <= key && key <= "1231" {
                    stringArray.append(key)
                } else if "0101" <= key && key <= maxDay {
                    stringArray.append(key)
                }
            }
        } else {
            for key in dictionary.keys {
                if minDay <= key && key <= maxDay {
                    stringArray.append(key)
                }
            }
        }
        return stringArray.sorted(by: {$0 < $1})
    }
    
    static func getHolidayList(
        stringArray: [String],
        isLunar: Bool = false
    ) -> [String : String] {
        
        var dictionary = [String: String]()
        var filterDictionary = [String: String]()
        
        if isLunar {
            dictionary = lunarDictionary
        } else {
            dictionary = solarDictionary
        }
        
        for key in stringArray {
            if let value = dictionary[key] {
                filterDictionary[key] = value
            }
        }
        
        return filterDictionary
    }
}
