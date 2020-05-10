//
//  UIView.swift
//  Memoriae
//
//  Created by panandafog on 07.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

extension UIView {

    var parentViewController: UIViewController? {

        var parentResponder: UIResponder? = self

        while parentResponder != nil {

            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
}
