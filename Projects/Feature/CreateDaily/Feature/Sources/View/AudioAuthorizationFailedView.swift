//
//  AudioAuthorizationFailedView.swift
//  CreateDaily
//
//  Created by choijunios on 2/28/25.
//

import UIKit

final class AudioAuthorizationFailedView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    required init?(coder: NSCoder) { nil }
}


private extension AudioAuthorizationFailedView {
    func setupUI() {
        // self
        self.backgroundColor = .red
    }
}
