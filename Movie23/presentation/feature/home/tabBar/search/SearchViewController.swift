//
//  SearchController.swift
//  Movie23
//
//  Created by BS00880 on 3/7/24.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
//    let viewModel = SearchViewModel(movieRepository: MovieRepositoryImpl(apiService: APIServiceImplemention(apiClient: APIClientImp())))
    
    let filterViewModel = FilterViewModel(movieRepository: MovieRepositoryImpl(apiService: APIServiceImplemention(apiClient: APIClientImp())))
    private let searchController = UISearchController(searchResultsController: nil)
    var tableView = UITableView()
    var movies: [MovieListItemModel] = []

    private var selectedGenres: Set<MovieGenre> = []
    private var selectedSort: SortBy? = nil
    private var selectedOrder: OrderBy? = nil
    let filterImageRight = UIImageView(image: UIImage(systemName: "slider.vertical.3"))
    
    struct Cells {
        static let movieCell = "MovieCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()
        setUpTableUI()
        bindViewModel()
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
        filterViewModel.movieListUpdated = { [weak self] in
            self?.loadMovies()
        }
    }
    
    private func loadMovies() {
        DispatchQueue.main.async {
            self.movies = self.filterViewModel.movieList
            self.tableView.reloadData()
        }
    }
    
    
    private func setUpSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = LocalizedStringKey.search.localized()
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), style: .plain, target: self, action: #selector(filterButtonTapped))
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc private func filterButtonTapped() {
        presentFilterSearchView()
    }
    
    private func presentFilterSearchView() {
        let filterSearchView = FilterSearchView()
        filterSearchView.applyFilters = { [weak self] selectedGenres, selectedSort, selectedOrder in
            self?.handleSelectedFilters(genres: selectedGenres, sort: selectedSort, order: selectedOrder)
            self?.dismiss(animated: true, completion: nil)
        }
        
        let filterSearchViewController = UIViewController()
        filterSearchViewController.view = filterSearchView
        filterSearchViewController.modalPresentationStyle = .formSheet
        present(filterSearchViewController, animated: true, completion: nil)
    }
    
    private func handleSelectedFilters(genres: Set<MovieGenre>?, sort: SortBy?, order: OrderBy?) {
        self.selectedGenres = genres ?? []
        self.selectedSort = sort
        self.selectedOrder = order
        let sortType = selectedSort?.rawValue
        let orderType = selectedOrder?.rawValue
        let genreType = selectedGenres.map { $0.rawValue }.joined(separator: ", ") ?? ""

        
        print("Selected Genres: in VC: \(genres)")
        print("Selected Sort in VC: \(sortType))")
        print("Selected Order in VC: \(orderType)")
        
        if let selectedSort = selectedSort?.rawValue {
            filterViewModel.sortBy = selectedSort
        }
        if let selectedOrder = selectedOrder?.rawValue {
            filterViewModel.orderBy = selectedOrder
        }
//        filterViewModel.sortBy = selectedSort?.rawValue ?? ""
//        filterViewModel.orderBy = selectedOrder?.rawValue ?? ""
        if let genreSelectd = genres {
            filterViewModel.genreBy = genreSelectd
//            self.movies = filterMoviesByGenres(genres: selectedGenres, movieArray: movies)
//            print("Filtered Movies count: \(movies.count)")
//            print("Filtered Movies in Search VC: \(movies)")
//            self.tableView.reloadData()
        }
    }
    
    func filterMoviesByGenres(genres: Set<MovieGenre>, movieArray: [MovieListItemModel]) -> [MovieListItemModel] {
        return movieArray.filter { movie in
            let movieGenres = Set(movie.genre.compactMap { MovieGenre.fromString($0) })
            return genres.isSubset(of: movieGenres)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("print searched value: ", searchController.searchBar.text ?? "")
        filterViewModel.searchQuery = searchController.searchBar.text ?? ""
//        filterViewModel.fetchMovieListUsingQuery(movieName: searchController.searchBar.text ?? "", sortBy: selectedSort?.rawValue, orderBy: <#T##String?#>)
        
        if let sortSelected = selectedSort?.rawValue {
            filterViewModel.sortBy = sortSelected
        }
        if let orderSelected = selectedOrder?.rawValue {
            filterViewModel.orderBy = orderSelected
        }
        filterViewModel.genreBy = selectedGenres
//        movies = filterMoviesByGenres(genres: selectedGenres, movieArray: movies)
//        print("Filtered Movies count: \(movies.count)")
//        print("Filtered Movies in Search VC: \(movies)")
//        self.tableView.reloadData()
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Found \(movies.count)")
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.movieCell) as! MovieListTableViewCell
        let singleMovie = movies[indexPath.row]
        cell.setCellValue(movie: singleMovie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = filterViewModel.movieList[indexPath.row]
        let detailViewController = MovieDetailsViewController()
        detailViewController.movieId = selectedMovie.id
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
