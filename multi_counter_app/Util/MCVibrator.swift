//
//  MCVibrator.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2025/01/10.
//

import UIKit

class MCVibrator {
    static func vibrate() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
}
