//
//  WatchListViewModel.swift
//  Movie23
//
//  Created by BS00880 on 9/7/24.
//


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
@MainActor
class WatchListViewModel: ObservableObject {
    let authenticationManger = DiModule.shared.resolve(AuthenticationManager.self)!
    
    private var userId: String?
    @Published var itemAlreadyInWatchList: Bool = false
    
    @Published var movieArray: [MovieListItemModel] = [] {
        didSet {
            print("movie array didset called")
            self.notifyMovieListUpdated()
            Task {
                await saveItems()
            }
        }
    }
    var movieListUpdated: (() -> Void)?
    
    init() {
        initData()
    }
    
    func initData() {
        if let userId = authenticationManger.currentUser?.id {
            print("User id found in \(userId)")
            self.userId = userId
            Task {
                await fetchUser()
            }
        }
    }
    
    func fetchUser() async {
        self.movieArray = authenticationManger.currentUser?.movies ?? []
        self.notifyMovieListUpdated()
    }

    func deleteItems(indexSet: IndexSet) {
        movieArray.remove(atOffsets: indexSet)
        Task {
            await saveItems()
        }
    }
    
    func deleteItems(movie: MovieListItemModel) {
        let id = movie.id
        movieArray.removeAll(where: { $0.id == id})
        Task {
            await saveItems()
        }
    }
    
    
    func moveItems(from: IndexSet, to: Int) {
        movieArray.move(fromOffsets: from, toOffset: to)
    }
    
    func addItems(movie: MovieListItemModel) {
        if movieArray.contains(where: { $0.id == movie.id }) {
            itemAlreadyInWatchList = true
        }
        else {
            itemAlreadyInWatchList = false
            movieArray.append(movie/*addToFavourites(movie: movie)*/)
        }
        Task {
            await saveItems()
        }
    }
    
    
    func saveItems() async {
        await updateInFirestore()
    }
    
    func updateInFirestore () async /*throws */{
        guard let uid = authenticationManger.currentUser?.id else { return }
        guard var currentUserInfo = authenticationManger.currentUser else { return }
        currentUserInfo.movies = movieArray
        let personInfo = Firestore.firestore().collection("users").document(uid)
        do {
            try await personInfo.setData(from: currentUserInfo)
            print("Document successfully updated")
        } catch {
            print("Error updating document: \(error)")
        }
    }
    
    func resetUser() {
        self.movieArray = []
        self.userId = nil
    }
    
    func setUser(userId: String) {
        self.userId = userId
        Task {
            await fetchUser()
        }
    }
    
    func addToFavourites(movie: MovieListItemModel) -> MovieListItemModel {
        var favouriteMovie = movie
        favouriteMovie.isFavourite = true
        return favouriteMovie
    }
    
    func removeFromFavourites(movie: MovieListItemModel) -> MovieListItemModel {
        var notFavouriteMovie = movie
        notFavouriteMovie.isFavourite = false
        return notFavouriteMovie
    }
    
    func notifyMovieListUpdated() {
        print("movieListUpdated closure called")
        self.movieListUpdated?()
    }
}
