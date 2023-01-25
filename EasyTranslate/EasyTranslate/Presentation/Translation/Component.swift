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

struct LanguageCapsule: View {
    @State var language: String
    @State var selected = false
    
    var body: some View {
        Button {
            withAnimation {
                selected.toggle()
            }
        } label: {
            VStack {
                Text(language)
                    .foregroundColor(.primary)
            }.padding(.vertical, 10)
                .padding(.horizontal)
                .background(
                    Capsule()
                        .stroke()
                        .foregroundStyle(selected ? .primary : .secondary)
                        .background(selected ? .accentColor : Color.white)
                )
                .clipShape(Capsule())
        }
    }
}

struct LanguageCapsule_Previews: PreviewProvider {
    static var previews: some View {
        LanguageCapsule(language: "French 🇫🇷")
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

//struct Component_Previews: PreviewProvider {
//    static var previews: some View {
//        targetLanguCapsule(language: "fr", selected: )
//    }
//}
