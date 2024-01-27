//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 26.01.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}
