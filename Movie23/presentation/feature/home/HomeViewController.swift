//
//  HomeViewController.swift
//  Movie23
//
//  Created by BS00880 on 24/6/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    let authenticationManager = DiModule.shared.resolve(AuthenticationManager.self)!
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    } ()
    
    private let contentView: UIView = {
        let cv = UIView()
        return cv
    } ()

    let noUser = "No user name found"
    var headerView = HeaderView(title: LocalizedStringKey.welcome.localized(), subTitle: "No user name found")
    private let topMoviePicksText = HeaderView(title: LocalizedStringKey.topMoviePicks.localized())
    private let upComingMoviePicksText = HeaderView(title: LocalizedStringKey.upcomingMovies.localized())
    private let seeAllButtonWithTopMovie = CustomButton(title: LocalizedStringKey.seeAll.localized(), fontSize: .small, titleColor: UIColor(named: "primaryColor"))
    private let seeAllButtonWithUpcomingMovie = CustomButton(title: LocalizedStringKey.seeAll.localized(), fontSize: .small, titleColor: UIColor(named: "primaryColor"))
    let movieSlideListPlaceholder = UIView()
    let movieListPlaceholderTopMovie = UIView()
    let movieListPlaceholderUpcomingMovie = UIView()
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = HeaderView(title: LocalizedStringKey.welcome.localized(), subTitle: authenticationManager.currentUser?.userName)
        self.setUpUI()
        self.setupMovieSlideListViewController(to: movieSlideListPlaceholder)
        self.setupMovieListViewController(to: movieListPlaceholderTopMovie)
        self.setupMovieListViewController(to: movieListPlaceholderUpcomingMovie)
        self.seeAllButtonWithTopMovie.addTarget(self, action: #selector(didTapSeeAll), for: .touchUpInside)
        self.seeAllButtonWithUpcomingMovie.addTarget(self, action: #selector(didTapSeeAll), for: .touchUpInside)
        
    }

    private func setUpUI(){
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let hConst = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        hConst.isActive = true
        hConst.priority = UILayoutPriority(50)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor/*, constant: 10*/),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor/*, constant: -10*/),
            contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor/*, constant: -20*/),
        ])
        
        self.contentView.addSubview(headerView)
        self.contentView.addSubview(movieSlideListPlaceholder)
        self.contentView.addSubview(topMoviePicksText)
        self.contentView.addSubview(upComingMoviePicksText)
        self.contentView.addSubview(seeAllButtonWithTopMovie)
        self.contentView.addSubview(seeAllButtonWithUpcomingMovie)
        self.contentView.addSubview(movieListPlaceholderTopMovie)
        self.contentView.addSubview(movieListPlaceholderUpcomingMovie)
        
        movieSlideListPlaceholder.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        movieSlideListPlaceholder.heightAnchor.constraint(equalToConstant: 230).isActive = true
        movieListPlaceholderTopMovie.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        movieListPlaceholderTopMovie.heightAnchor.constraint(equalToConstant: 230).isActive = true
        movieListPlaceholderUpcomingMovie.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        movieListPlaceholderUpcomingMovie.heightAnchor.constraint(equalToConstant: 230).isActive = true
//        movieListPlaceholderUpcomingMovie.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

        
        headerView.pinToRightAndBottomOfSomething(height: 65, to: contentView, to: nil, to: nil, topPlace: true)
        movieSlideListPlaceholder.pinToRightAndBottomOfSomething(height: nil, to: contentView, to: nil, to: headerView)
        movieSlideListPlaceholder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true //for overcoming the leading gap defined in the function
        topMoviePicksText.pinToRightAndBottomOfSomething(height: 35, to: contentView, to: nil, to: movieSlideListPlaceholder)
//        movieListPlaceholderTopMovie.heightAnchor.constraint(equalToConstant: 150).isActive = true
        movieListPlaceholderTopMovie.pinToRightAndBottomOfSomething(height: nil, to: contentView, to: nil, to: topMoviePicksText)
        
        upComingMoviePicksText.pinToRightAndBottomOfSomething(height: 35, to: contentView, to: nil, to: movieListPlaceholderTopMovie)
        movieListPlaceholderUpcomingMovie.pinToRightAndBottomOfSomething(to: contentView, to: nil, to: upComingMoviePicksText)
        seeAllButtonWithTopMovie.pinButtonToBottomOfSomethingTrailing(to: contentView, to: topMoviePicksText)
        seeAllButtonWithUpcomingMovie.pinButtonToBottomOfSomethingTrailing(to: contentView, to: upComingMoviePicksText)
    }
    
    private func setupMovieListViewController(to placeholder: UIView) {
        let movieListVC = TopMovieViewController()
        
        self.addChild(movieListVC)
        placeholder.addSubview(movieListVC.view)
        movieListVC.didMove(toParent: self)
        
        movieListVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieListVC.view.topAnchor.constraint(equalTo: placeholder.topAnchor),
            movieListVC.view.leadingAnchor.constraint(equalTo: placeholder.leadingAnchor),
            movieListVC.view.trailingAnchor.constraint(equalTo: placeholder.trailingAnchor),
            movieListVC.view.bottomAnchor.constraint(equalTo: placeholder.bottomAnchor)
        ])
    }
    
    private func setupMovieSlideListViewController(to placeholder: UIView) {
        let movieListVC = SlideShowViewController()
        
        self.addChild(movieListVC)
        placeholder.addSubview(movieListVC.view)
        movieListVC.didMove(toParent: self)
        
        movieListVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieListVC.view.topAnchor.constraint(equalTo: placeholder.topAnchor),
            movieListVC.view.leadingAnchor.constraint(equalTo: placeholder.leadingAnchor),
            movieListVC.view.trailingAnchor.constraint(equalTo: placeholder.trailingAnchor),
            movieListVC.view.bottomAnchor.constraint(equalTo: placeholder.bottomAnchor)
        ])
    }
    
    @objc private func didTapSeeAll() {
        let vc = MovieListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
