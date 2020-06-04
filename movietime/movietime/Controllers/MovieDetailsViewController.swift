//
//  MovieDetailsViewController.swift
//  movietime
//
//  Created by Adilet on 6/2/20.
//  Copyright © 2020 Adilet. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UITableViewController, MovieManagerDelegate {
    
    var movieId: Int?
    var movie: Movie?
    
    var movieManager = MovieManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.DetailsCells.movieDetailsCellNibName, bundle: nil), forCellReuseIdentifier: K.DetailsCells.movieDetailsCell)
        
        tableView.register(UINib(nibName: K.MoviesCells.categoryCellNibName, bundle: nil), forCellReuseIdentifier: K.MoviesCells.categoryCell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        movieManager.delegate = self
        
        if let id = movieId {
            movieManager.fetchMovie(with: id)
        }
        
        self.navigationController?.navigationBar.tintColor = .black
    }

    func didFetchMovieDetails(with resultDetails: Movie) {
        movie = resultDetails
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.DetailsCells.movieDetailsCell, for: indexPath) as! MovieDetailsCell
            
            cell.titleLabel.text = movie?.title
            cell.genresLabel.text = movie?.getGenresList()
            
            if let val = movie?.rating, let poster = movie?.posterPath, let backdrop = movie?.backdropPath {
                cell.ratingLabel.text = String(val)
            
                let urlPoster = URL(string: K.TheMovieDB.imageURL + poster)
                cell.posterImage.kf.setImage(with: urlPoster)
                let urlBack = URL(string: K.TheMovieDB.imageURL + backdrop)
                cell.backdropImage.kf.setImage(with: urlBack)
            }
            
            cell.durationLabel.text = movie?.durationString
            cell.budgetLabel.text = movie?.getMoney()[0]
            cell.revenueLabel.text = movie?.getMoney()[1]
            
            cell.releaseDateLabel.text = movie?.getReleaseDate()
            cell.overviewText.text = movie?.description

            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.MoviesCells.categoryCell, for: indexPath) as! CategoryCell
            
            cell.categoryLabel.text = "Cast"
            cell.lastLabel.isHidden = true
            cell.isCast = true
            cell.movieId = movieId

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.MoviesCells.categoryCell, for: indexPath) as! CategoryCell
            
            cell.categoryLabel.text = "Recommended"
            cell.lastLabel.isHidden = true
            cell.isRecommend = true
            cell.movieId = movieId
            cell.newViewController = self

            return cell
        }
    }
}
