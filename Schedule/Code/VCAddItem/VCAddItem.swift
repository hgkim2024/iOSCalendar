//
//  VCAddItem.swift
//  Schedule
//
//  Created by Asu on 2020/09/11.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit
import RealmSwift
import RxCocoa
import RxSwift

enum AddItemList {
    case title
    case delete
}
// TODO: - 스크롤 시 키보드 내리는 기능, 키보드 올라온 만큼 테이블뷰 줄이는 기능 추가 할 것
class VCAddItem: UIViewController {
    
    var itemList: [[AddItemList]] = [
        [
            .title
        ]
    ]
    
    var tableView: UITableView!
    
    var add: UIBarButtonItem!
    
    var date: Date = Date()
    var item: Item? = nil
    
    var eventTitle: String = "" {
        didSet {
            print("didSet eventTitle: \(eventTitle)")
        }
    }
    
    convenience init(date: Date, item: Item? = nil) {
        self.init(nibName:nil, bundle:nil)
        self.date = date
        // TODO: - item 존재 시 - 휴지통 아이콘 추가 및 기존 데이터 입력 된 상태로 보여주기
        self.item = item
        if item != nil {
            itemList.append([.delete])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.item != nil {
//            itemList.append(.delete)
        }
        
        setUpUI()
        displayUI()
    }
    
    func setUpUI() {
        title = "이벤트".localized
        
        let cancel = UIBarButtonItem(title: "취소".localized, style: .plain, target: self, action: #selector(cancelTapped))

        navigationItem.leftBarButtonItem = cancel
        let title = (self.item == nil) ? "추가" : "완료"
        add = UIBarButtonItem(title: title.localized, style: .plain, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = add
        add.isEnabled = false
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 18.0))
        tableView.tableFooterView = UIView()
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = Theme.separator
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addTableViewRegister()
    }
    
    func displayUI() {
        view.addSubview(tableView)
        
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safe.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
        ])
    }
    
    // MARK: - Functions
    
    func addTableViewRegister() {
        tableView.register(CellAddItemTitle.self, forCellReuseIdentifier: CellAddItemTitle.identifier)
        tableView.register(CellAddItemDelete.self, forCellReuseIdentifier: CellAddItemDelete.identifier)
    }
    
    func dismissNotification() {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NamesOfNotification.refreshCalendar),
            object: nil,
            userInfo: nil
        )
    }
    
    func isEdit() -> Bool {
        if self.item == nil {
            if eventTitle.count > 0 {
                return true
            } else {
                return false
            }
        } else {
            if eventTitle.count > 0
                && self.item!.title != eventTitle {
                return true
            } else {
                return false
            }
        }
    }
    
    func dismissAlert() {
        let alert = UIAlertController(title: nil, message: "이 새로운 이벤트를 폐기하겠습니까?".localized, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "변경 사항 폐기".localized, style: UIAlertAction.Style.cancel, handler: { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "계속 편집하기".localized, style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteAlert() {
        let alert = UIAlertController(title: nil, message: "이 이벤트를 삭제하시겠습니까?".localized, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "취소".localized, style: UIAlertAction.Style.cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "이벤트 삭제".localized, style: UIAlertAction.Style.default, handler: { [weak self] action in
            guard
                let `self` = self,
                let item = self.item
            else { return }
            item.remove().subscribe(
                onNext: { [weak self] flag in
                    guard let `self` = self else { return }
                    if flag {
                        self.dismiss(animated: true) {
                            self.dismissNotification()
                        }
                    } else {
                        self.failAlert()
                    }
                }, onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.failAlert()
                }
            ).dispose()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func addTapped(_ sender: Any) {
        // TODO: - 여러 인자 추가 시, 추가 반영
        let item: Item
        if self.item != nil {
            item = self.item!
        } else {
            item = Item()
        }
        
        Item.add(
            item: item,
            title: eventTitle,
            date: self.date
        ).subscribe(
            onNext: { [weak self] item in
                guard let `self` = self else { return }
                self.dismiss(animated: true) {
                    self.dismissNotification()
                }
            },
            onError: { [weak self] error in
                guard let `self` = self else { return }
                self.failAlert()
        }).dispose()
    }
    
    func failAlert() {
        let alert = UIAlertController(title: nil, message: "저장에 실패하였습니다.".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인".localized, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func cancelTapped(_ sender: Any) {
        if isEdit() {
            dismissAlert()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}


extension VCAddItem: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        
        if isEdit() {
            dismissAlert()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
