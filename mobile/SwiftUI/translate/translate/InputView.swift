//
//  InputView.swift
//  Translate
//
//  Created by Ryan Cormier on 9/23/20.
//

import SwiftUI

class Input: ObservableObject {
    @Published var source: Language
    @Published var target: Language
    @Published var text: String
    
    init(text: String? = nil, source: Language? = nil, target: Language? = nil) {
        self.text = text ?? "Enter some text."
        self.source = source ?? Language.autoDetect
        self.target = target ?? Language.testLang
    }
    
    var data: [String: String] {
        return [ "sl" : self.source.value, "tl" : self.target.value, "q" : self.text]
    }
}

struct InputView: View {
    @EnvironmentObject var input: Input
    
    var body: some View {
                Picker("Source", selection: $input.source) {
                    Text("auto detect").tag(Language.autoDetect)
                    ForEach(languages, id: \.self) { language in
                        Text(language.name).tag(language)
                    }
                }
                
                TextField("Text", text: $input.text)
                    .font(.title2)
                    .frame(minHeight: 220, alignment: .topLeading)
                
                Picker("Target", selection: $input.target) {
                    ForEach(languages, id: \.self) { language in
                        Text(language.name).tag(language)
                    }
                }
        }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
            .environmentObject(Input())
    }
}
