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
private let rowHeight: CGFloat = 100

class MainController: UIViewController {
    
    // MARK: - Properties
    
    var entitesArray: Results<EntityModel>?
    var mainCash: Int = 1200
    var revenueCash: Int = 0
    var expenseCash: Int = 0
    var entity = EntityModel()
    let cashDefault = UserDefaults.standard
    
    private let tableView = UITableView()
    
    private let balanceTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш баланс"
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private let cashTextLabel: UILabel = {
        let label = UILabel()
        label.text = "0$"
        label.minimumScaleFactor = 0.8
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 40)
        label.backgroundColor = .white
        label.textColor = UIColor(red: 129/255, green: 208/255, blue: 250/255, alpha: 1)
        label.sizeToFit()
        return label
    }()
    
    private let revenueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.text = "+0$"
        label.backgroundColor = .white
        return label
    }()
    
    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "-0$"
        label.backgroundColor = .white
        return label
    }()
    
    private let spendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7725490196, blue: 1, alpha: 1)
        button.setTitle("Потратить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSpendButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7725490196, blue: 1, alpha: 1)
        button.setTitle("Попольнить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleAddButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private let inputTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Введите сумму "
        text.backgroundColor = .white
        text.addShadow()
        text.textColor = .black
        text.textAlignment = .center
        text.font = UIFont.boldSystemFont(ofSize: 30)
        return text
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutUI()
        configureTableView()
        getEntities()
        if (cashDefault.value(forKey: "cashDefault") != nil){
        mainCash = cashDefault.value(forKey: "cashDefault")! as! Int
        cashTextLabel.text = NSString(format: "", mainCash) as String
        } else {
            cashTextLabel.text = "\(mainCash) $"
        }
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
    
    private func configureTableView() {
        tableView.register(HistoryTransactionViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.anchor(top: cashTextLabel.bottomAnchor, left: view.leftAnchor, bottom: inputTextField.topAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
    }
    
    private func layoutUI() {
        
        let stackView = UIStackView(arrangedSubviews: [spendButton,addButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        addSubviews([balanceTextLabel,cashTextLabel,revenueLabel,expenseLabel,inputTextField,stackView])
        
        balanceTextLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 90)
        
        cashTextLabel.anchor(top: balanceTextLabel.bottomAnchor, left: balanceTextLabel.leftAnchor, bottom: nil, right: nil, paddingTop: -20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 70)
        
        revenueLabel.anchor(top: cashTextLabel.topAnchor, left: cashTextLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: -10, paddingRight: 0, width: 100, height: 50)
        
        expenseLabel.anchor(top: revenueLabel.bottomAnchor, left: cashTextLabel.rightAnchor, bottom: cashTextLabel.bottomAnchor, right: nil, paddingTop: -10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
        
        inputTextField.anchor(top: nil, left: view.leftAnchor, bottom: stackView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 100)
        
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 60)
    }
    
    private func getEntities() {
        entitesArray = RealmService.shared.realm.objects(EntityModel.self)
    }
    
    // MARK: - Selectors @objc
    
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
        revenueLabel.text = "+\(revenueCash)"
        
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
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "История пополнений"
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
            if let entity = entitesArray?[indexPath.row] {
                cell.configureCell(entity: entity)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        guard let pickUpLine = entitesArray?[indexPath.row] else {return}
        
        RealmService.shared.delete(pickUpLine)
        tableView.reloadData()
    }
}

// MARK: - Custom function

extension MainController {
    func addSubviews(_ views: [UIView]) {
        for i in views {
            view.addSubview(i)
        }
    }
}
