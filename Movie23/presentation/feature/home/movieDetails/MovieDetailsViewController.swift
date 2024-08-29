//
//  MovieDetailsViewController.swift
//  Movie23
//
//  Created by BS00880 on 27/6/24.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var movieId: Int?
    var viewModel: MovieDetailsViewModel?
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    } ()
    
    private let contentView: UIView = {
        let cv = UIView()
        return cv
    } ()
    
    let movieImage = UIImageView()
    let movieGenre = UILabel()
    let movieTitle = UILabel()
    let mpaRating = PaddedLabel()
    let year = PaddedLabel()
    let time = PaddedLabel()
    let descriptionOfMovie = UILabel()
    let starIcon = UIImageView()
    var movieRating: Double = 0.0
    var watchListButtonPlaceHolder = UIView()
    var setRatingView = UIView()
    let castText: UILabel = {
        let label = UILabel()
        label.text = "Cast"
        return label
    }()

    var castValue: [Cast]? = nil
    let watchListViewModel = DiModule.shared.resolve(WatchListViewModel.self)!
    var alreadyInWatchList = false
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBackground
        super.viewDidLoad()
        guard let movieId = movieId else {
            return
        }
        viewModel = MovieDetailsViewModel(movieRepositoy: MovieRepositoryImpl(apiService: APIServiceImplemention(apiClient: APIClientImp())), movieId: movieId)
        
        bindViewModel()
        setUpScrollView()
//        self.watchListButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setUpScrollView() {
        self.view.addSubview(scrollView)
        scrollView.pin(to: view)
        
        self.scrollView.addSubview(contentView)
        contentView.pin(to: scrollView)
        
        let hConst = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        hConst.isActive = true
        hConst.priority = UILayoutPriority(50)
        
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        setUpUIInsideScrollView()
    }
    
    private func setUpUIInsideScrollView() {
        
        self.contentView.addSubview(movieImage)
        self.contentView.addSubview(movieTitle)
        self.contentView.addSubview(movieGenre)
        self.contentView.addSubview(mpaRating)
        self.contentView.addSubview(year)
        self.contentView.addSubview(time)
        self.contentView.addSubview(descriptionOfMovie)
        self.contentView.addSubview(starIcon)
//        self.contentView.addSubview(watchListButton)
        self.contentView.addSubview(watchListButtonPlaceHolder)
        self.contentView.addSubview(setRatingView)
        self.contentView.addSubview(castText)
        
        configureAllValues()
        
        
        
        movieGenre.pinToRightAndBottomOfSomething(height: 15, to: self.contentView, to: nil, to: movieImage)
        movieTitle.pinToRightAndBottomOfSomething(height: 20, to: self.contentView, to: nil, to: movieGenre)
        mpaRating.pinToRightAndBottomOfSomething(height: 25, to: self.contentView, to: nil, to: movieTitle)
        year.pinToRightAndBottomOfSomething(height: 25, to: self.contentView, to: mpaRating, to: movieTitle)
        time.pinToRightAndBottomOfSomething(height: 25, to: self.contentView, to: year, to: movieTitle)
        descriptionOfMovie.pinToRightAndBottomOfSomething(height: 50, to: self.contentView, to: nil, to: mpaRating)
        descriptionOfMovie.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
//        watchListButton.pinToBottomOfSomethingCenter(height: 50, to: self.contentView, to: descriptionOfMovie)
        watchListButtonPlaceHolder.pinToBottomOfSomethingCenter(height: 50, to: self.contentView, to: descriptionOfMovie)
        setRatingView.pinToBottomOfSomethingCenter(height: 80, to: self.contentView, to: watchListButtonPlaceHolder)
        castText.pinToRightAndBottomOfSomething(height: 20, to: self.contentView, to: nil, to: setRatingView)
    }
    
    private func configureAllValues() {

        configureImageView()
        setImageConstraints()
        configureTitleView()
        configureGenreView()
        smallLabelSizeFixing()
        setupRoundedCornersForLabels()
        
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.movieDetailsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.setMovie()
            }
        }
    }
    
    private func setMovie() {
        let defaultCast = [Cast.ifNoCastDataAvailable]
        setMovieValues(movie: viewModel?.movieDetails ?? MovieDetailsModel(id: 10, title: "", description: "", largeCoverImage: "", releaseYear: 2012, rating: 8.0, duration: "", mpaRating: "", genres: ["",""], descriptionFull: "", cast: defaultCast))
    }
    
    func setMovieValues(movie: MovieDetailsModel) {
        guard let moviePassToButton = viewModel?.movieDetails?.toMovieListItem() else { return  }
        let watchListButton = WatchListButton(movieItem: moviePassToButton, hasBackground: true, fontSize: .small)
        watchListButtonPlaceHolder.addSubview(watchListButton)
        watchListButton.pin(to: watchListButtonPlaceHolder)
        movieImage.setImage(with: movie.largeCoverImage)
        var genreList = genresString(from: movie.genres)
        movieGenre.text = genreList
        movieTitle.text = movie.title
        mpaRating.text = movie.mpaRating == "" ? "N/A" : movie.mpaRating
        year.text = "\(movie.releaseYear)"
        time.text = movie.duration == "" ? "N/A" : movie.duration
        movieRating = movie.rating
        descriptionOfMovie.text = movie.descriptionFull == "" ? "N/A" : movie.descriptionFull
        castValue = movie.cast
        print("Movie rating: \(movie.rating)")
        movieRating = movie.rating
        
        setUpRatingView(movieRatingValue: movieRating).pin(to: setRatingView)

        print("The casts are: \(castValue)")
        setUpCastView(cast: castValue)
    }
    
    func configureImageView() {
        movieImage.layer.cornerRadius = 10
        movieImage.clipsToBounds = true
    }
    
    func configureGenreView() {
        movieGenre.numberOfLines = 0
        movieGenre.lineBreakMode = .byWordWrapping
    }
    
    func configureTitleView() {
        movieTitle.numberOfLines = 0
        movieTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    func smallLabelSizeFixing(){
        year.font = UIFont.systemFont(ofSize: 12)
        time.font = UIFont.systemFont(ofSize: 12)
        mpaRating.font = UIFont.systemFont(ofSize: 12)
        movieGenre.font = UIFont.systemFont(ofSize: 12)
        descriptionOfMovie.font = UIFont.systemFont(ofSize: 12)
    }
    
    func setImageConstraints() {
        movieImage.translatesAutoresizingMaskIntoConstraints = false
        movieImage.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        movieImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        movieImage.heightAnchor.constraint(equalTo: movieImage.widthAnchor, multiplier: 1.3).isActive = true
        movieImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.75).isActive = true
    }
    
    func watchListButtonAlignment() {
        watchListButtonPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        watchListButtonPlaceHolder.topAnchor.constraint(equalTo: descriptionOfMovie.bottomAnchor, constant: 10).isActive = true
        watchListButtonPlaceHolder.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        watchListButtonPlaceHolder.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    
    private func setUpRatingView(movieRatingValue: Double) -> UIView {
        let fullView = UIView()
        fullView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fullView)
        
        var firstRatingView = setUpSingleRatingView(to: fullView, header: LocalizedStringKey.overallRating.localized() /*"Overall Rating"*/, ratingValue: movieRatingValue)
        var secondRatingView = setUpSingleRatingView(to: fullView, header: LocalizedStringKey.yourRating.localized() /*"Your Rating"*/, ratingValue: 0.0)
        firstRatingView.leadingAnchor.constraint(equalTo: fullView.leadingAnchor).isActive = true
        secondRatingView.trailingAnchor.constraint(equalTo: fullView.trailingAnchor, constant: 5).isActive = true
        
        return fullView
    }
    
    private func setUpSingleRatingView(to superview: UIView, header: String, ratingValue: Double) -> UIView {
        let ratingView = UIView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(ratingView)
        
        let headingLabel = UILabel()
        headingLabel.text = String(header)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingView.addSubview(headingLabel)
        
        let ratingLabel = UILabel()
        ratingLabel.text = String(ratingValue)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingView.addSubview(ratingLabel)
        
        let starView = setTheStars(to: ratingView, ratingValue: ratingValue)
        ratingView.addSubview(starView)

        headingLabel.topAnchor.constraint(equalTo: ratingView.topAnchor).isActive = true
        headingLabel.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor).isActive = true
        ratingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10).isActive = true
        ratingLabel.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor).isActive = true
        starView.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor).isActive = true
        starView.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor).isActive = true
        
        ratingView.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.5).isActive = true
        
        return ratingView
    }
    
    private func setTheStars(to superview: UIView, ratingValue: Double) -> UIView {
        let starView = UIView()
        starView.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(starView)
        
        let starStackView = UIStackView()
        starStackView.axis = .horizontal
        starStackView.distribution = .fillEqually
        starStackView.spacing = 0.5
        
        let filledStarImage = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
        let emptyStarImage = UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate)
        let halfStarImage = UIImage(systemName: "star.leadinghalf.filled")?.withRenderingMode(.alwaysTemplate)
        
        let filledStarCount = Int(ratingValue/2)
        let halfStar = ratingValue.truncatingRemainder(dividingBy: 2) >= 1
        
        for index in 0..<5 {
            var imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            
            if index < filledStarCount {
                imageView.image = filledStarImage
            } else if index == filledStarCount && halfStar {
                imageView.image = halfStarImage
            } else {
                imageView.image = emptyStarImage
            }
            starStackView.addArrangedSubview(imageView)
        }
        starView.addSubview(starStackView)
        starStackView.pin(to: starView)
        
        starView.widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
        return starView
    }
    

    
    private func setUpCastView(cast: [Cast]?) {
        
        let scrollCastView: UIScrollView = {
            let scrollCastView = UIScrollView()
            scrollCastView.showsVerticalScrollIndicator = false
            return scrollCastView
        } ()
        
        let stackCastview: UIStackView = {
            let stackCastView = UIStackView()
            stackCastView.axis = .horizontal
            stackCastView.distribution = .equalSpacing
            stackCastView.spacing = 10
            return stackCastView
        } ()
        
        contentView.addSubview(scrollCastView)
        scrollCastView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollCastView.topAnchor.constraint(equalTo: castText.bottomAnchor, constant: 10),
            scrollCastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            scrollCastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollCastView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        scrollCastView.addSubview(stackCastview)
        stackCastview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackCastview.topAnchor.constraint(equalTo: scrollCastView.topAnchor),
            stackCastview.leadingAnchor.constraint(equalTo: scrollCastView.leadingAnchor),
            stackCastview.trailingAnchor.constraint(equalTo: scrollCastView.trailingAnchor),
            stackCastview.bottomAnchor.constraint(equalTo: scrollCastView.bottomAnchor),
            stackCastview.heightAnchor.constraint(equalTo: scrollCastView.heightAnchor)
        ])
        if let cast = cast {
            for castMember in cast {
                var singleCastView = UIView()
                singleCastView = setUpSingleCast(cast: castMember)
                stackCastview.addArrangedSubview(singleCastView)
            }
        } else {
            var singleCastView = UIView()
            singleCastView = setUpSingleCast(cast: Cast.ifNoCastDataAvailable)
            stackCastview.addArrangedSubview(singleCastView)
        }
        
       
        scrollCastView.pinToRightAndBottomOfSomething(height: 180, to: contentView, to: nil, to: castText)
        scrollCastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setUpSingleCast(cast: Cast) -> UIView {
        let fullView = UIView()
        fullView.translatesAutoresizingMaskIntoConstraints = false
//        superview.addSubview(fullView)
        
        let castImage = UIImageView()
        castImage.translatesAutoresizingMaskIntoConstraints = false
        castImage.contentMode = .scaleAspectFit
        castImage.translatesAutoresizingMaskIntoConstraints = false
        castImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        castImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        if let urlString = cast.urlSmallImage {
            castImage.setImage(with: urlString)
        } else {
            castImage.image = UIImage(named: "cast_dummy_img")
        }
        fullView.addSubview(castImage)
        
        let nameLabel = UILabel()
        nameLabel.text = String(cast.name)
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullView.addSubview(nameLabel)
        
        let characterNameLabel = UILabel()
        characterNameLabel.text = String(cast.characterName)
        characterNameLabel.numberOfLines = 1
        characterNameLabel.lineBreakMode = .byTruncatingTail
        characterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullView.addSubview(characterNameLabel)
        
        

        castImage.topAnchor.constraint(equalTo: fullView.topAnchor).isActive = true
        castImage.leadingAnchor.constraint(equalTo: fullView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: castImage.bottomAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: fullView.leadingAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        characterNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        characterNameLabel.leadingAnchor.constraint(equalTo: fullView.leadingAnchor).isActive = true
        characterNameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        fullView.widthAnchor.constraint(equalTo: castImage.widthAnchor).isActive = true
        
        return fullView
    }
    
    private func genresString(from genres: [String]) -> String {
        genres.joined(separator: " • ")
    }
    private func setupRoundedCornersForLabels() {
        view.setupRoundedCorners(for: year)
        view.setupRoundedCorners(for: time)
        view.setupRoundedCorners(for: mpaRating)
    }
}
