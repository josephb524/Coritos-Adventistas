//
//  DataAPI.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 9/10/21.
//  Copyright © 2021 Jose Pimentel. All rights reserved.
//

import Foundation

struct DataAPI: Codable {
    
    //let data: [String]
    let data: [Data1]
}

struct Data1: Codable {

    let duration: Int
    let title: String
    let id: String
    
}
