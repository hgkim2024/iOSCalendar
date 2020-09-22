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

class VCAddItem: UIViewController {
    
    var tableView: UITableView!
    
    var add: UIBarButtonItem!
    var eventTitle: String = "" {
        didSet {
            print("didSet eventTitle: \(eventTitle)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        displayUI()
    }
    
    func setUpUI() {
        title = "이벤트".localized
        
        let cancel = UIBarButtonItem(title: "취소".localized, style: .plain, target: self, action: #selector(cancelTapped))

        navigationItem.leftBarButtonItem = cancel
        
        add = UIBarButtonItem(title: "추가".localized, style: .plain, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = add
        add.isEnabled = false
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    }
    
    func dismissNotification() {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NamesOfNotification.refreshCalendar),
            object: nil,
            userInfo: nil
        )
    }
    
    func dismissAlert() {
        let alert = UIAlertController(title: nil, message: "이 새로운 이벤트를 폐기하겠습니까?".localized, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "변경 사항 폐기".localized, style: UIAlertAction.Style.cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "계속 편집하기".localized, style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func addTapped(_ sender: Any) {
        // TODO: - 여러 인자 추가 시, 추가 반영
        let item = Item()
        item.title = eventTitle
        Item.add(item: item).subscribe(
            onNext: { [weak self] item in
                guard let `self` = self else { return }
                self.dismiss(animated: true) {
                    self.dismissNotification()
                }
            },
            onError: { [weak self] error in
                guard let `self` = self else { return }
                let alert = UIAlertController(title: nil, message: "저장에 실패하였습니다.".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인".localized, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }).dispose()
    }
    
    @objc func cancelTapped(_ sender: Any) {
        if eventTitle.isEmpty {
            dismiss(animated: true, completion: nil)
        } else {
            dismissAlert()
        }
    }
}


extension VCAddItem: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        
        if eventTitle.isEmpty {
            dismiss(animated: true, completion: nil)
        } else {
            dismissAlert()
        }
    }
}
