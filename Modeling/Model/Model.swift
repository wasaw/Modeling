//
//  Model.swift
//  Modeling
//
//  Created by Александр Меренков on 26.03.2024.
//

import Foundation

class Person: Hashable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    let id: Int
    let column: Int
    let row: Int
    var isInfected = false
    
    init(id: Int, column: Int, row: Int, isInfected: Bool = false) {
        self.id = id
        self.column = column
        self.row = row
        self.isInfected = isInfected
    }
}
