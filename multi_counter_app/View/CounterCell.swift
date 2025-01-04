//
//  CounterCell.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2024/12/28.
//

import UIKit

class CounterCell: UITableViewCell {
    static let reuseIdentifier = "CounterCell"
    
    private let nameLabel = UILabel()
    private let countLabel = UILabel()
    private let labelStackView = UIStackView()
    
    let incrementButton = UIButton(type: .system)
    let decrementButton = UIButton(type: .system)
    
    var incrementAction: (() -> Void)?
    var decrementAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // セル選択時のハイライトを無効化
        selectionStyle = .none
        
        // Counterの名前
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textAlignment = .center
        nameLabel.isHidden = true
        
        // カウントした数字を表示
        countLabel.textAlignment = .center
        
        // stack viewの設定
        labelStackView.axis = .vertical
        labelStackView.alignment = .center
        labelStackView.spacing = 4
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelStackView)
        
        // 名前とカウントした数字をstack viewに追加
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(countLabel)
        contentView.addSubview(labelStackView)
        
        // +ボタン
        incrementButton.setTitle("+", for: .normal)
        incrementButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(incrementButton)
        
        // -ボタン
        decrementButton.setTitle("-", for: .normal)
        decrementButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(decrementButton)
        
        incrementButton.addTarget(self, action: #selector(incrementTapped), for: .touchUpInside)
        decrementButton.addTarget(self, action: #selector(decrementTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // スタックビューを中央に配置
            labelStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // 増加ボタンの制約
            incrementButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            incrementButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // 減少ボタンの制約
            decrementButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            decrementButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // セルを設定するメソッド
    func configure(name: String?, count: Int) {
        if let name = name {
            nameLabel.isHidden = false
            nameLabel.text = name
        } else {
            nameLabel.isHidden = true
        }
        countLabel.text = "\(count)"
    }
    
    @objc private func incrementTapped() {
        incrementAction?()
    }
    @objc private func decrementTapped() {
        decrementAction?()
    }
}
