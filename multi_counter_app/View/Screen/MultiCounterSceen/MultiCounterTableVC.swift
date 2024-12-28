//
//  MultiCounterTableVC.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2024/12/28.
//

import UIKit

// tableView
extension MultiCounterTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.state.counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CounterCell.reuseIdentifier, for: indexPath) as! CounterCell
        let counter = store.state.counters[indexPath.row]
        
        cell.countLabel.text = "\(counter.count)"
        cell.incrementAction = {
            store.commit { state in
                state.counters[indexPath.row].count += 1
            }
        }
        cell.decrementAction = {
            store.commit { state in
                state.counters[indexPath.row].count -= 1
            }
        }
        return cell
    }
}


class MultiCounterTableVC: UIViewController {
    private let tableView = UITableView()
    private let addCounterButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        tableView.register(CounterCell.self, forCellReuseIdentifier: CounterCell.reuseIdentifier)
        tableView.delegate = self
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
            
            addCounterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addCounterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addCounterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            addCounterButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}



//class MultiCounterViewControllel: UIViewController {
//    private let tableView = UITableView()
//    private let addButton = UIButton(type: .system)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .white
//        setupUI()
//        setupBindings()
//    }
//
//    private func setupUI() {
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        addButton.translatesAutoresizingMaskIntoConstraints = false
//
//        addButton.setTitle("Add Counter", for: .normal)
//
//        view.addSubview(tableView)
//        view.addSubview(addButton)
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -8),
//
//            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
//            addButton.heightAnchor.constraint(equalToConstant: 44),
//        ])
//
//        tableView.register(CounterCell.self, forCellReuseIdentifier: CounterCell.reuseIdentifier)
//        tableView.dataSource = self
//    }
//
//    private func setupBindings() {
//        addButton.addTarget(self, action: #selector(addCounter), for: .touchUpInside)
//
//        store.sinkState { [weak self] state in
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
//    }
//
//    @objc private func addCounter() {
//        store.commit { state in
//            state.counters.append(Counter(id: UUID(), count: 0))
//        }
//    }
//}
//
