//
//  TOMMAnswerCell.swift
//  Memoriae
//
//  Created by panandafog on 27.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation
import UIKit

class TOMMAnswerCell: UITableViewCell {

    var question: Question?
    var options: [UIButton] = [UIButton]()

    @IBOutlet private var stack: UIStackView!
    @IBOutlet private var questionLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.questionLabel.text = nil
    }

    func setup(with question: Question, controller: TOMMPictureAnswersViewController, index: IndexPath) {
        self.question = question
        self.questionLabel.text = question.question

        guard let answers = self.question?.answers else {
            return
        }

        let  testLabel1 = UILabel()
        testLabel1.text = ("mark 1")
        stack.addArrangedSubview(testLabel1)

        for index in 0...answers.count - 1 {

            let button = IndexedUIButton(type: .system)
            button.setIndex(index: index)
            buttonSetup(button: button)
            stack.addArrangedSubview(button)
            button.setTitle(answers[index], for: .init())

            options.append(button)
        }

        let testLabel2 = UILabel()
        testLabel2.text = ("mark last")
        stack.addArrangedSubview(testLabel2)
    }

    @objc func pressed(sender: IndexedUIButton) {
        guard let count = self.question?.answers.count else {
            return
        }

        for index in 0...count - 1 {
            options[index].isSelected = false
        }

        guard let selectedIndex = sender.getIndex() else {
            return
        }
        
        options[selectedIndex].isSelected = true
    }

    func buttonSetup(button: UIButton) {
        button.setTitleColor(.systemOrange, for: .init())
        button.tintColor = .systemOrange
        button.addTarget(self, action: #selector(TOMMAnswerCell.pressed(sender:)), for: .touchUpInside)
    }
}
