//
//  Component.swift
//  EasyTranslate
//
//  Created by Baptiste Fortier on 24/01/2023.
//

import SwiftUI

struct targetLanguCapsule: View {
    @State var language: String
    @State var selected: Bool
    var body: some View {
        Button {
            selected.toggle()
        } label: {
            HStack {
                Text(language)
            }
        }
    }
}

//struct Component_Previews: PreviewProvider {
//    static var previews: some View {
//        targetLanguCapsule(language: "fr", selected: )
//    }
//}
