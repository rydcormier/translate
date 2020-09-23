/*
 *  Translator.swift
 *  Translate
 *
 *  Created by Ryan Cormier on 9/22/20
 */

import Foundation

class Translator {
    static var text: String = ""
    static var data = Data()
    
    static func translate(_ _data: [String : String]) -> String {
        requestData(data: _data)
        do {
            print(String(describing: Self.data))
            let response = try JSONDecoder().decode(Response.self, from: Self.data)
            Self.text = response.sentences.map({ s in s.trans }).joined()
        } catch  {}
        
        return Self.text
    }
    
    static func requestData(data: [String : String]) {
        
        // Build the URLRequest using URLComponents
        let url = URL(string: "https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        components?.queryItems! += [
                    URLQueryItem(name: "sl", value: data["sl"]),
                    URLQueryItem(name: "tl", value: data["tl"]),
                    URLQueryItem(name: "q", value: data["q"]) ]
        
        
        var request = URLRequest(url: (components?.url)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1", forHTTPHeaderField: "User-Agent")
        
        // Start the data task
        
        URLSession.shared.dataTask(with: request) { _data, res, err in
            if let _data = _data {
                print(String(describing: _data))
                Self.data = _data
            }
        }
        .resume()
    }
    
    
    struct Response: Codable { var sentences: [Sentence] }
    struct Sentence: Codable { var trans: String }
}

//class Translator {
//    var data: Data?
//
//    func translate(data: [String : String ]) -> String {
//        self.getData(data: data)
//
//        if let _data = self.data, let response = try? JSONDecoder().decode(Response.self, from: _data) {
//            return response.sentences.map({ s in s.trans }).joined()
//        }
//
//        return ""
//    }
//
//    func getData(data: [String: String]) {
//        let url = URL(string: "https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e")!
//
//        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
//
//        components?.queryItems! += [
//            URLQueryItem(name: "sl", value: data["source"] ?? "auto"),
//            URLQueryItem(name: "tl", value: data["target"]),
//            URLQueryItem(name: "q", value: data["text"]) ]
//
//
//        var request = URLRequest(url: (components?.url)!)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.setValue("AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1", forHTTPHeaderField: "User-Agent")
//
//        URLSession.shared.dataTask(with: request)  { dataObject, response, err in
//
//            if let dataObject = dataObject {
//                self.data = dataObject
//            }
//        }
//        .resume()
//    }
//
//    struct Response: Codable { var sentences: [Sentence] }
//    struct Sentence: Codable { var trans: String }
//}
