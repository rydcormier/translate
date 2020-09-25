//
//  TranslatorView.swift
//  Translate
//
//  Created by Ryan Cormier on 9/24/20.
//

import SwiftUI

struct TranslatorView: View {
    @State var source: String
    @State var target: String
    @State var input: String
    @State var output: String
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                Form {
                    Picker("source language", selection: $source) {
                        Text("auto detect").tag("auto")
                        ForEach(languages, id: \.self) { language in
                            Text(language.name).tag(language.value)
                        }
                    }
                    
                    TextField("source text", text:$input)
                        .frame(minHeight: geometry.size.height * 0.25, alignment: .topLeading)
                        .font(.title2)
                        .padding(5)
                    Picker("target language", selection: $target) {
                        ForEach(languages, id: \.self) { language in
                            Text(language.name).tag(language.value)
                        }
                    }
                    
                    TextField("target text", text: $output)
                        .frame(minHeight: geometry.size.height * 0.25, alignment: .topLeading)
                        .font(.title2)
                        .padding(5)
                    
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Button("Translate", action: { self.requestData() })
                            .font(.title)
                        Spacer()
                    }
                    
                }
            }
            //.navigationBarBackButtonHidden(true)
        }
        
    }
    
    func requestData() {
        // Build the URLRequest using URLComponents
        let url = URL(string: "https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems! += [
            URLQueryItem(name: "sl", value: self.source),
            URLQueryItem(name: "tl", value: self.target),
            URLQueryItem(name: "q", value: self.input) ]
        
        var request = URLRequest(url: (components?.url)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1", forHTTPHeaderField: "User-Agent")
        
        // Start the data task
        
        URLSession.shared.dataTask(with: request) { _data, res, err in
            if let _data = _data {
                print(String(describing: _data))
                if let response = try? JSONDecoder().decode(Response.self, from: _data) {
                    DispatchQueue.main.async {
                        self.output = response.sentences.map({ s in s.trans }).joined()
                    }
                }
            }
        }
        .resume()
    }
}

struct TranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        TranslatorView(source: "auto", target: "fr", input: "Hello world!", output: "Bonjour le monde!")
    }
}
