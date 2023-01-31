//
//  InputText.swift
//  EasyTranslate
//
//  Created by Baptiste Fortier on 24/01/2023.
//

import SwiftUI

struct InputText: View {
    private let pasteboard = UIPasteboard.general
    private var gridItemLayout = [GridItem(.adaptive(minimum: 120))]
    
    @State var storedLang = languages
    @State var inputString: String = ""
    @State var inputType: [String] = ["IOS", "ANDROID"]
    @State private var selectedType = "IOS"
    @ObservedObject var translationManager = TranslationManager()
    @State var sent = false
    
    var body: some View {
        HStack {
            VStack {
                VStack {
                    HStack {
                        Text("Base Format")
                        Picker("Base format", selection: $selectedType) {
                            ForEach(inputType, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
                        GridRow() {
                            ForEach(storedLang.indices) { lang in
                                LanguageCapsule(language: storedLang[lang].language, selected: $storedLang[lang].selected)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                TextField("Input ...", text: $inputString, axis: .vertical)
                    .lineLimit(30, reservesSpace: true)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button {
//                    translationManager.parseIOSArchitecture(toParse: inputString)
                    translationManager.parseString(toParse: inputString, type: selectedType)
                } label: {
                    Text("parse")
                }
            }
            .frame(maxWidth: (UIScreen.screenWidth/4)*3, maxHeight: .infinity, alignment: .topLeading)
            Divider()
//            VStack {
//                ForEach(translationManager.languageList.indices, id: \.self) { index in
//                    Text(translationManager.languageList[index])
//                    Text(translationManager.translatedContent[index])
//                }
//                .padding()
//            }
            outputSide()
        }
        .background(Color(.systemGray6))
    }
    
    @ViewBuilder
    func outputSide() -> some View {
        if translationManager.translated == true {
            HStack {
                VStack {
                    Text("IOS")
                    ForEach(translationManager.languageList.indices, id: \.self) { index in
                        Text(translationManager.languageList[index])
                            .onTapGesture {
                                pasteboard.string = translationManager.languageList[index]
                            }
                    }
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("Android")
                    ForEach(translationManager.languageList.indices, id: \.self) { index in
                        Text(translationManager.languageList[index])
                            .onTapGesture {
                                pasteboard.string = translationManager.languageList[index]
                            }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: UIScreen.screenWidth/4, maxHeight: .infinity, alignment: .topLeading)
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .frame(maxWidth: UIScreen.screenWidth/4, maxHeight: .infinity, alignment: .center)
        }
    }
//    pasteboard.string = self.text
}
struct InputText_Previews: PreviewProvider {
    static var previews: some View {
        InputText()
    }
}
