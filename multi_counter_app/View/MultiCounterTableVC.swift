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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CounterCell.reuseIdentifier, for: indexPath) as! CounterCell
        let counter = CounterViewModel.shared.getCounters[indexPath.row]
        
        cell.countLabel.text = "\(counter.count)"
        cell.incrementAction = {
            CounterViewModel.shared.incrementCounter(at: indexPath.row)
        }
        cell.decrementAction = {
            CounterViewModel.shared.decrementCounter(at: indexPath.row)
        }
        
        return cell
    }
}