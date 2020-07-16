//
//  AchievementsCell.swift
//  Memoriae
//
//  Created by panandafog on 03.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation
import UIKit

class AchievementsCell: UITableViewCell {

    // MARK: - Size & Layout
    static let progressViewHeight = CGFloat(100)
    static let progressViewWidth = CGFloat(10)

    static let pictureHeight = CGFloat(100)
    static var pictureWidth: CGFloat {
        pictureHeight
    }

    static let labelHeight = CGFloat(20)

    static let border = CGFloat(20)

    static var cellHeight: CGFloat {
        border * 4 + labelHeight + progressViewHeight
    }

    var results: [Float] = []
    var progressBars: [UIProgressView] = []

    private let timeStep: Float = 0.01
    private var limits: [Float] = []

    @IBOutlet private var title: UILabel!
    @IBOutlet private var picture: UIImageView!

    @IBOutlet private var minLabel: UILabel!
    @IBOutlet private var maxLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        picture.image = nil
        title.text = nil
        results.removeAll()
        limits.removeAll()
        for progressElement in progressBars {
            progressElement.removeFromSuperview()
        }
        progressBars = [UIProgressView]()
    }

    func setup(with level: Level) {
        guard var score = ScoreRepositoryImpl.getScores(levelId: level.id) else { return }
        score.sort { $0.difficulty < $1.difficulty }
        title.text = level.title
        picture.layer.cornerRadius = 8.0
        minLabel.textColor = ColorScheme.tintColor
        maxLabel.textColor = ColorScheme.tintColor
        title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: AchievementsCell.border).isActive = true
        title.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: AchievementsCell.border).isActive = true
        picture.topAnchor.constraint(equalTo: title.bottomAnchor, constant: AchievementsCell.border).isActive = true
        picture.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: AchievementsCell.border * 1.5).isActive = true
        guard let difficulties = level.difficulties else { return }
        if !difficulties.isEmpty {
            let progressAreaWidth = UIScreen.main.bounds.width - AchievementsCell.pictureWidth - AchievementsCell.border * 5
            let progressBarsSumWidth = AchievementsCell.progressViewWidth * CGFloat(difficulties.count)
            let intervalBetweenProgressViews = (progressAreaWidth - progressBarsSumWidth) / (CGFloat(difficulties.count) - CGFloat(1))
                - AchievementsCell.progressViewHeight + AchievementsCell.progressViewWidth
            let progress = createProgressView(progress: Float(score[0].points / 100))
            self.addSubview(progress)
            progress.topAnchor.constraint(equalTo: title.bottomAnchor,
                                          constant: AchievementsCell.progressViewHeight / 2 + AchievementsCell.border).isActive = true
            progress.leftAnchor.constraint(equalTo: picture.rightAnchor,
                                           constant: AchievementsCell.border * 2 - AchievementsCell.progressViewHeight / 2).isActive = true

            var previousBar = progress
            if difficulties.count > 2 {
                for index in 1...difficulties.count - 2 {
                    let progress = createProgressView(progress: Float(score[index].points / 100))
                    self.addSubview(progress)
                    progress.topAnchor.constraint(equalTo: title.bottomAnchor,
                                                  constant: AchievementsCell.progressViewHeight / 2 + AchievementsCell.border).isActive = true
                    progress.leftAnchor.constraint(equalTo: previousBar.rightAnchor,
                                                   constant: intervalBetweenProgressViews).isActive = true

                    previousBar = progress
                }
            }

            if difficulties.count > 1 {
                let progress = createProgressView(progress: Float(score[difficulties.count - 1].points / 100))
                self.addSubview(progress)
                progress.topAnchor.constraint(equalTo: title.bottomAnchor,
                                              constant: AchievementsCell.progressViewHeight / 2 + AchievementsCell.border).isActive = true
                progress.leftAnchor.constraint(equalTo: previousBar.rightAnchor,
                                               constant: intervalBetweenProgressViews).isActive = true
            }
            for index in 0...difficulties.count - 1 {
                limits.append(Float(score[index].points / 100))
            }
        }
        submitProgress()
        guard let picture = level.picture else { return }
        self.picture.image = ResourcesManager.getImage(name: picture)
    }

    func createProgressView(progress: Float) -> UIProgressView {

        let progressView = UIProgressView()

        progressView.progressTintColor = ColorScheme.tintColor
        progressView.trackTintColor = .systemGray5
        progressView.layer.cornerRadius = 6.5
        progressView.clipsToBounds = true
        progressView.transform = CGAffineTransform(rotationAngle: .pi / -2)
        progressView.translatesAutoresizingMaskIntoConstraints = false

        progressView.widthAnchor.constraint(equalToConstant: AchievementsCell.progressViewHeight).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: AchievementsCell.progressViewWidth).isActive = true

        results.append(progress)
        progressBars.append(progressView)

        return progressView
    }

    func submitProgress() {

        Timer.scheduledTimer(timeInterval: TimeInterval(timeStep), target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
    }

    @objc func updateProgressBar(timer: Timer) {

        var counter = 0

        for index in 0...self.progressBars.count - 1 {
            if self.progressBars[index].progress < self.limits[index] {
                self.progressBars[index].progress += 0.005
            } else {
                counter += 1
            }
        }

        if counter >= self.progressBars.count {
            timer.invalidate()
        }
    }
}
