//
//  InputText.swift
//  EasyTranslate
//
//  Created by Baptiste Fortier on 24/01/2023.
//

import SwiftUI

struct InputText: View {
    @State var inputString: String = ""
    @ObservedObject var translationManager = TranslationManager()
    @State var sent = false
    
    var body: some View {
//        HStack {
//            VStack {
//                HStack {
//                    ForEach(languages) { language in
//                        LanguageCapsule(language: language.language)
//                    }
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                TextField("Put your text here", text: $inputString, axis: .vertical)
//                    .lineLimit(30, reservesSpace: true)
//                    .textFieldStyle(.roundedBorder)
//            }
//            .padding()
//        }
//        .frame(maxWidth: sent ? UIScreen.screenWidth/4 : (UIScreen.screenWidth/4) * 3, maxHeight: .infinity, alignment: .topLeading)
//        Divider()
//        Spacer()
        HStack {
            VStack {
                Text("To translate")
                TextField("Input ...", text: $inputString, axis: .vertical)
                    .lineLimit(30, reservesSpace: true)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button {
//                    translationManager.parseIOSArchitecture(toParse: inputString)
                    translationManager.parseString(toParse: inputString, type: "ANDROID")
                } label: {
                    Text("parse")
                }
            }
            .frame(maxWidth: (UIScreen.screenWidth/4)*3, maxHeight: .infinity, alignment: .topLeading)
            Divider()
            VStack {
                ForEach(translationManager.languageList.indices, id: \.self) { index in
                    Text(translationManager.languageList[index])
                    Text(translationManager.translatedContent[index])
                }
                .padding()
            }
            .frame(maxWidth: UIScreen.screenWidth/4, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(Color(.systemGray6))
    }
    
    @ViewBuilder
    func outputSide() -> some View {
        VStack {
            
        }
    }
}

struct InputText_Previews: PreviewProvider {
    static var previews: some View {
        InputText(translationManager: TranslationManager())
    }
}
