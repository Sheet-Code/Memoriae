//
//  Score.swift
//  Memoriae
//
//  Created by panandafog on 29.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation
import RealmSwift

class ScoreRealm: Object {
    @objc dynamic var type = ""
    @objc dynamic var number = ""
    @objc dynamic var score = ""
    @objc dynamic var max = ""

    override class func primaryKey() -> String? {
        "id"
    }
}

// MARK: - MemeRealm
extension ScoreRealm {
//    var post: Post {
//        Post(id: id, title: title, tags: [Post.Tag(name: tags)], images: [Post.Image(id: nil, title: nil, type: nil, link: image)])
//    }

//    convenience init() {
//        self.init()
//        id = post.id
//        title = post.title
//        guard let images = post.images, let first = images.first else { return }
//        image = first.link
//        guard let tags = post.tags else { return }
//        self.tags = tags.map { $0.name }.joined(separator: ", ")
//    }
}
