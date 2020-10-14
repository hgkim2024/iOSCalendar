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
    
    // 지정한 날짜
    dynamic var date: TimeInterval = 0.0
    
    override static func primaryKey() -> String? {
        return "key"
    }
    
    // MARK: - funcsion
    static func add(
        item: Item,
        title: String,
        date: Date = Date()
    ) -> Observable<Item> {
        // TODO: - 여러 인자 추가 시, 추가 반영
        return Observable.create { observer in
            do {
                let realm = try Realm()
                if item.key == -1 {
                    item.key = Int64(Date().timeIntervalSince1970 * 1000)
                    item.date = date.startOfDay.timeIntervalSince1970
                }
                
                try realm.write {
                    item.title = title
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
    
    static func getDayList(
        date: Date
    ) -> [Item]? {
        do {
            let startOfDay = date.startOfDay.timeIntervalSince1970
            let endOfDay = date.endOfDay.timeIntervalSince1970
            let realm = try Realm()
            let list = realm.objects(Item.self).filter(
                "%@ <= date AND date <= %@",
                startOfDay,
                endOfDay
            )
            
            if list.count == 0 {
                return nil
            }
            
            var itemList: [Item] = []
            itemList.append(contentsOf: list)
            return itemList
        } catch {
            return nil
        }
    }
    
    func remove() -> Observable<Bool> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                
                try realm.write {
                    realm.delete(self)
                    observer.on(.next(true))
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
