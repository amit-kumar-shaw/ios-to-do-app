//
//  JSONUtils.swift
//  ios to do app
//
//  Created by Cristi Conecini on 15.01.23.
//

import Foundation

struct JSONUtils{
    
    static func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error reading JSON file: \(error)")
        }
        return nil
    }
    
}





