//
//  GenresViewController.swift
//  movietime
//
//  Created by Adilet on 6/1/20.
//  Copyright © 2020 Adilet. All rights reserved.
//

import UIKit

class GenresViewController: UITableViewController, MovieManagerDelegate {
    
    var movieManager = MovieManager()
    
    var genres = [(Int, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.register(UINib(nibName: K.MoviesCells.categoryCellNibName, bundle: nil), forCellReuseIdentifier: K.MoviesCells.categoryCell)
        
        movieManager.delegate = self
        
        movieManager.fetchGenres()
    }
    
    func didFetchGenres(with allGenres: [(Int, String)]) {
        genres = allGenres
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.MoviesCells.categoryCell, for: indexPath) as! CategoryCell
        
        cell.categoryLabel.text = genres[indexPath.row].1
        cell.isGenre = true
        cell.genreId = genres[indexPath.row].0
        cell.lastLabel.isHidden = true
        cell.newViewController = self
        
        cell.selectionStyle = .none

        return cell
    }
}
