//
//  TranslationManager.swift
//  EasyTranslate
//
//  Created by Baptiste Fortier on 24/01/2023.
//

import Foundation

var session = URLSession.shared

func loadItem(from url: URL) async throws -> Translate {
    let (data, _) = try await session.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode(Translate.self, from: data)
}

class TranslationManager: ObservableObject {
    let url = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(UserDefaults.standard.string(forKey: "APIkey") ?? "")")
    @Published var translatedContent = [String]()
    @Published var translated: Bool = false
    
    func translateRequest(input: String, arch: [String], lang: String, type: String) {
        let body: [String: String] = [
            "q": input,
            "target": lang
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
                var tabbedTrad = reponse.data.translations.first?.translatedText.components(separatedBy: "|")
                tabbedTrad?.remove(at: 0)
                mergeTrad(arch: arch, trad: tabbedTrad ?? [""], type: type)
            }
        }.resume()
    }
    
    func mergeTrad(arch: [String], trad: [String], type: String) {
        var finalString = ""
        print(trad)
        for indice in arch.indices {
            if indice < arch.count {
                finalString = type == "IOS" ? finalString + "\(UnicodeScalar(34) ?? "£")\(arch[indice])\(UnicodeScalar(34) ?? "£") = \(UnicodeScalar(34) ?? "£")\(trad[indice])\(UnicodeScalar(34) ?? "£")\n" : "<string name=\(UnicodeScalar(34) ?? "£")\(arch[indice])\(UnicodeScalar(34) ?? "£")>\(trad[indice])<\(UnicodeScalar(92) ?? "£")string>\n"
            }
        }
        translatedContent.append(finalString)
    }
    
    func parseString(toParse: String, type: String, storedLang: [Language]) {
        translatedContent.removeAll()
        let separators = type == "IOS" ? CharacterSet(charactersIn: "=;\(UnicodeScalar(34) ?? "£")") : CharacterSet(charactersIn: "=<>\(UnicodeScalar(34) ?? "£")")
        let items = toParse.components(separatedBy: separators)
        var newString = ""
        var newTab = [String]()
        var i = type == "IOS" ? 4 : 5
        var j = type == "IOS" ? 1 : 3
        
        for indice in items.indices {
            if i <= indice {
                newString = newString + " | "
                newString = newString + items[indice]
                i = i + (type == "IOS" ? 6 : 7)
            }
            if j <= indice {
                newTab.append(items[j])
                j = j + (type == "IOS" ? 6 : 7)
            }
        }
        for language in storedLang {
//            print("input: \(newString)")
            if language.selected == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.translateRequest(input: newString, arch: newTab, lang: language.lang, type: type)
                }
            }
        }
        translated = true
    }
}
