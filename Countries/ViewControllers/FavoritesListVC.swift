//
//  FavoritesListVC.swift
//  Countries
//
//  Created by Damian Ivanov on 3.01.24.
//

import UIKit

class FavoritesListVC: UIViewController {

    var collectionView: UICollectionView!
    var favorites: [CountryShort] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(updatedFavorites),
                                             name: Notification.Name("reloadData"), object: nil)
        loadFavorites()
        Utils.shared.removeBadgeFavorite(tabBarController?.tabBar)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if favorites.isEmpty {
            view.subviews.forEach { subView in
                if type(of: subView) == CFEmptyView.self {
                    subView.removeFromSuperview()
                }
            }
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadData"), object: nil)
    }

    private func configure() {
        let flowLayout = Utils.shared.setFlowLayout(viewWidth: view.bounds.width,
                                                    padding: Constants.padding, itemSpacing: Constants.padding)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout )
        view.addSubview(collectionView)
        view.tamicFalse()

        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoritesViewCell.self, forCellWithReuseIdentifier: FavoritesViewCell.cellIdentifier)
    }

    @objc private func updatedFavorites(notification: NSNotification) {
            self.dismiss(animated: true)
        loadFavorites()
    }

    private func loadFavorites() {
        FavoritesManager.getFavorites { result in
            switch result {
            case .success(let favorites):
                self.updateUI(favorites: favorites)
            case . failure(let error):
                self.presentCFAlertOnMainThread(title: Messages.somethingWentWrong,
                                                bodyMessage: error.localizedDescription, buttonText: Messages.okMessage)

            }
        }
    }

    private func updateUI(favorites: [CountryShort]) {
        self.favorites = favorites
        if self.favorites.count == 0 {
            DispatchQueue.main.async {
                self.emptyStateView(message: Messages.emptyFavorites, in: self.view)
            }
        }
        DispatchQueue.main.async { self.collectionView.reloadData()}
    }
}

extension FavoritesListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesViewCell.cellIdentifier, for: indexPath)
     as? FavoritesViewCell
        cell?.set(country: favorites[indexPath.row])
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let country = favorites[indexPath.row]
        if self.presentedViewController != nil {
            dismiss(animated: false)
        }
        let nav = Utils.shared.getSheetDetailsVC(countryName: country.name.common)
        present(nav, animated: true, completion: nil)
    }
}
