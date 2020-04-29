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
    @IBOutlet private var task: UILabel!
    @IBOutlet private var descript: UILabel!
    @IBOutlet private var image: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let nNLevel = level else {
            return
        }

        self.navigationItem.title = nNLevel.title
        task.text = nNLevel.task
        descript.text = nNLevel.description
        self.tabBarController?.tabBar.isHidden = true
        guard let pic = level?.picture else {
            return
        }
        image.image = UIImage(named: pic)
        //        self.startButon.addTarget(self, action: Selector("openLevel:"), for: UIControl.Event.touchUpInside)
    }

    @IBAction private func startTest(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let newViewController = storyBoard.instantiateViewController(identifier: "TOMMPictureViewController") as? TOMMPictureViewController else {
            return
        }
        newViewController.level = level
        //PEDERAT'
        navigationController?.pushViewController(newViewController, animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
}
