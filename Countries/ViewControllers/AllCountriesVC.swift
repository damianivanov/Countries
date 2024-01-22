//
//  AllCountries.swift
//  Countries
//
//  Created by Damian Ivanov on 4.01.24.
//

import UIKit

class AllCountriesVC: UIViewController {

    let tableView = UITableView()
    var allCountries: [CountryShort] = []
    var filteredCountries: [CountryShort] = []
    var dataSource: UITableViewDiffableDataSource<Section, CountryShort>!
    let searchController = UISearchController()
    var recentlyFavorited = Set<String>()
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
        navigationController?.setNavigationBarHidden(false, animated: true)
        addObservers()
        recentlyFavorited = Set<String>()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("addBadge"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("removeBadge"), object: nil)
        recentlyFavorited = Set<String>()
    }
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
        self.showLoadingView()
        NetworkManager.shared.getAllCountries { [weak self] (countryResponse, error) in
            guard let self = self else {return}
            DispatchQueue.main.async {self.dismissLoadingView()}
            guard let countryResponse = countryResponse else {
                self.presentCFAlertOnMainThread(title: Messages.somethingWentWrong,
                                                bodyMessage: error?.rawValue ?? "", buttonText: Messages.okMessage)
                return

            }
            self.allCountries = countryResponse.sorted(by: { $0.name.common < $1.name.common })
            DispatchQueue.main.async {
                self.updateData(on: self.allCountries)
            }
        }
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(addBadge),
                                               name: Notification.Name("addBadge"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeBadge),
                                               name: Notification.Name("removeBadge"), object: nil)
    }

    @objc private func addBadge(notification: NSNotification) {
        guard let countryName = notification.userInfo?.first?.value as? String else {return}
        if !recentlyFavorited.contains(countryName) {
            recentlyFavorited.insert(countryName)
            Utils.shared.updateFavoriteBadge(tabBarController?.tabBar, .add)
        }
    }

    @objc private func removeBadge(notification: NSNotification) {
        guard let countryName = notification.userInfo?.first?.value as? String else {return}
        if recentlyFavorited.contains(countryName) {
            recentlyFavorited.remove(countryName)
            Utils.shared.updateFavoriteBadge(tabBarController?.tabBar, .remove)
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
            if self.recentlyFavorited.contains(country.name.common) {
                completionHandler(false)
                return
            }
            FavoritesManager.update(country: country, actionType: .add) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .some:
                    completionHandler(false)
                    return
                default:
                    self.recentlyFavorited.insert(country.name.common)
                    Utils.shared.updateFavoriteBadge(self.tabBarController?.tabBar, .add)
                    completionHandler(true)
                }
            }
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
