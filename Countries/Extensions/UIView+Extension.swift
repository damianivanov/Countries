//
//  UIView+Extension.swift
//  Countries
//
//  Created by Damian Ivanov on 17.01.24.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }

    func tamicFalse() {
        subviews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
