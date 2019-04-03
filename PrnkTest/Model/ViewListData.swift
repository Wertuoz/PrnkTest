//
//  ViewListResponse.swift
//  PrnkTest
//
//  Created by Anton Trofimenko on 01/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import Foundation

struct ViewListData: Decodable {
    let data: [NamedData]
    let viewSequence: [String]
    
    enum CodingKeys: String, CodingKey {
        case data
        case view
    }
    
    enum DataNameKeys: CodingKey {
        case name
    }
    
    enum DataViewTypes: String, Decodable {
        case hz = "hz"
        case picture = "picture"
        case selector = "selector"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var dataArrayForType = try container.nestedUnkeyedContainer(forKey: CodingKeys.data)
        var dataArray = [NamedData]()
        
        var dataTempArray = dataArrayForType
        
        while(!dataTempArray.isAtEnd)
        {
            let data = try dataArrayForType.nestedContainer(keyedBy: DataNameKeys.self)
            let name = try data.decode(DataViewTypes.self, forKey: DataNameKeys.name)
            switch name {
            case .hz:
                print("found hz")
                dataArray.append(try dataTempArray.decode(TextData.self))
            case .picture:
                print("found picture")
                dataArray.append(try dataTempArray.decode(PictureData.self))
            case .selector:
                print("found selector")
                dataArray.append(try dataTempArray.decode(SelectorData.self))
            }
        }
        self.data = dataArray
        
        viewSequence = try container.decode([String].self, forKey: CodingKeys.view)
        print(viewSequence)
    }
    
    public func getDataByName(name: String) -> NamedData? {
        for item in data {
            if item.name == name {
                return item
            }
        }
        return nil
    }
}

