//
//  FavoritesManager.swift
//  Countries
//
//  Created by Damian Ivanov on 14.01.24.
//

import UIKit

class FavoritesManager {

    let defaults = UserDefaults.standard
    static let shared = FavoritesManager()
    static var recentFavorites = Set<String>()
    enum ActionType {
        case add
        case remove
    }

    enum Keys {
        static let favorites = "favorites"
    }

    private func clearRecent() { FavoritesManager.recentFavorites.removeAll()}

    func removeBadgeFavorite(_ tabBar: UITabBar) {
        Utils.shared.removeBadgeFavorite(tabBar)
        clearRecent()
    }

    func updateRecent(country: String, action: ActionType) {
        switch action {
        case .add:
            FavoritesManager.recentFavorites.insert(country)
        case .remove:
            FavoritesManager.recentFavorites.remove(country)
        }
    }

    func getFavorites() throws -> [CountryShort] {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return []
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([CountryShort].self, from: favoritesData)
            return favorites
        } catch {
            throw CFError.unableToFavorite
        }

    }

    func update(country: CountryShort, action: ActionType) -> Bool {
        do {
            var favorites = try getFavorites()
            switch action {
            case .add:
                guard !favorites.contains(country) else {return false}
                favorites.append(country)
            case .remove:
                guard favorites.contains(country) else {return false}
                favorites.removeAll { $0.name.common == country.name.common }
            }
            let result = setFavorites(favorites: favorites)
//            updateRecent(country: country.name.common, action: action)
            return result == nil ? true : false
        } catch {
            return false
        }
    }

    func setFavorites(favorites: [CountryShort]) -> CFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }

     func isAlredyFavorited(country: CountryShort) -> Bool {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return false
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([CountryShort].self, from: favoritesData)
            return favorites.contains { $0 == country}
        } catch {
            return false
        }
    }

    /*    static func update(country: CountryShort, actionType: ActionType, completed: @escaping (CFError?) -> Void) {
    //        getFavorites { result in
    //            switch result {
    //            case .success(let favorites):
    //                var retrievedFavorites = favorites
    //
    //                switch actionType {
    //                case .add:
    //                    guard !retrievedFavorites.contains(country) else {
    //                        completed(.alreadyFavorited)
    //                        return
    //                    }
    //                    retrievedFavorites.append(country)
    //                case .remove:
    //                    retrievedFavorites.removeAll { $0.name.common == country.name.common }
    //                }
    //                completed(setFavorites(favorites: retrievedFavorites))
    //            case .failure(let error):
    //                completed(error)
    //            }
    //        }
    //    }

    //    static func getFavorites(completed: @escaping (Result<[CountryShort], CFError>) -> Void) {
    //        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
    //            completed(.success([]))
    //            return
    //        }
    //        do {
    //            let decoder = JSONDecoder()
    //            let favorites = try decoder.decode([CountryShort].self, from: favoritesData)
    //            completed(.success(favorites))
    //        } catch {
    //            completed(.failure(.unableToFavorite))
    //        }
        }
     */

}
