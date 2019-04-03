//
//  TextData.swift
//  PrnkTest
//
//  Created by Anton Trofimenko on 31/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import Foundation

struct TextData: Decodable, NamedData {
    var name, text: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case data
    }
    
    enum DataCodingKeys: String, CodingKey {
        case text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        
        let dataContainer = try container.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)
        self.text = try dataContainer.decode(String.self, forKey: .text)
    }
    
    func getSelectedId() -> Int? {
        return nil
    }
    
    func getUrl() -> String? {
        return nil
    }
    
    func getText() -> String? {
        return text
    }
    
    func getVariants() -> [OptionData]? {
        return nil
    }
}
