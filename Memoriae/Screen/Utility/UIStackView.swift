//
//  UIStackView.swift
//  Memoriae
//
//  Created by panandafog on 01.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

extension UIStackView {

    func removeAllArrangedSubviews() {

        let removedSubviews = arrangedSubviews.reduce(into: [UIView]()) { allSubviews, subview  in
             self.removeArrangedSubview(subview)
            allSubviews.append(subview)
        }

        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))

        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
