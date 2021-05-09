//
//  SearchRecord.swift
//  Weather
//
//  Created by Simon on 5/5/2021.
//

import UIKit

enum SearchType: Int, Codable,CustomStringConvertible {
    case city
    case zipCode
    case GPS
    
    var description : String {
        switch self {
        // Use Internationalization, as appropriate.
        case .city: return "City"
        case .zipCode: return "Zip Code"
        case .GPS: return "GPS"
        }
      }
}

class SearchRecord: Codable {
    
    var type: SearchType!
    var input:String! = ""
    var latitude:String! = "" //latitude of coordindate
    var longitude:String! = "" //longitude of coordindate

    private enum CodingKeys: String, CodingKey {
        case type
        case input
        case latitude
        case longitude

   }
    
    init(type: SearchType){
        self.type = type
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        type = try? values?.decodeIfPresent(SearchType.self, forKey: .type)
        input = try? values?.decodeIfPresent(String.self, forKey: .input)
        latitude = try? values?.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try? values?.decodeIfPresent(String.self, forKey: .longitude)

    }

    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(input, forKey: .input)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    
    
    static func getRecentSearchs() -> [SearchRecord]? {
        if let objects = UserDefaults.standard.value(forKey: "RecentSearchs") as? Data {
           let decoder = JSONDecoder()
           if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [SearchRecord] {
              return objectsDecoded
           } else {
              return nil
           }
        } else {
           return nil
        }
    }
    
}
