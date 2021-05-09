//
//  SearchRecordManager.swift
//  Weather
//
//  Created by Simon on 7/5/2021.
//

import Foundation

class SearchRecordManager {
    static let sharedInstance = SearchRecordManager()
    
    
    var records = [SearchRecord]()
    
    private init() {
        if let savedRecords = UserDefaults.standard.object(forKey: "searchRecords") as? Data {
            let decoder = JSONDecoder()
            if let loadedRecords = try? decoder.decode([SearchRecord].self, from: savedRecords) {
                records = loadedRecords
            }
        }
    }
    
    func getRecords() -> [SearchRecord] {
        return records
    }
    
    func addRecord(record:SearchRecord) {
        //Insert record in a reverse order
        self.records.insert(record, at: 0)
        saveRecords()
    }
    
    func removeRecord(index:Int) -> [SearchRecord] {
        self.records.remove(at: index)
        saveRecords()
        return records
    }
    
    private func saveRecords(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(records) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "searchRecords")
        }
    }
}
