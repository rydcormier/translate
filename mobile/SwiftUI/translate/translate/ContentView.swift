//
//  ContentView.swift
//  Translate
//
//  Created by Ryan Cormier on 9/22/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
        Controller()
            .environmentObject(Input())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Input())
    }
}
