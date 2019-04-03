//
//  OptionData.swift
//  PrnkTest
//
//  Created by Anton Trofimenko on 31/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import Foundation

struct OptionData: Decodable {
    let text: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id, text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
    }
}
