//
//  HeaderView.swift
//  translate
//
//  Created by Ryan Cormier on 9/24/20.
//

import SwiftUI

struct HeaderView: View {
    //var banner: UIImage?
    var bgColor: Color
    var title: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Ellipse()
                    .frame(width: geometry.size.width * 1.4, height: geometry.size.height * 0.33)
                    .position(x: geometry.size.width / 2.35, y: geometry.size.height * 0.05)
                    .shadow(radius: 3)
                    .edgesIgnoringSafeArea(.all)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(self.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.accentColor)
                        
                        Spacer()
                    }
                    .padding(.leading, 25)
                    .padding(.top, 30)
                    
                    Spacer()
                }
            }
        }
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(bgColor: Color.accentColor, title: "Translate")
    }
}
