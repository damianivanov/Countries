//
//  FavoritesManager.swift
//  Countries
//
//  Created by Damian Ivanov on 14.01.24.
//

import Foundation

struct FavoritesManager {

    static private let defaults = UserDefaults.standard
    enum ActionType {
        case add
        case remove
    }

    enum Keys {
        static let favorites = "favorites"
    }

    static func update(country: CountryShort, actionType: ActionType, completed: @escaping (CFError?) -> Void) {
        getFavorites { result in
            switch result {
            case .success(let favorites):
                var retrievedFavorites = favorites

                switch actionType {
                case .add:
                    guard !retrievedFavorites.contains(country) else {
                        completed(.alreadyFavorited)
                        return
                    }
                    retrievedFavorites.append(country)
                case .remove:
                    retrievedFavorites.removeAll { $0.name.common == country.name.common }
                }
                completed(setFavorites(favorites: retrievedFavorites))
            case .failure(let error):
                completed(error)
            }
        }
    }

    static func getFavorites(completed: @escaping (Result<[CountryShort], CFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([CountryShort].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }

    static func setFavorites(favorites: [CountryShort]) -> CFError? {
        do {
         let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }

    static func isAlredyFavorited(country: CountryShort) -> Bool {
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
}
