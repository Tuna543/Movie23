//
//  LanguageManager.swift
//  Movie23
//
//  Created by BS00880 on 10/7/24.
//

//
//  LanguageManager.swift
//  MovieApp
//
//  Created by BS00880 on 6/6/24.
//

//import Foundation
//import Combine
//
//class LanguageManager: ObservableObject {
//    static let shared = LanguageManager()
//
//    @Published var currentLanguage: Language = .english {
//        didSet {
////            NotificationCenter.default.post(name: .languageDidChange, object: nil)
//            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "appLanguage")
////            UserDefaults.standard.string(forKey: "appLanguage")
//        }
//    }
//    
//    enum Language: String {
//        case english = "en"
//        case bengali = "bn-BD"
//    }
//    
//    private init() {
//        let savedLanguage = UserDefaults.standard.string(forKey: "appLanguage") ?? Language.english.rawValue
//        currentLanguage = Language(rawValue: savedLanguage) ?? .english
//    }
//
//    func localizedString(forKey key: String) -> String {
//        let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj")!
//        let bundle = Bundle(path: path)!
//        return NSLocalizedString(key, bundle: bundle, comment: "")
//    }
//
//    func setLanguage(_ language: Language) {
//        currentLanguage = language
//        print("Language set to \(language.rawValue)")
//    }
//}

//extension Notification.Name {
//    static let languageDidChange = Notification.Name("languageDidChange")
//}

//import Foundation
//
//class LanguageManager {
//    static let shared = LanguageManager()
//    
//    private init() {}
//    
//    func setLanguage(languageCode: String) {
//        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
//        UserDefaults.standard.synchronize()
//        
//        NotificationCenter.default.post(name: .languageDidChange, object: nil)
//    }
//    
//    func currentLanguage() -> String {
//        return UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? "en"
//    }
//}
//
//extension Notification.Name {
//    static let languageDidChange = Notification.Name("languageDidChange")
//}
