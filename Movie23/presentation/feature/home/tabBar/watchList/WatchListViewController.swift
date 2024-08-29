//
//  WatchListViewController.swift
//  Movie23
//
//  Created by BS00880 on 8/7/24.
//

import UIKit

class WatchListViewController: UIViewController {
    
    let viewModel = DiModule.shared.resolve(WatchListViewModel.self)!
    
    var tableView = UITableView()
    var movies: [MovieListItemModel] = []
    
    struct Cells {
        static let movieCell = "MovieCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkerYellow
        self.setUpTableUI()
        bindViewModel()
        viewModel.initData();
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
        viewModel.notifyMovieListUpdated()
    }
    
    private func loadMovies() {
        movies = viewModel.movieArray
        tableView.reloadData()
    }
    
}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Total found movies for the user is: \(movies.count)")
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.movieCell) as! MovieListTableViewCell
        let singleMovie = movies[indexPath.row]
        cell.setCellValue(movie: singleMovie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movieArray[indexPath.row]
        let detailViewController = MovieDetailsViewController()
        detailViewController.movieId = selectedMovie.id
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let indexSet = IndexSet(integer: indexPath.row)
            viewModel.deleteItems(indexSet: indexSet)
            tableView.endUpdates()
        }
    }
}

