//
//  HistoryTransactionViewCell.swift
//  myExpensesApp
//
//  Created by rau4o on 4/30/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit

class HistoryTransactionViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.addShadow()
        return view
    }()
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let typeDescLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 50/255, green: 143/255, blue: 87/255, alpha: 1)
        return label
    }()
    
    private let cashLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    // MARK: - Helper function
    
    private func layoutUI() {
        addSubview(cardView)
        [mainTitleLabel, typeDescLabel, cashLabel].forEach {
            cardView.addSubview($0)
        }
        
        cardView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        
        mainTitleLabel.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, bottom: nil, right: cardView.rightAnchor, paddingTop: 10, paddingLeft: 11, paddingBottom: 0, paddingRight: 0, height: 20)
        
        typeDescLabel.anchor(top: mainTitleLabel.bottomAnchor, left: mainTitleLabel.leftAnchor, bottom: cardView.bottomAnchor, right: nil, paddingTop: 11, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 100, height: 12)
        
        cashLabel.anchor(top: mainTitleLabel.bottomAnchor, left: nil, bottom: cardView.bottomAnchor, right: cardView.rightAnchor, paddingTop: 11, paddingLeft: 0, paddingBottom: 10, paddingRight: 12, width: 100, height: nil)
    }
    
    func configureCell(with entity: EntityModel) {
        DispatchQueue.main.async {
            self.mainTitleLabel.text = entity.name
            self.cashLabel.text = entity.cash
            self.typeDescLabel.text = entity.type
        }
    }
    
    // MARK: required init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
