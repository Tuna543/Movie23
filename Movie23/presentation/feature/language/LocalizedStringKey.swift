//
//  LocalizedStringKey.swift
//  Movie23
//
//  Created by BS00880 on 15/7/24.
//

import Foundation

enum LocalizedStringKey: String {
    case greeting
    case farewell
    
 
    case settings
    case language
    case theme
    case darkTheme
    case eng
    case ban
    case home
    case addToWatchlist
    case dropFromWatchlist
    case welcomeBack
    case userName
    case topMoviePicks
    case upcomingMovies
    case seeAll
    case search
    case sortAndFilter
    case sortBy
    case genres
    case orderBy
    case apply
    case watchList
    case movieDetails
    case pleaseSignInToYourAccount
    case email
    case password
    case forgotPassword
    case dontHaveAnAccount
    case signIn
//    case dontHaveAnAccount
    case signUp
    case welcome
    case createNewAccount
    case confirmPassword
    case signInWithGoogle
    case general
    case accountSettings
    case signOut
    case deleteAccount
    case itemAlreadyExitsInYourWatchList
    case itemAddedToYourWatchList
    case alert
    case oK
    case overallRating
    case yourRating



    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static var currentLanguage: String = "en" {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
//            NotificationCenter.default.post(name: .languageDidChange, object: nil)
        }
    }
    
    static func setLanguage(_ language: String) {
        currentLanguage = language
    }
}
//
//extension Notification.Name {
//    static let languageDidChange = Notification.Name("languageDidChange")
//}
