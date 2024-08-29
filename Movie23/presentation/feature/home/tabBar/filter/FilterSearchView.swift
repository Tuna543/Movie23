//
//  FilterSearchView.swift
//  Movie23
//
//  Created by BS00880 on 5/7/24.
//

import UIKit

class FilterSearchView: UIView {

    var movieName: String = ""
    var applyFilters: ((Set<MovieGenre>, SortBy?, OrderBy?) -> Void)?
    
    private var selectedGenres: Set<MovieGenre> = [] {
        didSet {
            updateGenreButtonSelection()
        }
    }

//    private var selectedGenres: Set<MovieGenre> = []
    private var selectedSort: SortBy? = nil
    private var selectedOrder: OrderBy? = nil
    private var holdSort: String = ""
    private var holdOrder: String = ""
    private var holdGenre: String = ""

    private let titleLabel = UILabel()
    private let sortByLabel = UILabel()
    private let genresLabel = UILabel()
    private let orderByLabel = UILabel()

    private let sortStackView = UIStackView()
    private let genresStackView = UIStackView()
    private let orderStackView = UIStackView()
    private let applyButton = CustomButton(title: "Apply", hasBackground: true, fontSize: .medium)

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .primary
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.text = "Sort and Filter"
        titleLabel.textColor = UIColor(named: "primaryColor")
        
        sortByLabel.font = .boldSystemFont(ofSize: 18)
        sortByLabel.text = "Sort By"
        
        genresLabel.font = .boldSystemFont(ofSize: 18)
        genresLabel.text = "Genres"
        
        orderByLabel.font = .boldSystemFont(ofSize: 18)
        orderByLabel.text = "Order By"

        sortStackView.axis = .horizontal
        sortStackView.distribution = .fillEqually
        sortStackView.spacing = 8

        genresStackView.axis = .vertical
        genresStackView.spacing = 8

        orderStackView.axis = .horizontal
        orderStackView.distribution = .fillEqually
        orderStackView.spacing = 8

        setupSortButtons()
        setupGenreButtons()
        setupOrderButtons()

        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)

        addSubview(titleLabel)
        addSubview(sortByLabel)
        addSubview(sortStackView)
        addSubview(genresLabel)
        addSubview(genresStackView)
        addSubview(orderByLabel)
        addSubview(orderStackView)
        addSubview(applyButton)
    }

    private func setupSortButtons() {
        for sortBy in SortBy.allCases {
            let button = UIButton()
            button.setTitle(sortBy.rawValue, for: .normal)
            button.setTitleColor(.darkText, for: .normal)
            button.layer.borderColor = CGColor(gray: 0.5, alpha: 1)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
            sortStackView.addArrangedSubview(button)
        }
    }

    private func setupGenreButtons() {
        let genreButtons = MovieGenre.allCases.map { genre -> UIButton in
            let button = UIButton()
            button.setTitle(genre.rawValue, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderColor = CGColor(gray: 0.5, alpha: 1)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(genreButtonTapped(_:)), for: .touchUpInside)
            return button
        }

        let rows = stride(from: 0, to: genreButtons.count, by: 4).map {
            Array(genreButtons[$0..<min($0 + 4, genreButtons.count)])
        }

        for row in rows {
            let stackView = UIStackView(arrangedSubviews: row)
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            genresStackView.addArrangedSubview(stackView)
        }
        updateGenreButtonSelection() // Initial setup
    }

    private func setupOrderButtons() {
        for orderBy in OrderBy.allCases {
            let button = UIButton()
            button.setTitle(orderBy.rawValue, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderColor = CGColor(gray: 0.5, alpha: 1)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(orderButtonTapped(_:)), for: .touchUpInside)
            orderStackView.addArrangedSubview(button)
        }
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        sortByLabel.translatesAutoresizingMaskIntoConstraints = false
        sortStackView.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        genresStackView.translatesAutoresizingMaskIntoConstraints = false
        orderByLabel.translatesAutoresizingMaskIntoConstraints = false
        orderStackView.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            sortByLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            sortByLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            sortStackView.topAnchor.constraint(equalTo: sortByLabel.bottomAnchor, constant: 8),
            sortStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sortStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            genresLabel.topAnchor.constraint(equalTo: sortStackView.bottomAnchor, constant: 16),
            genresLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            genresStackView.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 8),
            genresStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            genresStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            orderByLabel.topAnchor.constraint(equalTo: genresStackView.bottomAnchor, constant: 16),
            orderByLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            orderStackView.topAnchor.constraint(equalTo: orderByLabel.bottomAnchor, constant: 8),
            orderStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            orderStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            applyButton.topAnchor.constraint(equalTo: orderStackView.bottomAnchor, constant: 16),
            applyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            applyButton.widthAnchor.constraint(equalToConstant: 200),
            applyButton.heightAnchor.constraint(equalToConstant: 44),
            applyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    @objc private func sortButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal), let sortBy = SortBy(rawValue: title) else { return }
        selectedSort = sortBy
        print("Seleted Sort: \(selectedSort)")
        updateButtonSelection(sender, in: sortStackView)
    }

    @objc private func genreButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal), let genre = MovieGenre(rawValue: title) else { return }
        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
        } else {
            selectedGenres.insert(genre)
        }
        print("Selected Genres \(selectedGenres)")
//        updateButtonSelection(sender, in: genresStackView)
    }
    
    private func updateGenreButtonSelection() {
        for case let stack as UIStackView in genresStackView.arrangedSubviews {
            for case let button as UIButton in stack.arrangedSubviews {
                let genre = MovieGenre(rawValue: button.title(for: .normal) ?? "") ?? MovieGenre.unknown
                let isSelected = selectedGenres.contains(genre)
                button.layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.black.cgColor
                button.setTitleColor(isSelected ? .blue : .black, for: .normal)
            }
        }
    }

    @objc private func orderButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal), let orderBy = OrderBy(rawValue: title) else { return }
        selectedOrder = orderBy
        print("Selected Order: \(selectedOrder)")
        updateButtonSelection(sender, in: orderStackView)
    }

    @objc private func applyButtonTapped() {
        // Add your filtering logic here
        print("Apply button tapped")
        applyFilters?(selectedGenres, selectedSort, selectedOrder)
    }

    private func updateButtonSelection(_ sender: UIButton, in stackView: UIStackView) {
        for case let button as UIButton in stackView.arrangedSubviews {
            let genre = MovieGenre(rawValue: button.title(for: .normal) ?? "")
            button.layer.borderColor = (button == sender ? UIColor.blue.cgColor : UIColor.black.cgColor)
            button.setTitleColor(button == sender ? .blue : .black, for: .normal)
        }
    }
}
