//
//  SearchViewController.swift
//  movietime
//
//  Created by Adilet on 6/2/20.
//  Copyright © 2020 Adilet. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, MovieManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var results = [Movie]()
    
    var movieManager = MovieManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieManager.delegate = self
        searchBar.delegate = self
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(UINib(nibName: K.MoviesCells.movieCellNibName, bundle: nil), forCellReuseIdentifier: K.MoviesCells.movieCell)
    }

    func didFetchMovies(with result: [Movie]) {
        results = result
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.MoviesCells.movieCell, for: indexPath) as! MovieCell
        
        let movie = results[indexPath.row]
        
        cell.titleLabel.text = movie.title
        
        if let val = movie.rating, let poster = movie.posterPath {
            cell.ratingLabel.text = String(val)
        
            let url = URL(string: K.TheMovieDB.imageURL + poster)
            cell.posterImage.kf.setImage(with: url)
        }
        
        cell.releaseDateLabel.text = movie.releaseDate

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let id = results[indexPath.row].id
        performSegue(withIdentifier: K.Segues.movieFromSearch, sender: id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MovieDetailsViewController {
            if let sender = sender as? Int {
                vc.movieId = sender
            }
        }
        
    }
    
    // MARK: - SearchBar Delegate Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        
        if let searchText = searchBar.text {
            movieManager.searchMovie(with: searchText)
        }
        
        searchBar.text = ""
    }
}
