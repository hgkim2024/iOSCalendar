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
    case startTime
    case endTime
    case dateSelect
}

protocol AddItemDateDelegate: class {
    func getStratDate() -> Date
    func setStartDate(date: Date)
    
    func getEndDate() -> Date
    func setEndDate(date: Date)
}


class VCAddItem: UIViewController {
    
    var itemList: [[AddItemList]] = [
        [
            .title
        ],
        [
            .startTime,
            .endTime,
        ]
    ]
    
    var tableView: UITableView!
    let vwkeyboardTop = VwKeyboardTop()
    var keyboardTopConstraint: NSLayoutConstraint?
    
    var add: UIBarButtonItem!
    
    var date: Date = Date()
    var item: Item? = nil
    
    var eventTitle: String = ""
    var selectDate: Date? = nil
    
    var startDate: Date? = nil
    var endDate: Date? = nil
    
    var initStartDate: Date? = nil
    var initEndDate: Date? = nil
    var isStart: Bool = false
    
    convenience init(
        item: Item? = nil,
        startDate: Date,
        endDate: Date
    ) {
        self.init(nibName:nil, bundle:nil)
        
        self.initStartDate = startDate
        self.initEndDate = endDate
        self.startDate = startDate
        self.endDate = endDate
        self.item = item
        if item != nil {
            itemList.append([.delete])
            eventTitle = item!.title 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
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
        tableView.separatorColor = Theme.separator
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addTableViewRegister()
        
        vwkeyboardTop.translatesAutoresizingMaskIntoConstraints = false
        vwkeyboardTop.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickHideKeyboard))
        vwkeyboardTop.addGestureRecognizer(tap)
    }
    
    func displayUI() {
        view.addSubview(tableView)
        view.addSubview(vwkeyboardTop)
        keyboardTopConstraint = vwkeyboardTop.topAnchor.constraint(equalTo: view.bottomAnchor)
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safe.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: vwkeyboardTop.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            
            keyboardTopConstraint!,
            vwkeyboardTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vwkeyboardTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vwkeyboardTop.heightAnchor.constraint(equalToConstant: vwkeyboardTop.height)
        ])
    }
    
    // MARK: - Functions
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showKeyboard(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideKeboard(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func showKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo,
            // 3
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            vwkeyboardTop.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.keyboardTopConstraint?.constant = -(keyboardRectangle.height + self.vwkeyboardTop.height)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func hideKeboard(notification: Notification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.keyboardTopConstraint?.constant = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.vwkeyboardTop.isHidden = true
        })
    }
    
    @objc func clickHideKeyboard() {
        view.endEditing(true)
    }
    
    func addTableViewRegister() {
        tableView.register(CellAddItemTitle.self, forCellReuseIdentifier: CellAddItemTitle.identifier)
        tableView.register(CellAddItemDelete.self, forCellReuseIdentifier: CellAddItemDelete.identifier)
        tableView.register(CellAddItemTime.self, forCellReuseIdentifier: CellAddItemTime.identifier)
        tableView.register(CellAddItemSelectTime.self, forCellReuseIdentifier: CellAddItemSelectTime.identifier)
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
            if (eventTitle.count > 0 && self.item!.title != eventTitle)
            || (eventTitle.count > 0 && initStartDate != startDate)
            || (eventTitle.count > 0 && initEndDate != endDate) {
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
                            self.item = nil
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
            title: self.eventTitle,
            startDate: self.startDate!.startOfDay,
            endDate: self.endDate!.startOfDay
        ).subscribe(
            onNext: { [weak self] items in
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
