//
//  IndexedButton.swift
//  Memoriae
//
//  Created by panandafog on 29.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation
import UIKit

class IndexedUIButton: UIButton {

    private var index: Int?

    func setIndex(index: Int){
        self.index = index
    }

    func getIndex() -> Int?{
        return self.index
    }
}
