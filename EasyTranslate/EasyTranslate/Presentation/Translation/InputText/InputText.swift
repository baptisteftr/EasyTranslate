//
//  InputText.swift
//  EasyTranslate
//
//  Created by Baptiste Fortier on 24/01/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct InputText: View {
    private var gridItemLayout = [GridItem(.flexible())]
    private var clipboard = UIPasteboard.general
    
    @State var storedLang = languages
    @State var inputString: String = ""
    @State var inputType: [String] = ["IOS", "ANDROID"]
    @State private var selectedType = "IOS"
    @State private var selectedTarget = "ANDROID"
    @ObservedObject var translationManager = TranslationManager()
    @State var sent = false
    
    var body: some View {
        HStack {
            VStack {
                VStack {
                    baseAndTargetPicker()
                    LazyHGrid(rows: gridItemLayout) {
                        ForEach(storedLang.indices) { lang in
                            LanguageCapsule(language: storedLang[lang].language, selected: $storedLang[lang].selected)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                    .padding(.horizontal)
                }
                TextField("Copy past your file content here", text: $inputString, axis: .vertical)
                    .lineLimit(30, reservesSpace: true)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                parseButton()
            }
            .frame(maxWidth: (UIScreen.screenWidth/4)*3, maxHeight: .infinity, alignment: .topLeading)
            Divider()
            outputSide()
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func parseButton() -> some View {
        Button {
            translationManager.parseString(toParse: inputString, type: selectedType, storedLang: storedLang)
        } label: {
            Text("Generate file")
                .foregroundColor(.primary)
                .padding()
                .padding(.horizontal, 50)
                .background(Capsule(style: .circular)
                    .foregroundColor(Color(.systemBackground))
                )
                .background(Capsule(style: .circular).stroke(Color.primary))
        }
    }
    
    @ViewBuilder
    func baseAndTargetPicker() -> some View {
        HStack {
            HStack {
                Text("Base Format")
                Picker("Base format", selection: $selectedType) {
                    ForEach(inputType, id: \.self) {
                        Text($0)
                    }
                }
            }
            .padding(.horizontal)
            Divider()
            HStack {
                Text("Target Format")
                Picker("Base format", selection: $selectedTarget) {
                    ForEach(inputType, id: \.self) {
                        Text($0)
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
    }
    
    @ViewBuilder
    private func outputSide() -> some View {
        if translationManager.translated == true {
            VStack {
                ForEach(translationManager.translatedContent,  id: \.self) { lang in
                    Text(lang)
                        .onTapGesture {
                            clipboard.string = lang
                        }
                }
                .padding()
            }
            .frame(maxWidth: UIScreen.screenWidth/4, maxHeight: .infinity, alignment: .topLeading)
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .frame(maxWidth: UIScreen.screenWidth/4, maxHeight: .infinity, alignment: .center)
        }
    }
}
struct InputText_Previews: PreviewProvider {
    static var previews: some View {
        InputText()
    }
}
