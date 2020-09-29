//
//  ContentView.swift
//  translate
//
//  Created by Ryan Cormier on 9/28/20.
//
//  The main view for the translate app.
//

import Foundation
import SwiftUI

struct ContentView: View {
    //  The view takes the source language, target language, and the source
    //  text and requests the translation which is stored in the string output.
    @State var input: String = ""
    @State var output: String = ""
    @State var source: String = "auto"
    @State var target: String = "zh-cn"
    
    init() {
        // There is no section header or navigation bar. This moves the
        //  form closer to the top
        UITableView.appearance().contentInset.top = -35
    }
    
    var body: some View {
        // A Form inside a NavigationView handles the user input and displays
        // the requested translation
        GeometryReader { geometry in
            
            NavigationView {
                
                VStack(alignment: .center) {
                    
                    // Add logo to top left
                    HStack(alignment: .top) {
                        Spacer()
                        Image("logo")
                    }
                    .padding()
                    
                    Form {
                        
                        // source language
                        Picker("source language", selection: $source) {
                            Text("auto detect").tag("auto")
                            ForEach(languages) { l in
                                Text(l.name).tag(l.value)
                            }
                        }
                        
                        // input text
                        TextField("Enter some text", text: $input)
                            .font(.title2)
                            .frame(minHeight: geometry.size.height * 0.28, alignment: .topLeading)
                            .padding(.top)
                        
                        // target language
                        Picker("target language", selection: $target) {
                            ForEach(languages) { l in
                                Text(l.name).tag(l.value)
                            }
                        }
                        
                        // output text
                        Text(self.output)
                            .font(.title2)
                            .frame( minHeight: geometry.size.height * 0.28,
                                    alignment: .topLeading)
                            .padding(.top)
                        
                        // iniate translation
                        HStack(alignment: .center) {
                            Spacer()
                            Button("Translate", action: { requestTranslation() })
                                .font(.title)
                            Spacer()
                        }
                        
                    }
                }
                .navigationBarTitle("translate")
                .navigationBarHidden(true)
            }
        }
    }
    
    func requestTranslation() {
        //  Request a translation from the server, decode the response, and
        //  store the result in output
        
        // build request from components
        var components = URLComponents(url: API.url, resolvingAgainstBaseURL: true)
        components?.queryItems! += [
            URLQueryItem(name: "sl", value: self.source),
            URLQueryItem(name: "tl", value: self.target),
            URLQueryItem(name: "q", value: self.input)
        ]
        
        var request = URLRequest(url: (components?.url)!)
        
        // add method and headers
        request.httpMethod = "POST"
        for (name, value) in API.headers {
            request.setValue(value, forHTTPHeaderField: name)
        }
        
        // start the data task
        URLSession.shared.dataTask(with: request) { data, res, err in
            if let data = data {
                print(data)
                if let response = try? JSONDecoder().decode(Response.self, from: data) {
                    var output = response.sentences.map(
                        { s in s.trans ?? "" }).joined()
                    
                    //  There may be alternate character representation. Add it
                    //  if it exists
                    let alt_output = response.sentences.map(({ s in s.translit ?? "" })).joined()
                    if (!alt_output.isEmpty) {
                        output = [ output, alt_output ].joined(separator: "\n\n")
                    }
                    
                    // State change
                    DispatchQueue.main.async {
                        self.output = output
                    }
                }
            }
        }
        .resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
