//
//  MovieListViewController.swift
//  Movie23
//
//  Created by BS00880 on 26/6/24.
//

import UIKit

class MovieListViewController: UIViewController {
    let viewModel = MovieListViewModel(movieRepository: MovieRepositoryImpl(apiService: APIServiceImplemention(apiClient: APIClientImp())))
    
    var tableView = UITableView()
    var movies: [MovieListItemModel] = []
//    var viewModel: MovieListViewModel?
    
    struct Cells {
        static let movieCell = "MovieCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movie Lists"
//        movies = viewModel.movieList
        bindViewModel()
        setUpTableUI()
    }
    
    func setUpTableUI() {
        view.addSubview(tableView)
        setDelegate()
        tableView.rowHeight = 150
        tableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: Cells.movieCell)
        tableView.pin(to: view)
        
    }
    
    func setDelegate () {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.movieListUpdated = { [weak self] in
            self?.loadMovies()
        }
    }
    
    private func loadMovies() {
        movies = viewModel.movieList
        tableView.reloadData()
    }
    
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.movieList.count)
        return viewModel.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.movieCell) as! MovieListTableViewCell
        let singleMovie = movies[indexPath.row]
        cell.setCellValue(movie: singleMovie, showWatchListButton: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movieList[indexPath.row]
        let detailViewController = MovieDetailsViewController()
        detailViewController.movieId = selectedMovie.id
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MovieListViewController {
    func fetchMovieList() -> [MovieDetailsResponse.Movie] {
        return MovieDetailsResponse.Movie.movieArrayShowForTest
    }
}
