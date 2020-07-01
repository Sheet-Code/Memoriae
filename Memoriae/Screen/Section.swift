//
//  Section.swift
//  Memoriae
//
//  Created by panandafog on 01.07.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation
import UIKit

struct Section {
    var name: String
    var items: [Level]
    var collapsed: Bool

    init(name: String, items: [Level], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

@objc protocol CollapsibleDelegate {
    func toggleSection(header: CollapsibleHeader, section: Int)
}

class CollapsibleHeader: UITableViewHeaderFooterView {
    let title = UILabel()
    let arrow = UILabel()

    weak var delegate: CollapsibleDelegate?
    var section: Int = 0

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        contentView.addSubview(arrow)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(_:))))
//        arrow.widthAnchor.constraint(equalToConstant: 12).isActive = true
//        arrow.heightAnchor.constraint(equalToConstant: 12).isActive = true
//        title.translatesAutoresizingMaskIntoConstraints = false
//        arrow.translatesAutoresizingMaskIntoConstraints = false
        let marginGuide = contentView.layoutMarginsGuide

        // Arrow label
        arrow.textColor = UIColor.white
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrow.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        arrow.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        arrow.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true

        // Title label
        title.textColor = UIColor.white
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleHeader else {
            return
        }
        delegate?.toggleSection(header: self, section: cell.section)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let views = [
            "title": title,
            "arrow": arrow
        ]
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[title]-[arrow]-20-|",
            options: [],
            metrics: nil,
            views: views
        ))
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[title]-5-|",
            options: [],
            metrics: nil,
            views: views
        ))
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[arrow]-5-|",
            options: [],
            metrics: nil,
            views: views
        ))
    }

    func collapse(collapsed: Bool) {
        arrow.rotate(collapsed ? 0.0 : .pi / 2)
    }
}

extension UIView {

    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")

        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards

        self.layer.add(animation, forKey: nil)
    }
}
