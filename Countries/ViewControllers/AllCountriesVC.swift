//
//  AllCountries.swift
//  Countries
//
//  Created by Damian Ivanov on 4.01.24.
//

import UIKit

@MainActor
class AllCountriesVC: UIViewController {

    let tableView = UITableView()
    var allCountries: [CountryShort] = []
    var filteredCountries: [CountryShort] = []
    var dataSource: UITableViewDiffableDataSource<Section, CountryShort>!
    let searchController = UISearchController()
    var isFiltered: Bool {
        return !searchController.searchBar.text!.isEmpty
    }

    enum Section {case main}

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = false

        configureSearchController()
        configureTableView()
        fetchData()
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.cellIdentifier)
        tableView.rowHeight = 50

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])

    }

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a country"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.spellCheckingType = .no
        navigationItem.searchController = searchController

    }

    private func fetchData() {
        showLoadingView()
        Task {
            do {
                let countryResponse = try await NetworkManager.shared.getAllCountries()
                allCountries = countryResponse.sorted(by: { $0.name.common < $1.name.common })
                updateData(on: allCountries)
                dismissLoadingView()

            } catch {
                presentCFAlertOnMainThread(title: Messages.somethingWentWrong,
                                           bodyMessage: error.localizedDescription, buttonText: Messages.okMessage)
            }
        }

    }
}

extension AllCountriesVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  isFiltered ? filteredCountries.count : allCountries.count
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let activeArray = isFiltered ? filteredCountries : allCountries
        let country = activeArray[indexPath.row]
        let favorite = UIContextualAction(style: .normal, title: "Add To Favorites") {  (_, _, completionHandler) in
            if FavoritesManager.recentFavorites.contains(country.name.common) {
                completionHandler(false)
                return
            }
            let result = FavoritesManager.shared.update(country: country, action: .add)
            if result {
                Utils.shared.updateFavoriteBadge(self.tabBarController?.tabBar, .add)
                if !FavoritesManager.recentFavorites.contains(country.name.common) {
                    FavoritesManager.recentFavorites.insert(country.name.common)
                }
                completionHandler(true)
            }
            completionHandler(false)
        }

        favorite.image = UIImage(systemName: "star.fill")
        favorite.backgroundColor = .systemYellow

        let swipeActions = UISwipeActionsConfiguration(actions: [favorite])
        return swipeActions
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let presented = presentedViewController {
            presented.dismiss(animated: true)
        }
        let activeArray = isFiltered ? filteredCountries : allCountries
        let country = activeArray[indexPath.row]
        let nav = Utils.shared.getSheetDetailsVC(countryName: country.name.common)
        present(nav, animated: true, completion: nil)
    }

    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView,
                                                   cellProvider: {(tableView, indexPath, country) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.cellIdentifier,
                                                     for: indexPath) as? CountryCell
            cell?.set(country: country)
            return cell
        })
    }

    private func updateData(on countries: [CountryShort]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CountryShort>()
        snapshot.appendSections([.main])
        snapshot.appendItems(countries)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension AllCountriesVC: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {return}
        filteredCountries = allCountries.filter {$0.name.common.lowercased().contains(filter.lowercased())}
        updateData(on: filteredCountries)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: allCountries)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            updateData(on: allCountries)
        }
    }
}
