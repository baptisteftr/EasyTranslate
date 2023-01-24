//
//  TranslationManager.swift
//  EasyTranslate
//
//  Created by Baptiste Fortier on 24/01/2023.
//

import Foundation

class TranslationManager: ObservableObject {

    let url = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(UserDefaults.standard.string(forKey: "APIkey") ?? "")")
    @Published var languageList = ["fr", "en", "es", "it"]
    @Published var translatedContent = ["Waiting for translation", "Waiting for translation", "Waiting for translation", "Waiting for translation"]
    
    func translateRequest(input: String, arch: [String], lang: Int) {
        let body: [String: String] = [
            "q": input,
            "target": languageList[lang]
        ]
        let finalData = try! JSONSerialization.data(withJSONObject: body)
        print(finalData)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = finalData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [self] (data, response, error ) in
            if data != nil {
                let reponse = try! JSONDecoder().decode(Translate.self, from: data!)
//                translatedContent[lang] = reponse.data.translations[0].translatedText
                var tabbedTrad = reponse.data.translations[0].translatedText.components(separatedBy: ".")
                print("len arch: \(arch.count) | trad: \(tabbedTrad.count)")
                mergeIOSTrad(arch: arch, trad: tabbedTrad, lang: lang)
            }
        }.resume()
    }
    
    func mergeIOSTrad(arch: [String], trad: [String], lang: Int) {
        var finalString = ""
        
        for indice in arch.indices {
            finalString = finalString + "\(UnicodeScalar(34) ?? "£")\(arch[indice])\(UnicodeScalar(34) ?? "£") = \(UnicodeScalar(34) ?? "£")\(trad[indice+1])\(UnicodeScalar(34) ?? "£")\n"
        }
        print(finalString)
        translatedContent[lang] = finalString
    }
    
    func parseIOSArchitecture(toParse: String) -> [String] {
        let separators = CharacterSet(charactersIn: "=;\(UnicodeScalar(34) ?? "£")")
        let items = toParse.components(separatedBy: separators)
        var newTab = [String]()
        var i = 1
        for indice in items.indices {
            if i <= indice {
                newTab.append(items[i])
                i = i + 6
            }
        }
//        print(newTab)
        return newTab
    }
    
    func parseString(toParse: String) {
        let separators = CharacterSet(charactersIn: "=;\(UnicodeScalar(34) ?? "£")")
        let items = toParse.components(separatedBy: separators)
        var newString = ""
        var i = 4
        
        for indice in items.indices {
            if i <= indice {
                newString = newString + "."
                newString = newString + items[indice]
                i = i + 6
            }
        }
        var arch = parseIOSArchitecture(toParse: toParse)
        for j in languageList.indices {
            translateRequest(input: newString, arch: arch, lang: j)
        }
//        print(translationManager.translatedContent.split(separator: "."))
        
//        var finalString = ""
//        let finalSeparators = CharacterSet(charactersIn: ".")
//        let finalItems = translationManager.translatedContent[0].components(separatedBy: finalSeparators)
//
//        for indice in finalItems.indices {
//
//        }
//        print(newString)
    }
}

//struct Networking {
//    var urlSession = URLSession.shared
//
//    func postTranslation(input: String, lang: String) -> String {
//        let url = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(UserDefaults.standard.string(forKey: "APIkey") ?? "")")
//        let body: [String: String] = [
//            "q": input,
//            "target": lang
//        ]
//        let finalData = try! JSONSerialization.data(withJSONObject: body)
//    }
//}
