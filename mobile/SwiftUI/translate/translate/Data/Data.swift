//
//  Data.swift
//  Translate
//
//  Created by Ryan Cormier on 9/22/20.
//

import Foundation
import UIKit
import SwiftUI

let languages: [Language] = load("languages.json")

struct Language: Hashable, Codable, Identifiable {
    var name:   String
    var value:  String
    var id:     Int
    
    static let autoDetect = Language(name: "auto detect", value: "auto", id: 0)
    static let testLang = Language(name: "french", value: "fr", id: 27)
    
    init(name: String, value: String, id: Int) {
        self.name   = name
        self.value  = value
        self.id     = id
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

