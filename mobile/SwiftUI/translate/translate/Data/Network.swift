//
//  Data.swift
//  Translate
//
//  Created by Ryan Cormier on 9/22/20.
//

import Foundation

struct API {
    static let url = URL(string:  "https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e&")
    static let headers = [
        "Content-Type": "application/x-www-form-urlencoded",
        "User-Agent": "AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1" ]
    static let method = "POST"
}

struct Response: Codable {
    var results: [Result]
}

func getURLRequest(data: [String: String]) -> URLRequest {
    var urlComponents = URLComponents(url: API.url)
    urlComponents.queryItems = [
        URLQueryItem(name: "sl", value: data["source"] ?? "auto"),
        URLQueryItem(name: "tl", value: data["target"]),
        URLQueryItem(name: "q", value: data["text"])
    ]
    
    var urlRequest = URLRequest(url: (urlComponents?.url)!)
    urlRequest.httpMethod = API.method
    for (key, val) in API.headers {
        urlRequest.setValue(val, forHTTPHeaderField: key)
    }
    
    return urlRequest
}
