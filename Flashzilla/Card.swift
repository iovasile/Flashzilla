//
//  Card.swift
//  Flashzilla
//
//  Created by Ionut Vasile on 19.02.2022.
//

import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played the 13th doctor in Doctor Who?", answer: "Jodie Wittaker")
}
