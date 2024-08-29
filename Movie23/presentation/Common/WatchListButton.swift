//
//  WatchListButton.swift
//  Movie23
//
//  Created by BS00880 on 8/7/24.
//

import UIKit

class WatchListButton: UIButton {

    var title = LocalizedStringKey.addToWatchlist.localized()
    var alreadyInWatchList = false
//    private var watchListViewModel: WatchListViewModel
    private var watchListViewModel = DiModule.shared.resolve(WatchListViewModel.self)!
    private var movieItem: MovieListItemModel
    enum FontSize {
        case big
        case medium
        case small
    }
    
    
    init(/*watchListViewModel: WatchListViewModel, */movieItem: MovieListItemModel, hasBackground: Bool = false, fontSize: FontSize, titleColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        self.movieItem = movieItem
        super.init(frame: .zero)
        
        if self.watchListViewModel.movieArray.contains(where: { $0.id == movieItem.id}) {
            alreadyInWatchList = true
        } else {
            alreadyInWatchList = false
        }
        
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        self.backgroundColor = backgroundColor ?? (hasBackground ? .systemPurple : .clear)
        
        let finalTitleColor: UIColor = titleColor ?? (hasBackground ? .white : .systemPurple)
        self.setTitleColor(finalTitleColor, for: .normal)
        
        switch fontSize {
        case .big:
            self.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
            
        case .medium:
            self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            
        case .small:
            self.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        }
        
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        guard let viewController = self.findViewController() else { return }
        var alertTitle = ""
        var alertMessage = ""
        var okButtonTitle = ""
//        watchListViewModel.addItems(movie: movieItem)
        if alreadyInWatchList == true {
            okButtonTitle = "Delete"
            alertTitle = "Item exits"
            alertMessage = "Item already exists in your watch list. Do you want to remove it?"
        } else {
            okButtonTitle = "Add"
            alertTitle = "Movie Adding"
            alertMessage = "This movie will be added to your watch list. Continue?"
//            movieItem.isFavourite = true
        }
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okButtonTitle, style: .default) { _ in
            if self.alreadyInWatchList == true {
//                self.movieItem.isFavourite = false
                self.watchListViewModel.deleteItems(movie: self.movieItem)
//                self.movieItem.isFavourite = false
            } else {
                self.watchListViewModel.addItems(movie: self.movieItem)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}

