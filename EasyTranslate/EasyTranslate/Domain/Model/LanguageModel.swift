//
//  LanguageModel.swift
//  EasyTranslate
//
//  Created by Baptiste Fortier on 24/01/2023.
//

import Foundation

struct requestBody: Codable {
    var q: String
    var target: String
}

// MARK: - Translate
struct Translate: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let translatedText, detectedSourceLanguage: String
}

struct Language: Codable, Identifiable {
    var id = UUID()
    var language: String
    var lang: String
    var selected: Bool
}

var languages: [Language] = [
    Language(language: "French 🇫🇷", lang: "fr", selected: false),
    Language(language: "English 🇺🇸", lang: "en", selected: false),
    Language(language: "Spanish 🇪🇸", lang: "es", selected: false),
    Language(language: "German 🇩🇪", lang: "de", selected: false),
    Language(language: "Italian 🇮🇹", lang: "it", selected: false),
    Language(language: "Chinese 🇨🇳", lang: "zh", selected: false),
    Language(language: "Japanese 🇯🇵", lang: "ja", selected: false),
    Language(language: "Russian 🇷🇺", lang: "ru", selected: false)
]

struct TranslatedStruct: Codable, Identifiable {
    var id = UUID()
    var lang: String
    var translation: String
}
