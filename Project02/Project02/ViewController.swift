//
//  ViewController.swift
//  Project02
//
//  Created by Alley Pereira on 17/03/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var Button01: UIButton!
    @IBOutlet var Button02: UIButton!
    @IBOutlet var Button03: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!

    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france","germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia","spain", "us", "uk"]
        
        Button01.layer.borderWidth = 1
        Button02.layer.borderWidth = 1
        Button03.layer.borderWidth = 1
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        Button01.setImage(UIImage(named: countries[0]), for: .normal)
        Button02.setImage(UIImage(named: countries[1]), for: .normal)
        Button03.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct 🏆"
            score += 1
            scoreLabel.text = "Total score: \(score) 🏆"
        } else {
            title = "Wrong 👎🏼"
//            score -= 1
        }
        
        let alert = UIAlertController(title: title, message: "You score is \(score).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: askQuestion
            )
        )
        present(alert, animated: true)
    }
}

