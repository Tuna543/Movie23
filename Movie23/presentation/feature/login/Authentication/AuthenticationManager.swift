//
//  AuthenticationManager.swift
//  Movie23
//
//  Created by BS00880 on 24/6/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var userFirebaseSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userFirebaseSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }

    
    func fetchUser() async {
        print("into fetch user function from authentication manager")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        print("snapshot data: \(snapshot)")
        self.currentUser = try? snapshot.data(as: User.self)
        print("From authentication manager Fetched current user \(self.currentUser)")
        print("From authentication manager current user name \(self.currentUser?.userName)")
        print("From authentication manager current user email id \(self.currentUser?.email)")
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userFirebaseSession = result.user
            print("Sign In successful")
            await fetchUser()
        } catch {
            print("Error while logging in \(error)")
        }
    }
    
    func createUser(userName: String, email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userFirebaseSession = result.user
            let user = User(id: result.user.uid, userName: userName, email: email, movies: [])
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            print("user created successfully")
            await fetchUser()
        } catch {
            print("Error in creating user \(error)")
        }
    }
    
    func signOut () async throws {
        do {
            try Auth.auth().signOut()
            self.userFirebaseSession = nil
            self.currentUser = nil
            
        } catch {
            print("Error while signing out \(error)")
        }
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else { return }
        
        do {
            try await Firestore.firestore().collection("users").document(user.uid).delete()
            try await user.delete()
            self.userFirebaseSession = nil
            self.currentUser = nil
            print("Account deleted")
        } catch {
            print("DEBUG: Failed to delete account with Error \(error)")
        }
    }
//    
//    func signInWithGoogle() async throws {
//        guard let topView = TopViewController.shared.topViewController() else {
//            throw URLError(.cannotFindHost)
//        }
//        
//        do {
//            let googleSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topView)
//            
//            guard let idToken = googleSignInResult.user.idToken?.tokenString else {
//                throw URLError(.badServerResponse)
//            }
//            let accessToken = googleSignInResult.user.accessToken.tokenString
//            
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
//            
//            let authDataResult = try await Auth.auth().signIn(with: credential)
//            
//            let uid = authDataResult.user.uid
//            guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
//            self.userFirebaseSession = authDataResult.user
//            if !snapshot.exists {
//                let user = UserInfo(id: uid, email: authDataResult.user.email, userName: authDataResult.user.displayName, movies: [])
//                let encodedUser = try Firestore.Encoder().encode(user)
//                try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
//            }
//            await fetchUser()
//        } catch {
//            print("Error in creating user with google sign in \(error)")
//        }
//    }
}
