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
    
    private var index: Int?
    private var controller: TOMMPictureAnswersViewController?
    private var selectedAnswer: Int?
    
    @IBOutlet private var stack: UIStackView!
    @IBOutlet private var questionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.questionLabel.text = nil

        self.stack.removeAllArrangedSubviews()
        options = []
    }
    
    func setup(with question: Question, answersAreSubmitted: Bool, controller: TOMMPictureAnswersViewController, index: IndexPath) {
        self.question = question
        self.questionLabel.text = String(index.row + 1) + ". " + question.question
        
        guard let answers = self.question?.answers else {
            return
        }

        for index in 0...answers.count - 1 {

            let button = IndexedUIButton(type: .system)
            button.setIndex(index: index)
            buttonSetup(button: button)
            button.setTitle(answers[index], for: .init())

            stack.addArrangedSubview(button)
            options.append(button)
        }

        self.index = index.row
        self.controller = controller

        guard let selected = controller.getSelectedAnswer(index: index.row) else {
            return
        }

        self.selectedAnswer = selected
        self.pressButton(index: selected)

        if answersAreSubmitted {
            submitAnswer()
        }
    }
    
    @objc func pressed(sender: IndexedUIButton) {
        
        guard let selectedAnswerIndex = sender.getIndex() else {
            return
        }
        
        pressButton(index: selectedAnswerIndex)

        guard let controller = self.controller, let index = self.index else {
            return
        }

        controller.selectAnswer(index: index, answer: selectedAnswerIndex)
    }

    func pressButton(index: Int) {

        guard let count = self.question?.answers.count else {
            return
        }

        for index in 0...count - 1 {
            options[index].isSelected = false
        }

        options[index].isSelected = true
        self.selectedAnswer = index

    }
    
    func buttonSetup(button: UIButton) {
        button.setTitleColor(.systemOrange, for: .init())
        button.tintColor = .systemOrange
        button.addTarget(self, action: #selector(TOMMAnswerCell.pressed(sender:)), for: .touchUpInside)
    }
    
    func submitAnswer() {
        for index in 0...options.count - 1 {
            stack.arrangedSubviews[index].isUserInteractionEnabled = false
        }
        
        guard let selected = selectedAnswer, let selectedButton = stack.arrangedSubviews[selected] as? UIButton else {
            return
        }
        
        if selectedAnswer == question?.rightAnswer {
            selectedButton.tintColor = .systemGreen
        } else {
            selectedButton.tintColor = .red
        }
    }
}
