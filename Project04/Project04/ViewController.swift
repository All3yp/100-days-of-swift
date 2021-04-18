//
//  ViewController.swift
//  Project04
//
//  Created by Alley Pereira on 17/04/21.
//

import UIKit

class ViewController: UITableViewController {

    var websites: [String] = ["hackingwithswift.com", "swift.org/documentation/", "github.com/AcademyIFCE/Swift-Book", "apple.com"]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles =  true
        title = "Websites"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.websites = websites
        vc.currentSite = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}
