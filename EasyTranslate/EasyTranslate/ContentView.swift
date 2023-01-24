//
//  ContentView.swift
//  EasyTranslate
//
//  Created by Baptiste Fortier on 24/01/2023.
//

import SwiftUI

struct ContentView: View {
    @State var langs: [Language] = languages
    @State var selectedLang: Language?
    @State var showSheet: Bool = false
    @State var apitext: String = ""
    var body: some View {
            HStack {
                InputText()
            }
            .sheet(isPresented: $showSheet) {
                TextField("Enter API key ...", text: $apitext)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button {
                    UserDefaults.standard.set(apitext, forKey: "APIkey")
                    showSheet.toggle()
                } label: {
                    Text("Validate")
                }
            }
            .ignoresSafeArea()
            .onAppear {
                if (UserDefaults.standard.string(forKey: "APIkey") == nil) {
                    showSheet.toggle()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
