//
//  View.swift
//  Project08
//
//  Created by Alley Pereira on 21/04/21.
//

import UIKit

class View: UIView {

    var letterButtons = [UIButton]()
    var activateButtons = [UIButton]()

    lazy var cluesLabel: UILabel = {
        let cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        cluesLabel.text = "CLUES"
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        return cluesLabel
    }()

    lazy var answersLabel: UILabel = {
        let answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        return answersLabel
    }()

    lazy var scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        return scoreLabel
    }()

    lazy var currentAnswer: UITextField = {
        let currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        return currentAnswer
    }()

    let submit: UIButton = {
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        return submit
    }()

    let clear: UIButton = {
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        return clear
    }()

    let buttonsView: UIView = {
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 0.5
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        return buttonsView
    }()

    init() {
        super.init(frame: .zero)

        self.backgroundColor = .white
        subviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func subviews() {
        self.addSubview(scoreLabel)
        self.addSubview(cluesLabel)
        self.addSubview(answersLabel)
        self.addSubview(submit)
        self.addSubview(currentAnswer)
        self.addSubview(clear)
        self.addSubview(buttonsView)
        createWordGrid()
    }

    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activateButtons.append(sender)
        sender.isHidden = true
    }

    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""

        for btn in activateButtons {
            btn.isHidden = false
        }
        activateButtons.removeAll()
    }

    func createWordGrid() {
        let width = 150
        let height = 80

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }


    func setupConstraints() {
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),

            // pin the top of the clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 100),

            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: self.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

            // also pin the top of the answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

            // make the answers label stick to the trailing edge of our layout margins, minus 100
            answersLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -100),

            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: self.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),

            // make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),

            currentAnswer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),

            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),

            clear.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),

            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            // set its top anchor to be the bottom of the submit button, plus 20 points to add a little spacing
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
    }
}
