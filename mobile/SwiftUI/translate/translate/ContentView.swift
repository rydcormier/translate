//
//  ContentView.swift
//  translate
//
//  Created by Ryan Cormier on 9/25/20.
//
import Foundation
import SwiftUI

struct ContentView: View {
    @State var source:  String = "auto"
    @State var target:  String = "fr"
    @State var input:   String = ""
    @State var output:  String = ""
    
    var body: some View {
        GeometryReader {geometry in
                NavigationView {
                    VStack(alignment: .center) {
                    Form {
                        Picker("source", selection:$source) {
                            Text("auto detect").tag("auto")
                            ForEach(languages) { lang in
                                Text(lang.name).tag(lang.value)
                            }
                        }
                        TextField("Enter some text", text: $input)
                            .font(.title2)
                            .frame(minHeight: geometry.size.height * 0.27,
                                   alignment: .topLeading)
                        
                        Picker("target", selection: $target) {
                            ForEach(languages) { lang in
                                Text(lang.name).tag(lang.value)
                            }
                        }
                        
                        TextField("", text: $output)
                            .font(.title2)
                            .frame(minHeight: geometry.size.height * 0.27,
                                   alignment: .topLeading)
                        HStack {
                            Spacer()
                            
                            Button("Translate", action: { self.requestTranslation() })
                                .font(.title)
                            
                            Spacer()
                        }
                        
                    }
                    .navigationBarItems(trailing: Image("logo").resizable().clipped())
                }
                }
                .frame(maxHeight: .infinity)
            }
            .edgesIgnoringSafeArea(.top)
    }
    
    func requestTranslation() {
        let url = URL(string: "https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e")!
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "User-Agent": "AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1"]
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "sl", value: self.source),
            URLQueryItem(name: "tl", value: self.target),
            URLQueryItem(name: "q", value: self.input)
        ]
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems! += queryItems
        
        var request = URLRequest(url: (components?.url)!)
        
        for (key, val) in headers {
            request.setValue(val, forHTTPHeaderField: key)
        }
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            if let data = data {
                if let response = try? JSONDecoder().decode(Response.self, from: data) {
                    
                    DispatchQueue.main.async {
                        self.output = response.sentences.map({ s in s.trans }).joined()
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
