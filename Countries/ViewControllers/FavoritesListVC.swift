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
        NotificationCenter.default.addObserver(self, selector: #selector(updatedFavorites), name: Notification.Name("reloadData"), object: nil)
        loadFavorites()
        Utils.shared.removeBadgeFavorite(tabBarController?.tabBar)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadData"), object: nil)
    }
    
    private func configure(){
        collectionView = UICollectionView(frame: view.bounds ,collectionViewLayout: Utils.shared.setFlowLayout(viewWidth: view.bounds.width , padding: Constants.padding, itemSpacing: Constants.padding))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoritesViewCell.self, forCellWithReuseIdentifier: FavoritesViewCell.cellIdentifier)
    }
    
    @objc private func updatedFavorites(notification: NSNotification){
        self.dismiss(animated: true)
        loadFavorites()
    }
    
    private func loadFavorites(){
        FavoritesManager.getFavorites { result in
            switch result {
            case .success(let favorites):
                self.updateUI(favorites: favorites)
            case . failure(let error):
                self.presentCFAlertOnMainThread(title: "Something Went Wrong.", bodyMessage: error.localizedDescription, buttonText: "Ok")
                
            }
        }
    }
    
    func updateUI(favorites: [CountryShort])
    {
        
        if favorites.isEmpty{
            emptyStateView(message: "You don't have any favorites. Go add some 🙂.", in: self.view)
        }else{
            self.favorites = favorites
            DispatchQueue.main.async{self.collectionView.reloadData()}
        }
    }
    
}

extension FavoritesListVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesViewCell.cellIdentifier, for: indexPath) as! FavoritesViewCell
        cell.set(country: favorites[indexPath.row])
        return cell
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
