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

    var countries = [String]()
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        countries += ["estonia", "france","germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia","spain", "us", "uk"]

        Button01.layer.borderWidth = 1
        Button02.layer.borderWidth = 1
        Button03.layer.borderWidth = 1

        askQuestion()
    }

    func askQuestion() {
        Button01.setImage(UIImage(named: countries[0]), for: .normal)
        Button02.setImage(UIImage(named: countries[1]), for: .normal)
        Button03.setImage(UIImage(named: countries[2]), for: .normal)
    }
}

