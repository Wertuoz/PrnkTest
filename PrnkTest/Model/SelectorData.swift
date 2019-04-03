//
//  SelectorData.swift
//  PrnkTest
//
//  Created by Anton Trofimenko on 31/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import Foundation

struct SelectorData: Decodable, NamedData {
    var name: String
    var selectedId: Int
    var variants: [OptionData]
    
    enum CodingKeys: String, CodingKey {
        case name
        case data
    }
    
    enum DataCodingKeys: String, CodingKey {
        case selectedId
        case variants
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        
        let dataContainer = try container.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)
        
        self.selectedId = try dataContainer.decode(Int.self, forKey: .selectedId)
        self.variants = try dataContainer.decode([OptionData].self, forKey: .variants)
    }
    
    func getSelectedId() -> Int? {
        return selectedId
    }
    
    func getUrl() -> String? {
        return nil
    }
    
    func getText() -> String? {
        return nil
    }
    
    func getVariants() -> [OptionData]? {
        return variants
    }
}

