//
//  ViewController.swift
//  Project08
//
//  Created by Alley Pereira on 19/04/21.
//

import UIKit

class ViewController: UIViewController {

    lazy var wordView: View = View()

    var solutions = [String]()

    var level = 1
    var maxLevel = 2

    var score = 0 {
        didSet {
            wordView.scoreLabel.text = "Score: \(score)"
        }
    }

    override func loadView() {
        super.loadView()
        self.view = wordView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadLevel()

        wordView.submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = wordView.currentAnswer.text else { return }

        if let solutionPosition = solutions.firstIndex(of: answerText) {
            wordView.activateButtons.removeAll()

            var splitAnswers = wordView.answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            wordView.answersLabel.text = splitAnswers?.joined(separator: "\n")
            wordView.currentAnswer.text = ""
            score += 1

            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            _ = isAllButtonsPressed()
        }
    }

    func isAllButtonsPressed() -> Bool {
        let ac = UIAlertController(title: "Try Again", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        for button in wordView.letterButtons {
            if button.isHidden == false {
                return false
            }
        }
        return true
    }

    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        loadLevel()

        for btn in wordView.letterButtons {
            btn.isHidden = false
        }
    }

    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()

                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]

                    clueString += "\(index + 1). \(clue)\n"

                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)

                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }

        wordView.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        wordView.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

        letterBits.shuffle()

        if letterBits.count == wordView.letterButtons.count {
            for i in 0 ..< wordView.letterButtons.count {
                wordView.letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
}
