//
//  Controller.swift
//  Translate
//
//  Created by Ryan Cormier on 9/22/20.
//

import SwiftUI
import Combine

struct Controller: View {
    @State var targetText: String = ""
    @EnvironmentObject var input: Input
    
    var body: some View {
        VStack(alignment: .center) {
            Form {
                InputView()
                
                TextField("Target", text: $targetText)
                    .font(.title2)
                    .frame(minHeight: 220, alignment: .topLeading)
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                HStack {
                    Spacer()
                    Button("Translate", action: { self.requestData() })
                        .padding(.bottom)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    func requestData() {
        // Build the URLRequest using URLComponents
        let url = URL(string: "https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems! += [
            URLQueryItem(name: "sl", value: input.source.value),
            URLQueryItem(name: "tl", value: input.target.value),
            URLQueryItem(name: "q", value: input.text) ]
        
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
                        self.targetText = response.sentences.map({ s in s.trans }).joined()
                    }
                }
            }
        }
        .resume()
    }
    
    
    struct Response: Codable { var sentences: [Sentence] }
    struct Sentence: Codable { var trans: String }
}

struct Controller_Previews: PreviewProvider {
    static var previews: some View {
        Controller()
            .environmentObject(Input())
    }
}
