//
//  MoviesViewController.swift
//  movietime
//
//  Created by Adilet on 6/1/20.
//  Copyright © 2020 Adilet. All rights reserved.
//

import UIKit
import Kingfisher

class MoviesViewController: UITableViewController, MovieManagerDelegate {
    
    var nowPlayingMovies = [Movie]()
    
    var movieManager = MovieManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.register(UINib(nibName: K.MoviesCells.categoryCellNibName, bundle: nil), forCellReuseIdentifier: K.MoviesCells.categoryCell)
        
        tableView.register(UINib(nibName: K.MoviesCells.movieCellNibName, bundle: nil), forCellReuseIdentifier: K.MoviesCells.movieCell)
        
        movieManager.delegate = self
        
        movieManager.fetchCategory(for: Query.nowPlaying.rawValue)
    }
    
    func didFetchMovies(with result: [Movie]) {
        nowPlayingMovies = result
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nowPlayingMovies.count + 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.MoviesCells.categoryCell, for: indexPath) as! CategoryCell
            
            cell.categoryLabel.text = "Popular"
            cell.cellCategory = "popular"
            cell.lastLabel.isHidden = true
            cell.newViewController = self

            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.MoviesCells.categoryCell, for: indexPath) as! CategoryCell
            
            cell.categoryLabel.text = "Coming Soon"
            cell.cellCategory = "upcoming"
            cell.newViewController = self

            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.MoviesCells.movieCell, for: indexPath) as! MovieCell
            
            let movie = nowPlayingMovies[indexPath.row - 2]
            
            cell.titleLabel.text = movie.title
            if let val = movie.rating, let poster = movie.posterPath {
                cell.ratingLabel.text = String(val)
            
                let url = URL(string: K.TheMovieDB.imageURL + poster)
                cell.posterImage.kf.setImage(with: url)
            }
            cell.releaseDateLabel.text = movie.getReleaseDate()

            return cell
        }
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row > 1 {
            let id = nowPlayingMovies[indexPath.row - 2].id
            performSegue(withIdentifier: K.Segues.movieDetailsSegue, sender: id)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? MovieDetailsViewController {
            if let sender = sender as? Int {
                vc.movieId = sender
            }
        }
        
    }

}
