//
//  WeatherUtil.swift
//  Weather
//
//  Created by Simon on 6/5/2021.
//

import Foundation
import Alamofire

struct WeatherUtil {
    static let sharedInstance = WeatherUtil()
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "95d190a434083879a6398aafd54d9e73"

    private init() {}

    func searchByCity(cityName:String!, completion:@escaping (Any) -> Void)  {
        let parameter = ["q":cityName!]
        AF.request(baseUrl, parameters: buildParam(param: parameter)).responseJSON { response in
            switch response.result {
              case .success(let value):
               completion(value)

              case .failure(let error):
                  print(error)
              }
        }

    }
    
    func searchByZipCode(cityName:String!, completion:@escaping (Any) -> Void)  {
        let parameter = ["zip":cityName!]
        AF.request(baseUrl, parameters: buildParam(param: parameter)).responseJSON { response in
            switch response.result {
              case .success(let value):
               completion(value)

              case .failure(let error):
                  print(error)
              }
        }
    }
    
    func getCurrentWeather(criteria:SearchRecord, completion:@escaping (Any) -> Void)  {
        var parameter:[String:String]
        switch criteria.type {
            case .city:
                parameter = ["q":criteria.input!]
            case .zipCode:
                parameter = ["zip":criteria.input!]
            case .GPS:
                parameter = ["lat":criteria.latitude!,
                             "lon":criteria.longitude]
            default:
                parameter = [String: String]()
        }
        
        AF.request(baseUrl, parameters: buildParam(param: parameter)).responseJSON { response in
            switch response.result {
              case .success(let value):
               completion(value)

              case .failure(let error):
                  print(error)
              }
        }
    }
    
    private func buildParam (param: [String:String]) -> [String:String]{
        let baseParam = ["appid": apiKey,"units":"metric"]
        
        return baseParam.merging(param) { _, new in
            new
        }
    }
}
