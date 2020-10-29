//
//  File.swift
//  Schedule
//
//  Created by Asu on 2020/09/11.
//  Copyright © 2020 Asu. All rights reserved.
//

import RealmSwift
import RxCocoa
import RxSwift

@objcMembers class Item: Object {
    
    // 생성 시간
    dynamic var key: Int64 = -1
    
    // 제목
    dynamic var title: String = ""
    
    // 시작 날짜
    dynamic var startDate: TimeInterval = 0.0
    
    // 종료 날짜
    dynamic var endDate: TimeInterval = 0.0
    
    // TODO: - 시작 시간, 종료 시간 지정 시 startTime, endTime 인자 추가 할 것
    
    override static func primaryKey() -> String? {
        return "key"
    }
    
    // MARK: - funcsion
    static func add(
        item: Item,
        title: String,
        startDate: Date,
        endDate: Date
    ) -> Observable<Item> {
        // TODO: - 여러 인자 추가 시, 추가 반영
        return Observable.create { observer in
            do {
                let realm = try Realm()
                if item.key == -1 {
                    item.key = Int64(Date().timeIntervalSince1970 * 1000)
                }
                
                try realm.write {
                    item.title = title
                    item.startDate = startDate.startOfDay.timeIntervalSince1970
                    item.endDate = endDate.endOfDay.timeIntervalSince1970
                    realm.add(item, update: .all)
                    try realm.commitWrite()
                    observer.on(.next(item))
                    observer.on(.completed)
                }
                
            } catch {
                observer.on(.error(error))
            }
            
            return Disposables.create()
        }
    }

    static func getDayItemList(
        date: Date
    ) -> [Item]? {
        do {
            let startOfDay = date.startOfDay.timeIntervalSince1970
            let realm = try Realm()
            let list = Array(realm.objects(Item.self).filter(
                "startDate <= %@ AND %@ <= endDate",
                startOfDay,
                startOfDay
            ))
            
            if list.count == 0 {
                return nil
            }

            return list
        } catch {
            return nil
        }
    }
    
    static func getDayList(
        date: Date
    ) -> [Item]? {
        do {
            let startOfDay = date.startOfDay.timeIntervalSince1970
            let realm = try Realm()
            var list = Array(realm.objects(Item.self).filter(
                "startDate <= %@ AND %@ <= endDate",
                startOfDay,
                startOfDay
            ))
            
            list = list.filter({ (item) -> Bool in
                return (item.endDate - item.startDate) < 86400
            })
            
            if list.count == 0 {
                return nil
            }

            return list.sorted(by: {$0.key < $1.key})
        } catch {
            return nil
        }
    }
    
    static func getTwoDayList(
        date: Date
    ) -> [Item]? {
        do {
            let startOfWeek = date.startOfDay.startOfWeek.timeIntervalSince1970
            let endOfWeek = date.endOfDay.endOfWeek.timeIntervalSince1970
            let realm = try Realm()
            let startList = Array(realm.objects(Item.self).filter(
                "%@ <= startDate AND startDate <= %@",
                startOfWeek,
                endOfWeek
            ))
            
            let endList = Array(realm.objects(Item.self).filter(
                "%@ <= endDate AND endDate <= %@",
                startOfWeek,
                endOfWeek
            ))
            
            var list = startList
            list.append(contentsOf: endList)
            list = Array(Set(list))
            list = list.filter({ (item) -> Bool in
                return (item.endDate - item.startDate) >= 86400
            })
            
            if list.count == 0 {
                return nil
            }
            
            return list.sorted(by: {$0.key < $1.key})
            
        } catch {
            return nil
        }
    }
 
    func remove() -> Observable<Bool> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                
                try realm.write {
                    if self.isInvalidated == false {
                        realm.delete(self)
                        observer.on(.next(true))
                    } else {
                        observer.on(.next(false))
                    }
                    observer.on(.completed)
                }
                
            } catch {
                observer.on(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func removeAll() -> Observable<Results<Item>> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                let items = realm.objects(Item.self)
                
                try realm.write {
                    realm.delete(items)
                    observer.on(.next(items))
                    observer.on(.completed)
                }
                
            } catch {
                observer.on(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
