//
//  MultiCounterTableVC.swift
//  multi_counter_app
//

import UIKit
import Verge

class MultiCounterTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let addCounterButton = UIButton(type: .system)
    
    private var cancellable: VergeAnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        tableView.register(CounterCell.self, forCellReuseIdentifier: CounterCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        setupUI()
        
        setupBindings()
    }
    
    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Counterを追加するボタン
        addCounterButton.setTitle("Add Counter", for: .normal)
        addCounterButton.translatesAutoresizingMaskIntoConstraints = false
        addCounterButton.addTarget(self, action: #selector(addAnotherCounter), for: .touchUpInside)
        view.addSubview(addCounterButton)
        
        // テーブルビューの下部にスペースを追加
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addCounterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addCounterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addCounterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            addCounterButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupBindings() {
        cancellable = CounterViewModel.shared.observeState { [weak self] state in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func addAnotherCounter() {
        CounterViewModel.shared.addCounter()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CounterViewModel.shared.getCounters.count
    }
    
    // セルの内容を生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CounterCell.reuseIdentifier, for: indexPath) as! CounterCell
        let counter = CounterViewModel.shared.getCounters[indexPath.row]
        
        cell.configure(name: counter.name, count: counter.countNum)
        
        cell.incrementAction = {
            CounterViewModel.shared.incrementCounter(at: indexPath.row)
        }
        cell.decrementAction = {
            CounterViewModel.shared.decrementCounter(at: indexPath.row)
        }
        
        return cell
    }
    
    // セルを選択した時に名前の変更アラートを出す
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let counter = CounterViewModel.shared.getCounters[indexPath.row]
        let alert = UIAlertController(title: "名前を設定", message: nil, preferredStyle: .alert)
        
        // テキストフィールドに現在の名前をプリセット
        alert.addTextField { textField in
            textField.placeholder = "名前を入力してください"
            textField.text = counter.name
        }
        
        // 保存アクション
        let saveAction = UIAlertAction(title: "保存", style: .default) { _ in
            if let text = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty, text.count <= 20 {
                CounterViewModel.shared.updateName(at: indexPath.row, with: text)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                // バリデーションエラーメッセージ
                let errorAlert = UIAlertController(title: "エラー", message: "名前は空白を除いた上で20文字以下にしてください。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(errorAlert, animated: true)
            }
        }
        
        // キャンセルアクション
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // セルが編集可能であることを指定
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // スワイプで削除を実装
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データの削除
            CounterViewModel.shared.removeCounter(at: indexPath.row)
            
            // テーブルビューを更新
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
