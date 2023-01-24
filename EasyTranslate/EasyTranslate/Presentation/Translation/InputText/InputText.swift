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
    
    var body: some View {
        HStack {
            VStack {
                Text("To translate")
                TextField("Input ...", text: $inputString, axis: .vertical)
                    .lineLimit(30, reservesSpace: true)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button {
//                    translationManager.parseIOSArchitecture(toParse: inputString)
                    translationManager.parseString(toParse: inputString)
                } label: {
                    Text("parse")
                }
            }
            .frame(maxWidth: UIScreen.screenWidth/2, maxHeight: .infinity, alignment: .topLeading)
            .background(Color(.systemGray6))
            VStack {
                ForEach(translationManager.languageList.indices, id: \.self) { index in
                    Text(translationManager.languageList[index])
                    Text(translationManager.translatedContent[index])
                }
            }
            .frame(maxWidth: UIScreen.screenWidth/2, maxHeight: .infinity, alignment: .topLeading)
        }
    }
    
//    func replaceData(architecture: [String], translation: String) -> String {
//        var finalString = ""
//        let separators = CharacterSet(charactersIn: ".")
//        let items = inputString.components(separatedBy: separators)
//    }
}

struct InputText_Previews: PreviewProvider {
    static var previews: some View {
        InputText(translationManager: TranslationManager())
    }
}
