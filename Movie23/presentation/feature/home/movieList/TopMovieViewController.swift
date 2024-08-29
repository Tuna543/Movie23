//
//  TopMovieViewController.swift
//  Movie23
//
//  Created by BS00880 on 25/6/24.
//

import UIKit
import Combine

class TopMovieViewController: UIViewController {
    let viewModel = MovieListViewModel(movieRepository: MovieRepositoryImpl(apiService: APIServiceImplemention(apiClient: APIClientImp())))
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
//        scrollView.backgroundColor = .blue         //use color for testing
        return scrollView
    } ()
    
    private let stackview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
//        stackView.backgroundColor = .red          //use color for testing
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        self.setUpUI()
        
    }
    
    private func setUpUI() {
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ])
        
        scrollView.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackview.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackview.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackview.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackview.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackview.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.movieListUpdated = { [weak self] in
            self?.addPosterViews()
        }
    }
    
    private func addPosterViews(/*with movieList: [MovieListItemModel]*/) {
        
        for movie in viewModel.movieList {
            let posterView = MoviePosterView(image: movie.poster, title: movie.title, year: movie.releaseYear, mpaRating: movie.mpaRating, runtime: movie.duration)
            stackview.addArrangedSubview(posterView)
            posterView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                posterView.widthAnchor.constraint(equalToConstant: 100)
            ])
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(posterViewTapped(_:)))
            posterView.isUserInteractionEnabled = true
            posterView.addGestureRecognizer(tapGestureRecognizer)
            posterView.tag = movie.id // Set the tag to the movie's id for identification
        }
    }
    
    @objc private func posterViewTapped(_ sender: UITapGestureRecognizer) {
        if let posterView = sender.view as? MoviePosterView {
            let movieId = posterView.tag
            navigateToMovieDetails(movieId: movieId)
        }
    }

    private func navigateToMovieDetails(movieId: Int) {
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.movieId = movieId
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}
