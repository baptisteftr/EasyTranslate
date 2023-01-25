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
    
    func translateRequest(input: String, arch: [String], lang: Int, type: String) {
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
                let tabbedTrad = reponse.data.translations[0].translatedText.components(separatedBy: ".")
                mergeTrad(arch: arch, trad: tabbedTrad, lang: lang, type: type)
            }
        }.resume()
    }
    
    func mergeTrad(arch: [String], trad: [String], lang: Int, type: String) {
        var finalString = ""
        
        for indice in arch.indices {
            finalString = type == "IOS" ? finalString + "\(UnicodeScalar(34) ?? "£")\(arch[indice])\(UnicodeScalar(34) ?? "£") = \(UnicodeScalar(34) ?? "£")\(trad[indice+1])\(UnicodeScalar(34) ?? "£")\n" : "<string name=\(UnicodeScalar(34) ?? "£")\(arch[indice])\(UnicodeScalar(34) ?? "£")>\(trad[indice+1])<\(UnicodeScalar(92) ?? "£")string>"
        }
        print(finalString)
        translatedContent[lang] = finalString
    }
    
    func parseString(toParse: String, type: String) {
        let separators = type == "IOS" ? CharacterSet(charactersIn: "=;\(UnicodeScalar(34) ?? "£")") : CharacterSet(charactersIn: "=<>\(UnicodeScalar(34) ?? "£")")
        let items = toParse.components(separatedBy: separators)
        var newString = ""
        var newTab = [String]()
        var i = type == "IOS" ? 4 : 5
        var j = type == "IOS" ? 1 : 3
        
        for indice in items.indices {
            if i <= indice {
                newString = newString + "."
                newString = newString + items[indice]
                i = i + (type == "IOS" ? 6 : 7)
            }
            if j <= indice {
                newTab.append(items[j])
                j = j + (type == "IOS" ? 6 : 7)
            }
        }
        for languageId in languageList.indices {
//            translateRequest(input: newString, arch: newTab, lang: languageId, type: type)
//            print("items: \(items)")
            print("tab: \(newTab)")
//            print("string: \(newString)")
        }
    }
}

//<string name="login_submit_button">Sign in</string>
//<string name="login_submit_button">Hello there</string>
//<string name="login_submit_button">Hi Jeannine</string>
//<string name="login_submit_button">You bastard</string>
