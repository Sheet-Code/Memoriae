//
//  LevelPreviewController.swift
//  Memoriae
//
//  Created by panandafog on 27.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation
import UIKit

class LevelPreviewController: UIViewController {

    var level: Level?

    @IBOutlet private var topBar: UINavigationItem!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let nNLevel = level else {
            return
        }
//        topBar.title = nNLevel.title
        self.navigationItem.title = nNLevel.title
    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        guard let nNLevel = level else {
//            return
//        }
//        topBar.title = nNLevel.title
//    }

}
