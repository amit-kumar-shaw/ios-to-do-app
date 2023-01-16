//
//  Language.swift
//  ios to do app
//
//  Created by Cristi Conecini on 15.01.23.
//

import Foundation

class Language: Decodable{
    
    
    var id: String
        var name: String
    var nativeName: String
    
    init(id: String, name: String, nativeName: String) {
        self.id = id
        self.name = name
        self.nativeName = nativeName
    }
    
    
    
}

extension Language {
    static func getAllLanguages() -> [Language]{
        let jsonData = JSONUtils.readLocalJSONFile(forName: "languages") ?? Data()
        do{
            let decodedData = try JSONDecoder().decode([Language].self, from: jsonData)
            return decodedData
        }catch{
            print("error decoding json \(error)");
            return []
        }
        
    }
}

extension Language: Hashable, Equatable, Identifiable {
    static func == (lhs: Language, rhs: Language) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
}
