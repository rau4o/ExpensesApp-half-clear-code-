//
//  MainController.swift
//  myExpensesApp
//
//  Created by rau4o on 4/30/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit
import RealmSwift

// MARK: - static properties

private let cellId = "cellId"
private let rowHeight: CGFloat = 80

class MainController: UIViewController {
    
    // MARK: - Properties
    
    var entitesArray: Results<EntityModel>?
    var mainCash: Int = 1200
    var revenueCash: Int = 0
    var expenseCash: Int = 0
    var entity = EntityModel()
    let cashDefault = UserDefaults.standard
    
    // MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HistoryTransactionViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let balanceTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш баланс"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        return label
    }()
    
    private let cashTextLabel: UILabel = {
        let label = UILabel()
        label.text = "0$"
        label.minimumScaleFactor = 0.8
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = #colorLiteral(red: 0.1882352941, green: 0.5607843137, blue: 0.9058823529, alpha: 1)
        label.sizeToFit()
        return label
    }()
    
    private let revenueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 50/255, green: 143/255, blue: 87/255, alpha: 1)
        label.text = "+0$"
        return label
    }()
    
    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 231/255, green: 16/255, blue: 16/255, alpha: 1)
        label.text = "-0$"
        return label
    }()
    
    private lazy var spendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 27/255, green: 129/255, blue: 249/255, alpha: 0.86)
        button.setTitle("Потратить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSpendButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 27/255, green: 129/255, blue: 249/255, alpha: 0.86)
        button.setTitle("Попольнить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleAddButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private let inputTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Введите сумму"
        text.addShadow()
        text.keyboardType = .numberPad
        text.textAlignment = .center
        text.placeholder = "0"
        text.font = UIFont.boldSystemFont(ofSize: 30)
        return text
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ред.", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(#colorLiteral(red: 0.1882352941, green: 0.5607843137, blue: 0.9058823529, alpha: 1), for: .normal)
        return button
    }()
    
    private let allButton: UIButton = {
        let button = UIButton()
        button.setTitle("All", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(#colorLiteral(red: 0.1882352941, green: 0.5607843137, blue: 0.9058823529, alpha: 1), for: .normal)
        return button
    }()
    
    private let historyButton: UIButton = {
        let button = UIButton()
        button.setTitle("История пополнений", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(#colorLiteral(red: 0.5254901961, green: 0.5254901961, blue: 0.5254901961, alpha: 1), for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [spendButton,addButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initialSetup()
        getEntities()
        checkMainCash()
        checkRevenue()
        checkExpense()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cashTextLabel.text = "\(mainCash) $"
        revenueLabel.text = "+\(revenueCash)$"
        expenseLabel.text = "-\(expenseCash)$"
    }
    
    // MARK: - Helper function
    
    private func checkRevenue() {
        if cashDefault.value(forKey: "revenueCash") != nil {
            revenueCash = cashDefault.value(forKey: "revenueCash")! as! Int
            revenueLabel.text = NSString(format: "", "+\(revenueCash)") as String
        } else {
            revenueLabel.text = "+\(revenueCash)$"
        }
    }
    
    private func checkExpense() {
        if cashDefault.value(forKey: "expenseCash") != nil {
            expenseCash = cashDefault.value(forKey: "expenseCash")! as! Int
            expenseLabel.text = NSString(format: "", "-\(expenseCash)") as String
        } else {
            revenueLabel.text = "-\(expenseCash)$"
        }
    }
    
    private func checkMainCash() {
        if (cashDefault.value(forKey: "cashDefault") != nil){
        mainCash = cashDefault.value(forKey: "cashDefault")! as! Int
        cashTextLabel.text = NSString(format: "", mainCash) as String
        } else {
            cashTextLabel.text = "\(mainCash) $"
        }
    }
    
    private func getEntities() {
        self.entitesArray = RealmService.shared.realm.objects(EntityModel.self)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Selectors
    
    @objc private func handleSpendButtonPressed(_ sender: UIButton) {
        let inputText = "\(inputTextField.text ?? "")$"
        guard let secondMove = Int(inputTextField.text!) else {return}
        mainCash -= secondMove
        entity.mainCash = mainCash
        expenseCash += secondMove
        
        cashTextLabel.text = "\(entity.mainCash) $"
        expenseLabel.text = "-\(expenseCash)$"
        
        cashDefault.setValue(entity.mainCash, forKey: "cashDefault")
        cashDefault.synchronize()
        cashDefault.setValue(expenseCash, forKey: "expenseCash")
        cashDefault.synchronize()
        
        let alert = UIAlertController(title: "Назовите ваши расходы", message: "Запишите ваши расходы", preferredStyle: .alert)
        alert.addTextField { (textField1) in
            textField1.placeholder = "Enter name"
        }
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            guard let nameTextField = alert.textFields?[0] else {return}
            
            let entryModel = EntityModel(name: nameTextField.text ?? "", cash: inputText, type: "Снятие", mainCash: self.entity.mainCash)
            RealmService.shared.create(entryModel)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func handleAddButtonPressed(_ sender: UIButton) {
        let inputText = "\(inputTextField.text ?? "")$"
        guard let secondMove = Int(inputTextField.text!) else {return }
        mainCash += secondMove
        entity.mainCash = mainCash
        revenueCash += secondMove
        
        cashTextLabel.text = "\(entity.mainCash) $"
        revenueLabel.text = "+\(revenueCash)$"
        
        cashDefault.setValue(entity.mainCash, forKey: "cashDefault")
        cashDefault.synchronize()
        cashDefault.setValue(revenueCash, forKeyPath: "revenueCash")
        cashDefault.synchronize()
        
        let alert = UIAlertController(title: "Назовите ваши расходы", message: "Запишите ваши расходы", preferredStyle: .alert)
        alert.addTextField { (textField1) in
            textField1.placeholder = "Enter name"
        }
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            guard let nameTextField = alert.textFields?[0] else {return}
            
            let entryModel = EntityModel(name: nameTextField.text ?? "", cash: inputText, type: "Пополнение", mainCash: self.entity.mainCash)
            RealmService.shared.create(entryModel)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "12.03.2020"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.gray
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entitesArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HistoryTransactionViewCell {
            cell.selectionStyle = .none
            if let entity = entitesArray?[indexPath.row] {
                cell.configureCell(with: entity)
                if entity.type == "Пополнение"  {
                    cell.typeDescLabel.textColor = UIColor(red: 50/255, green: 143/255, blue: 87/255, alpha: 1)
                } else if entity.type == "Снятие" {
                    cell.typeDescLabel.textColor = UIColor(red: 231/255, green: 16/255, blue: 16/255, alpha: 1)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - SetupUI

private extension MainController {
    func initialSetup() {
        layoutUI()
    }
    
    private func layoutUI() {
        
        [balanceTextLabel, cashTextLabel, revenueLabel, expenseLabel, tableView, inputTextField, stackView, editButton, historyButton, allButton].forEach {
            view.addSubview($0)
        }
        
        balanceTextLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 52, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 204, height: 43)
        
        editButton.anchor(top: balanceTextLabel.topAnchor, left: nil, bottom: balanceTextLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 12, paddingRight: 27, width: 40, height: 19)
        
        cashTextLabel.anchor(top: balanceTextLabel.bottomAnchor, left: balanceTextLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 130, height: 44)
        
        revenueLabel.anchor(top: cashTextLabel.topAnchor, left: cashTextLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 60, height: 17)
        
        expenseLabel.anchor(top: revenueLabel.bottomAnchor, left: cashTextLabel.rightAnchor, bottom: cashTextLabel.bottomAnchor, right: nil, paddingTop: 1, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 60, height: 17)
        
        historyButton.anchor(top: cashTextLabel.bottomAnchor, left: cashTextLabel.leftAnchor, bottom: tableView.topAnchor, right: nil, paddingTop: 37, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 159, height: 21)
        
        allButton.anchor(top: historyButton.topAnchor, left: nil, bottom: historyButton.bottomAnchor, right: editButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 18)
        
        tableView.anchor(top: historyButton.bottomAnchor, left: view.leftAnchor, bottom: inputTextField.topAnchor, right: view.rightAnchor, paddingTop: 37, paddingLeft: 23, paddingBottom: 10, paddingRight: 23)
        
        inputTextField.anchor(top: nil, left: view.leftAnchor, bottom: stackView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 100)
        
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 60)
    }
}
