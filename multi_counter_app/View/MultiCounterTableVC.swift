//
//  MultiCounterTableVC.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2024/12/28.
//

import UIKit
import Verge

class MultiCounterTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let addCounterButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        tableView.register(CounterCell.self, forCellReuseIdentifier: CounterCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        setupUI()
        
        setupBindings()
    }
    
    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Counterを追加するボタン
        addCounterButton.setTitle("Add Counter", for: .normal)
        addCounterButton.translatesAutoresizingMaskIntoConstraints = false
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
    // MARK: - MultiCounterTableVCのメソッド
    private var cancellable: VergeAnyCancellable?
    private func setupBindings() {
        addCounterButton.addTarget(self, action: #selector(addAnotherCounter), for: .touchUpInside)
        
        cancellable = VergeAnyCancellable(countersStore.sinkState { [weak self] state in
            print("sinkState triggered with \(state.counters.count) counters")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
        
    }
    
    @objc private func addAnotherCounter() {
        countersStore.commit { state in
            let newCounter = Counter(id: UUID(), count: 0)
            state.counters.append(newCounter)
            print("Added new counter: \(state.counters)")
        }
    }
    
    
    // MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countersStore.state.counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CounterCell.reuseIdentifier, for: indexPath) as! CounterCell
        let counter = countersStore.state.counters[indexPath.row]
        
        cell.countLabel.text = "\(counter.count)"
        cell.incrementAction = {
            countersStore.commit { state in
                state.counters[indexPath.row].count += 1
            }
        }
        cell.decrementAction = {
            countersStore.commit { state in
                state.counters[indexPath.row].count -= 1
            }
        }
        return cell
    }
}

