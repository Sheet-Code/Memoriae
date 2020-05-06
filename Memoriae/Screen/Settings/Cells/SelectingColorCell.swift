//
//  SelectingColorCell.swift
//  Memoriae
//
//  Created by panandafog on 06.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class SelectingColorCell: UITableViewCell, SettingsCell {

    let buttonDiameter = CGFloat(30)
    let colors: [UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemIndigo, .systemBlue, .systemPurple]
    var buttons: [UIButton] = []

    @IBOutlet private var label: UILabel!
    
    override func prepareForReuse() {

        super.prepareForReuse()
        label.text = nil
    }

    func setup(with details: SettingsCellDetails) {

        switch details {

        case .selectColor:

            let cellWidth = self.contentView.bounds.width
            let leftIndent = self.buttonDiameter * 1.5
            let rightIndent = leftIndent / 2
            let availableGap = cellWidth - (leftIndent + rightIndent)
            let indentsSum = availableGap - (buttonDiameter * CGFloat(colors.count))
            let indent = indentsSum / CGFloat(colors.count - 1)

            var currentIndent = CGFloat(0)

            for index in 0 ... colors.count - 1 {

                buttons.append(createButton(index: index, position: CGPoint(x: leftIndent + currentIndent, y: label.center.y + 30)))
                currentIndent += buttonDiameter + indent
                buttons[index].addTarget(self, action: #selector(self.changeColor(sender:)), for: .touchUpInside)
                self.contentView.addSubview(buttons[index])
            }

            if colors.contains(ColorScheme.tintColor) {

                for index in 0 ... colors.count - 1 where colors[index] == ColorScheme.tintColor {

                    selectButton(buttons[index])
                }
            }

        default:

            break
        }
    }

    func createButton(index: Int, position: CGPoint) -> UIButton {

        let button = UIButton(frame: CGRect(x: position.x, y: position.y, width: buttonDiameter, height: buttonDiameter))
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = colors[index]
        button.tintColor = .clear

        button.setImage(UIImage(systemName: "checkmark"), for: .init())

        return button
    }

    @objc func changeColor(sender: UIButton) {

        selectButton(sender)

        guard let color = sender.backgroundColor else {
            return
        }

        ColorScheme.tintColor = color
        print(ColorScheme.tintColor)
    }

    func selectButton(_ button: UIButton) {

        for index in 0 ... buttons.count - 1 {
            unselectButton(buttons[index])
        }

        UIView.animate(withDuration: 0.3, animations: {
            button.tintColor = self.backgroundColor
        })
    }

    func unselectButton(_ button: UIButton) {

        UIView.animate(withDuration: 0.3, animations: {
            button.tintColor = .clear
        })
    }
}
