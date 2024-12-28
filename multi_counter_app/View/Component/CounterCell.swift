//
//  CounterCell.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2024/12/28.
//

import UIKit

class CounterCell: UITableViewCell {
    static let reuseIdentifier = "CounterCell"
    let countLabel = UILabel()
    let incrementButton = UIButton(type: .system)
    let decrementButton = UIButton(type: .system)
    
    var incrementAction: (() -> Void)?
    var decrementAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // カウントした数字を表示
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countLabel)
        
        // +ボタン
        incrementButton.setTitle("+", for: .normal)
        incrementButton.translatesAutoresizingMaskIntoConstraints = false
        
        // -ボタン
        decrementButton.setTitle("", for: .normal)
        decrementButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 数字のラベルの制約
            countLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // 増加ボタンの制約
            incrementButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            incrementButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // 減少ボタンの制約
            decrementButton.leftAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            decrementButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func incrementTapped() {
        incrementAction?()
    }
    @objc private func decrementTapped() {
        decrementAction?()
    }
}
