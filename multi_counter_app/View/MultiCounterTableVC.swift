//
//  MultiCounterTableVC.swift
//  multi_counter_app
//

import UIKit
import Verge

class MultiCounterTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let addCounterButton = UIButton(type: .contactAdd)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        tableView.register(CounterCell.self, forCellReuseIdentifier: CounterCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        setupUI()
        
        CounterStore.shared.observe { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        addCounterButton.setTitle(" Add Counter", for: .normal)
        addCounterButton.translatesAutoresizingMaskIntoConstraints = false
        addCounterButton.addTarget(self, action: #selector(addCounter), for: .touchUpInside)
        view.addSubview(addCounterButton)
        
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
    
    @objc private func addCounter() {
        CounterDispatcher.shared.dispatch(action: .addCounter)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CounterStore.shared.counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CounterCell.reuseIdentifier, for: indexPath) as! CounterCell
        let counter = CounterStore.shared.counters[indexPath.row]
        cell.configure(name: counter.name, count: counter.countNum)
        
        cell.incrementAction = {
            CounterDispatcher.shared.dispatch(action: .increment(index: indexPath.row))
        }
        cell.decrementAction = {
            CounterDispatcher.shared.dispatch(action: .decrement(index: indexPath.row))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let counter = CounterStore.shared.counters[indexPath.row]
        let alert = UIAlertController(title: "名前を設定", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "名前を入力してください"
            textField.text = counter.name
        }
        
        let saveAction = UIAlertAction(title: "保存", style: .default) { _ in
            if let text = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty {
                CounterDispatcher.shared.dispatch(action: .updateName(index: indexPath.row, name: text))
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CounterDispatcher.shared.dispatch(action: .removeCounter(index: indexPath.row))
        }
    }
}
