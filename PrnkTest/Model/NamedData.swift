//
//  NamedData.swift
//  PrnkTest
//
//  Created by Anton Trofimenko on 01/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import Foundation

/// Protocol to communicate with viewcontroller
protocol NamedData {
    var name: String { get }
    
    func getUrl() -> String?
    func getText() -> String?
    func getVariants() -> [OptionData]?
    func getSelectedId() -> Int?
}
