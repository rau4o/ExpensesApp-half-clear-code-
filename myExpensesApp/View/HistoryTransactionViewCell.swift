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
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let typeDescLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    private let cashLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
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
        cardView.addSubview(mainTitleLabel)
        cardView.addSubview(typeDescLabel)
        cardView.addSubview(cashLabel)
        
        cardView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        
        mainTitleLabel.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, bottom: nil, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: 50)
        
        typeDescLabel.anchor(top: mainTitleLabel.bottomAnchor, left: mainTitleLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
        
        cashLabel.anchor(top: mainTitleLabel.bottomAnchor, left: nil, bottom: cardView.bottomAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 10, paddingRight: 5, width: 100, height: nil)
    }
    
    func configureCell(entity: EntityModel) {
        mainTitleLabel.text = entity.name
        cashLabel.text = entity.cash
        typeDescLabel.text = entity.type
    }
    
    // MARK: required init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
