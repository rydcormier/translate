//
//  LanguageData.swift
//  translate
//
//  Created by Ryan Cormier on 9/25/20.
//

import Foundation
import SwiftUI

let languages: [Language] = load("languages.json")

struct Language: Codable, Identifiable {
    var id:     Int
    var name:   String
    var value:  String
}

struct Sentence : Codable { var trans: String }
struct Response: Codable { var sentences: [Sentence] }


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
