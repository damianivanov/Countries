//
//  NetworkManager.swift
//  Countries
//
//  Created by Damian Ivanov on 5.01.24.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let flagsCache = NSCache<NSString, NSData>()
    let imageCache = NSCache<NSString, NSData>()

    private init() {
        flagsCache.countLimit = 300
        imageCache.countLimit = 20
    }

    func getCountry(country: String, completed: @escaping ([Country]?, CFError?) -> Void) {
        let endpoint = "https://restcountries.com/v3.1/name/\(country)"
        guard let urlString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else {
            completed(nil, .invalidURL)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard self != nil else {return}
            if error != nil {
                completed(nil, .unableToComplete)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, .invalidResponse)
                return
            }
            guard let data = data else {
                completed(nil, .invalidData)
                return
            }

            do {
                let decoder = JSONDecoder()
                let country = try decoder.decode([Country].self, from: data)
                completed(country, nil)
            } catch {
                print(error)
                completed(nil, .invalidData)
            }

        }
        task.resume()
    }

    func getAllCountries(completed: @escaping ([CountryShort]?, CFError?) -> Void) {
        let endpoint = "https://restcountries.com/v3.1/"
        let endpointAllCountries = "\(endpoint)all?fields=flags,name"
        guard let url = URL(string: endpointAllCountries) else {
            completed(nil, .invalidURL)
            return
        }
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard self != nil else {return}
            if error != nil {
                completed(nil, .unableToComplete)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, .invalidResponse)
                return
            }
            guard let data = data else {
                completed(nil, .invalidData)
                return
            }

            do {
                    let decoder = JSONDecoder()
                let allCountries = try decoder.decode([CountryShort].self, from: data)
                completed(allCountries, nil)
            } catch {
                completed(nil, .invalidData)
            }

        }
        task.resume()
    }

    func downlodImage(imageURL: String, completed: @escaping (NSData?, CFError?) -> Void) {
        if let imageData = imageCache.object(forKey: imageURL as NSString) {
            completed(imageData, nil)
            return
        }
        if let imageData = flagsCache.object(forKey: imageURL as NSString) {
            completed(imageData, nil)
            return
        }
        guard let url = URL(string: imageURL) else {
            completed(nil, .invalidURL)
            return
        }

        let task = URLSession.shared.downloadTask(with: url) {[weak self] localUrl, response, error in
            guard let self = self else {return}
            if error != nil {
                completed(nil, .invalidData)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, .invalidResponse)
                return
            }

            guard let localUrl = localUrl else {
                completed(nil, .invalidData)
                return
            }
            do {
                let data = try NSData(contentsOf: localUrl)
                imageCache.setObject(data!, forKey: imageURL as NSString)
                completed(data, nil)
            } catch {
                print(error.localizedDescription)
                completed(nil, .invalidData)
                return
            }
        }
        task.resume()
    }

    func searchImagesQuery(query: String, page: Int, completed: @escaping ([UnsplashURLs]?, CFError?) -> Void) {
        guard let clientKey = Bundle.main.object(forInfoDictionaryKey: "UnsplashKey") as? String else {
            completed(nil, .invalidClientKey)
            return
        }
        let endpoint = "https://api.unsplash.com/search/photos"
        let orderBy = "order_by=popular&orientation=portrait"
        guard let stringUrl = "\(endpoint)?query=\(query)&client_id=\(clientKey)&page=\(page)&\(orderBy)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: stringUrl) else {
            completed(nil, .invalidURL)
            return
        }
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard self != nil else {return}
            if error != nil {
                completed(nil, .unableToComplete)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, .invalidURL)
                return
            }

            guard let data = data else {
                completed(nil, .invalidData)
                return
            }
            let decoder = JSONDecoder()
            do {
                let unsplashResponse = try decoder.decode(UnsplashResponse.self, from: data)
                completed(unsplashResponse.results.map {$0.urls}, nil)
            } catch {
                print(error.localizedDescription)
                completed(nil, .invalidData)
            }

        }
        task.resume()
    }

    func getCountryDescription(country: String, completed: @escaping (Result<QueryResponse, CFError>) -> Void) {
        let endpoint = "https://en.wikipedia.org/w/api.php?"
        let format = "format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&"
        guard let stringURL = "\(endpoint)\(format)titles=\(country)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: stringURL) else {
            completed(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            if error != nil {
                completed(.failure(.unableToComplete))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidURL))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let queryResponse = try decoder.decode(QueryResponse.self, from: data)
                completed(.success(queryResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()

    }

}
