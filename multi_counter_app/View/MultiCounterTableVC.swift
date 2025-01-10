//
//  MultiCounterTableVC.swift
//  multi_counter_app
//

import UIKit
import Verge

class MultiCounterTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let addCounterButton = UIButton(type: .contactAdd)
    private let counterViewModel = CounterViewModel()
    
    private var cancellable: VergeAnyCancellable?
    
    deinit { cancellable = nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        
        tableView.register(CounterCell.self, forCellReuseIdentifier: CounterCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        bindViewModel()
    }
    
    private func setupUI() {
        tableView.accessibilityIdentifier = "CounterTableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        addCounterButton.setTitle(" Add Counter", for: .normal)
        addCounterButton.addTarget(self, action: #selector(addCounterButtonTapped), for: .touchUpInside)
        addCounterButton.accessibilityIdentifier = "Add Counter"
        addCounterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCounterButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addCounterButton.topAnchor, constant: -8),
            
            addCounterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addCounterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addCounterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            addCounterButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func bindViewModel() {
        cancellable = counterViewModel.observeCounters { [weak self] counters in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func addCounterButtonTapped() {
        MCVibrator.vibrate()
        counterViewModel.addCounter()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        counterViewModel.counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CounterCell.reuseIdentifier, for: indexPath) as! CounterCell
        let counter = counterViewModel.counters[indexPath.row]
        cell.configure(name: counter.name, count: counter.countNum)
        
        cell.incrementAction = { [weak self] in
            self?.counterViewModel.incrementCounter(at: indexPath.row)
        }
        cell.decrementAction = { [weak self] in
            self?.counterViewModel.decrementCounter(at: indexPath.row)
        }
        
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        // Divider用のViewを追加
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let counter = counterViewModel.counters[indexPath.row]
        let alert = UIAlertController(title: "名前を設定", message: nil, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "NameChangeAlert"
        
        alert.addTextField { textField in
            textField.placeholder = "名前を入力してください"
            textField.accessibilityIdentifier = "NameChangeTextField"
            textField.text = counter.name
        }
        
        let saveAction = UIAlertAction(title: "保存", style: .default) { [weak self] _ in
            if let text = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty {
                self?.counterViewModel.updateName(at: indexPath.row, with: text)
            }
        }
        saveAction.accessibilityIdentifier = "SaveButton"
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            counterViewModel.removeCounter(at: indexPath.row)
        }
    }
    
    // Deleteボタンの文字を変更
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "×"
    }
}
