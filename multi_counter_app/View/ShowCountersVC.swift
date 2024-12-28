//
//  ShowCountersVC.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2024/12/28.
//

import UIKit
import Verge

class ShowCountersVC: UIViewController {
    private let store: Store<AppState, AppAction>

    private let label = UILabel()
    private let incrementButton = UIButton(type: .system)
    private let decrementButton = UIButton(type: .system)

    init(store: Store<AppState, AppAction>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // UIのセットアップ
        setupUI()

        // Storeの状態を監視
        store.sinkState { [weak self] state in
            self?.label.text = "Count: \(state.count)"
        }
    }

    private func setupUI() {
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32)

        incrementButton.setTitle("Increment", for: .normal)
        incrementButton.addTarget(self, action: #selector(incrementTapped), for: .touchUpInside)

        decrementButton.setTitle("Decrement", for: .normal)
        decrementButton.addTarget(self, action: #selector(decrementTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [label, incrementButton, decrementButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func incrementTapped() {
        store.send(.increment)
    }

    @objc private func decrementTapped() {
        store.send(.decrement)
    }
}
