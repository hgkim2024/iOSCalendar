//
//  VCAddItem.swift
//  Schedule
//
//  Created by Asu on 2020/09/11.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

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
    
    func dismissAlert() {
        let alert = UIAlertController(title: nil, message: "이 새로운 이벤트를 폐기하겠습니까?".localized, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "변경 사항 폐기".localized, style: UIAlertAction.Style.cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "계속 편집하기".localized, style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func addTapped(_ sender: Any) {
        // TODO: - realm 에 저장하고 dismiss 할 것
        dismiss(animated: true, completion: nil)
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
        // TODO: - 테스트 코드 지울 것
        // presentationControllerShouldDismiss 값이
        // true: 닫기, false: 삭제 여부 얼럿창 띄우기
        
        if eventTitle.isEmpty {
            dismiss(animated: true, completion: nil)
        } else {
            dismissAlert()
        }
    }
}
