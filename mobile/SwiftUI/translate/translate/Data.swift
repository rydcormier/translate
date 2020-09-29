//
//  Data.swift
//  translate
//
//  Created by Ryan Cormier on 9/28/20.
//
//
//  Data Structures for the translate app.
//

import Foundation
import SwiftUI

// Available languages
let languages: [Language] = load("languages.json")

// These are for decoding the json response.
struct Response: Codable { var sentences: [Sentence] }
struct Sentence: Codable {
    var trans: String?
    var translit: String?
}


// A languages for translation. The language code is stored in value and
// is the only data needed for the HTTP request. Id is for protocal only.
struct Language: Codable, Identifiable {
var id:     Int
var name:   String
var value:  String
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

// The API information
struct API {
    static let url = URL(string: "https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e")!
    static let headers = [
        "Content-Type": "application/x-www-form-urlencoded",
        "User-Agent": "AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1"
    ]
}
