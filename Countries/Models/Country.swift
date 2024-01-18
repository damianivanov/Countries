//
//  Country.swift
//  Countries
//
//  Created by Damian Ivanov on 7.01.24.
//

import Foundation

struct Country: Decodable {
    
    var name: Name
    var flags: Flags
    
    var timezones: [String]
    var continents: [String]
    var capital: [String]?
    var region: String
    var population: Int
    var area: Int
    var maps: Maps
    var latlng: [Double]
    
    enum CodingKeys: CodingKey {
        case name
        case flags
        case timezones
        case continents
        case capital
        case region
        case population
        case area
        case maps
        case latlng
    }
    var urlName: String {
        return name.common.replacingOccurrences(of: " ", with: "+")

    }
}

struct Maps: Codable {
    var googleMaps: String
}

struct Flags: Codable {
    var png: String
}

struct Name: Codable {
    var common: String
    var official: String
}

struct CountryShort: Codable,Hashable {

    
    static func == (lhs: CountryShort, rhs: CountryShort) -> Bool {
        return lhs.flags.png == rhs.flags.png
    }
 
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(flags.png)
    }
    
    var flags: Flags
    var name: Name
    
    var flagURL: URL {
        return URL(string: flags.png)!
    }
    
}

