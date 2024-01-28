//
//  UITableViewCell+Ext.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 27.01.2024.
//

import UIKit

extension UITableViewCell {
    func addCustomDisclosureIndicator(with color: UIColor) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .large)
        let symbolImage = UIImage(systemName: "chevron.right",
                                  withConfiguration: symbolConfig)
        button.setImage(symbolImage?.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        button.tintColor = color
        self.accessoryView = button
    }
}
