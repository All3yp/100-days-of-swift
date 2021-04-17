//
//  ViewController.swift
//  Project07
//
//  Created by Alley Pereira on 15/04/21.
//

import UIKit

class ViewController: UITableViewController {

    let search = UISearchController(searchResultsController: nil)

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var filterKeyword: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search whitehouse petitions here"
        navigationItem.searchController = search

        let urlString: String  //"https://www.hackingwithswift.com/samples/petitions-1.json"

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        title = "White House Petitions"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showfilter))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }

    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "Petitions from at petitions.whitehouse.gov", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @objc func showfilter() {
        let ac = UIAlertController(title: "Filter", message: "Filter the petitions", preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {
            [weak self, weak ac] _ in
            self?.filterKeyword = ac?.textFields?[0].text ?? ""
            self?.filterData()
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
    }

    func filterData() {
        if filterKeyword.isEmpty {
            filteredPetitions = petitions
            navigationItem.leftBarButtonItem?.title = "Filter"
            return
        }

        navigationItem.leftBarButtonItem?.title = "Filter to \(filterKeyword)"

        // case sensitive in filters, see here (https://www.hackingwithswift.com/example-code/strings/how-to-run-a-case-insensitive-search-for-one-string-inside-another)
        filteredPetitions = petitions.filter() { petition in
            if let _ = petition.title.range(of: filterKeyword, options: .caseInsensitive) {
                return true
            }
            if let _ = petition.body.range(of: filterKeyword, options: .caseInsensitive) {
                return true
            }
            return false
        }
    }

    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func filter(for searchText: String) {
        filteredPetitions = petitions.filter { petition in
            return petition.title.lowercased().contains(searchText.lowercased())
        }
        if filteredPetitions.isEmpty {
            filteredPetitions = petitions
        }
        tableView.reloadData()
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filterData()
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title //"Title goes here"
        cell.detailTextLabel?.text = petition.body //"Subtitle goes here"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        filter(for: searchController.searchBar.text ?? "")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        tableView.reloadData()
    }
}
