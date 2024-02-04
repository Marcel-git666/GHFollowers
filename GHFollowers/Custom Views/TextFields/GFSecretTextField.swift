//
//  GFSecretTextField.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 04.02.2024.
//

import Foundation

class GFSecretTextField: GFTextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.isSecureTextEntry = true
    }
}

