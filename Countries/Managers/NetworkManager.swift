//
//  NetworkManager.swift
//  Countries
//
//  Created by Damian Ivanov on 5.01.24.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let cache = NSCache<NSString, NSData>();
    let imageCache = NSCache<NSString, UIImage>();
    
    private init(){
        cache.countLimit = 300
        imageCache.countLimit = 40
    }
    var endpoint = "https://restcountries.com/v3.1/"
    
    func getCountry(country: String, completed: @escaping ([Country]?, CFError?) -> Void) {
        let endpointCountryInfo = "\(endpoint)name/\(country)"
        guard let url = URL(string: endpointCountryInfo) else {
            completed(nil,.invalidURL)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard self != nil else {return}
            if let _ = error {
                completed(nil,.unableToComplete)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil,.invalidResponse)
                return
            }
            guard let data = data else {
                completed(nil,.invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let country = try decoder.decode([Country].self, from: data)
                completed(country,nil)
            } catch {
                print(error)
                completed(nil, .invalidData)
            }
            
            
        }
        task.resume()
    }
    
    
    func getAllCountries(completed: @escaping ([CountryShort]?,CFError?) -> Void) {
        let endpointAllCountries = "\(endpoint)all?fields=flags,name"
        guard let url = URL(string: endpointAllCountries) else {
            completed(nil,.invalidURL)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard self != nil else {return}
            if let _ = error {
                completed(nil,.unableToComplete)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil,.invalidResponse)
                return
            }
            guard let data = data else {
                completed(nil,.invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let allCountries = try decoder.decode([CountryShort].self, from: data)
                completed(allCountries,nil)
            } catch {
                completed(nil, .invalidData)
            }
            
            
        }
        task.resume()
    }
    
    
    func downlodImage(imageURL: String, completed: @escaping (UIImage?, CFError?) -> Void) {
        
        if let imageData = imageCache.object(forKey: imageURL as NSString){
            completed(imageData,nil)
            return
        }
        guard let url = URL(string:imageURL) else {
            completed(nil,.invalidURL)
            return
        }
        
        let task = URLSession.shared.downloadTask(with: url) {[weak self] localUrl, response, error in
            guard let self = self else {return}
            if error != nil {
                completed(nil,.invalidData)
                return
            }
            
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else {
                completed(nil,.invalidResponse)
                return
            }
            
            guard let localUrl = localUrl else {
                completed(nil,.invalidData)
                return
            }
            do{
                let data = try Data(contentsOf: localUrl)
                let image = UIImage(data: data)
                imageCache.setObject(image!, forKey: imageURL as NSString)
                completed(image, nil)
            }catch {
                print(error.localizedDescription)
                completed(nil,.invalidData)
                return
            }
        }
        task.resume()
    }
    
    
    func getRegularUnsplashImages(urls: [UnsplashURLs], completed: @escaping ([UIImageView]?,CFError?) ->Void){
        
        var imageViews: [UIImageView] = []
        for i in 0..<urls.count{
            let imageView = UIImageView()
            guard let url = URL(string: urls[i].regular) else {continue}
            imageView.load(url: url)
            imageViews.append(imageView)
        }
        if imageViews.isEmpty {
            completed(nil,.invalidData)
        } else{
            completed(imageViews,nil)
        }
    }
    
    
    func searchImagesQuery(query: String,page: Int, completed: @escaping ([UnsplashURLs]?, CFError?) -> Void) {
        let clientKey = Bundle.main.object(forInfoDictionaryKey: "UnsplashKey") as! String
        let stringUrl = "https://api.unsplash.com/search/photos?query=\(query)&client_id=\(clientKey)&page=\(page)&order_by=popular&orientation=portrait"
        
        guard let url = URL(string: stringUrl) else {
            completed(nil,.invalidURL)
            return
        }
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard self != nil else {return}
            if let _ = error {
                completed(nil,.unableToComplete)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil,.invalidURL)
                return
            }
            
            guard let data = data else {
                completed(nil,.invalidData)
                return
            }
            let decoder = JSONDecoder()
            do {
                let unsplashResponse = try decoder.decode(UnsplashResponse.self, from: data)
                completed(unsplashResponse.results.map{$0.urls},nil)
            } catch{
                print(error.localizedDescription)
                completed(nil,.invalidData)
            }
            
        }
        task.resume()
    }
    
    func getCachedImage(imageURL: String) -> UIImage? {
        if let imageData = imageCache.object(forKey: imageURL as NSString){
            return imageData
        }
        return nil
    }
    
    func setCachedImage(imageURL: String, image: UIImage) {
        imageCache.setObject(image, forKey: imageURL as NSString)
    }
}
