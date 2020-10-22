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
    
    static let alternativeHolidays = "대체공휴일"
    
    static let alternativeSolarDictionary: [String : String] = [
        "어린이날":"0505"
    ]
    
    static let alternativeLunarDictionary: [String : String] = [
        // 설날
        "설날":"0101",
        
        //추석
        "추석":"0815",
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
    
    static func getAlternativeHolidays(
        minDate: Date,
        maxDate: Date
    ) -> Date? {
        // 양력 대체공휴일 계산
        let minDay = minDate.dateToMonthDayString()
        let maxDay = maxDate.dateToMonthDayString()
        let alternativeHoliday = alternativeSolarDictionary["어린이날"]!
        if minDay < maxDay {
            if minDay <= alternativeHoliday
                && alternativeHoliday <= maxDay {
                var count: Int = -1
                if minDate.month == 5 {
                    count = Int(alternativeHoliday)! - Int(minDay)!
                } else if minDate.month == 4 {
                    count = (minDate.endOfMonth.day - minDate.day) + 5
                }
                
                let date = minDate.getNextCountDay(count: count)
                if date.weekday == 1 && count != -1 {
                    return date.nextDay
                }
            }
        } else {
            // empty
        }
        
        // 음력 대체공휴일 계산
        let lunarMinDay = minDate.dateToLunarString()
        let lunarMaxDay = maxDate.dateToLunarString()
        
        guard
            let minMonth = Int(lunarMinDay.dropLast().dropLast()),
            let maxMonth = Int(lunarMaxDay.dropLast().dropLast())
        else { return nil }
        
        let 추석 = alternativeLunarDictionary["추석"]!
        if minMonth <= 8 && 8 <= maxMonth {
            // 추석 존재
            var date: Date? = nil
            if lunarMinDay > 추석 {
                for count in 0...50 {
                    let countDate = minDate.getNextCountDay(count: -count)
                    let lunarDay = countDate.dateToLunarString()
                    
                    if lunarDay == 추석 {
                        date = countDate
                        break
                    }
                }
            } else {
                for count in 0...50 {
                    let countDate = minDate.getNextCountDay(count: count)
                    let lunarDay = countDate.dateToLunarString()
                    
                    if lunarDay == 추석 {
                        date = countDate
                        break
                    }
                }
            }
            
            if let holiday = date {
                if holiday.prevDay.weekday == 1
                    || holiday.weekday == 1
                    || holiday.nextDay.weekday == 1 {
                    return holiday.getNextCountDay(count: 2)
                }
            }
        }
        
        let 설날 = alternativeLunarDictionary["설날"]!
        if minMonth <= 12 && maxMonth <= 1
            || minMonth <= 1 && maxMonth <= 2 {
            var date: Date? = nil
            if 설날 < minDate.dateToLunarString()
                && minDate.dateToLunarString() < "0301" {
                for count in 0...50 {
                    let countDate = minDate.getNextCountDay(count: -count)
                    let lunarDay = countDate.dateToLunarString()
                    
                    if lunarDay == 설날 {
                        date = countDate
                        break
                    }
                }
            } else {
                for count in 0...50 {
                    let countDate = minDate.getNextCountDay(count: count)
                    let lunarDay = countDate.dateToLunarString()
                    
                    if lunarDay == 설날 {
                        date = countDate
                        break
                    }
                }
            }
            
            if let holiday = date {
                if holiday.prevDay.weekday == 1
                    || holiday.weekday == 1
                    || holiday.nextDay.weekday == 1 {
                    return holiday.getNextCountDay(count: 2)
                }
            }
        }
        
        return nil
    }
}
