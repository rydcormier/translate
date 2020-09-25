//
//  ContentView.swift
//  Translate
//
//  Created by Ryan Cormier on 9/22/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            
            TranslatorView(source: "auto", target: "fr", input: "Hello world!", output: "Bonjour le monde!")
                //.padding(.top, geometry.size.height * 0.1)
            Image(decorative: "banner")
                .position(x: geometry.size.width * 0.65, y: geometry.size.height * 0.07)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Input())
    }
}
