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
    @IBOutlet private var stack: UIStackView!

    override func prepareForReuse() {

        super.prepareForReuse()
        label.text = nil
    }

    func setup(with details: SettingsCellDetails) {

        switch details {

        case .selectColor:

            for index in 0 ... colors.count - 1 {

                buttons.append(createButton(index: index, position: CGPoint(x: 0, y: 0)))
                buttons[index].addTarget(self, action: #selector(self.changeColor(sender:)), for: .touchUpInside)
                self.stack.addArrangedSubview(buttons[index])

            }

            for index in 0 ... colors.count - 1 where colors[index].cgColor == ColorScheme.tintColor.cgColor {
                    selectButton(buttons[index])
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

        NSLayoutConstraint.activate([
                      button.widthAnchor.constraint(equalToConstant: buttonDiameter)
        ])
        NSLayoutConstraint.activate([
                      button.heightAnchor.constraint(equalToConstant: buttonDiameter)
        ])

        return button
    }

    @objc func changeColor(sender: UIButton) {

        selectButton(sender)

        guard let color = sender.backgroundColor else {
            return
        }

        ColorScheme.changeColor(to: color)

        let alert = UIAlertController(title: "New color",
                                      message: "To apply changes reopen the application",
                                      preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: "Close", style: .default, handler: nil)

        deleteAction.setValue(ColorScheme.tintColor, forKey: "titleTextColor")

        alert.addAction(deleteAction)

        parentViewController?.present(alert, animated: true, completion: nil)
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
