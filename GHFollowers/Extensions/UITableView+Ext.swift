//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 27.01.2024.
//

import UIKit

extension UITableView {
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }

    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
}
