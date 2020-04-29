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
    
    private var selectedAnswer: Int?
    
    @IBOutlet private var stack: UIStackView!
    @IBOutlet private var questionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.questionLabel.text = nil
    }
    
    func getSelectedAnswer() -> Int? {
        selectedAnswer
    }
    
    func setup(with question: Question, controller: TOMMPictureAnswersViewController, index: IndexPath) {
        self.question = question
        self.questionLabel.text = String(index.row + 1) + ". " + question.question
        
        guard let answers = self.question?.answers else {
            return
        }
        if stack.arrangedSubviews.isEmpty == true {
            for index in 0...answers.count - 1 {
                
                let button = IndexedUIButton(type: .system)
                button.setIndex(index: index)
                buttonSetup(button: button)
                stack.addArrangedSubview(button)
                button.setTitle(answers[index], for: .init())
                
                options.append(button)
            }
        }
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
        selectedAnswer = selectedIndex
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
