//
//  CategoryCell.swift
//  movietime
//
//  Created by Adilet on 6/3/20.
//  Copyright © 2020 Adilet. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, MovieManagerDelegate {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var newViewController: UIViewController?
    
    var categoryMovies = [Movie]()
    var cast = [Cast]()
    
    var isCast = false
    var isRecommend = false
    var isGenre = false
    var genreId: Int?
    
    var movieId: Int?
    var cellCategory: String?
    
    var movieManager = MovieManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        movieManager.delegate = self
        
        self.collectionView.register(UINib.init(nibName: K.MoviesCells.movieCollectionCellNibName, bundle: nil), forCellWithReuseIdentifier: K.MoviesCells.movieCollectionCell)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if isCast {
            if let id = movieId {
                movieManager.fetchCast(for: id)
            }
        }
        
        if isRecommend {
            if let id = movieId {
                movieManager.fetchRecommendations(for: id)
            }
        }
        
        if isGenre {
            if let id = genreId {
                movieManager.getMovies(for: id)
            }
        }
        
        if !isCast, !isRecommend {
            if let category = cellCategory {
                movieManager.fetchCategory(for: category)
            }
        }
    }
    
    func didFetchCast(with resultCast: [Cast]) {
        cast = resultCast
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didFetchMovies(with result: [Movie]) {
        categoryMovies = result
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCast {
            return cast.count
        } else {
            return categoryMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isCast {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.MoviesCells.movieCollectionCell, for: indexPath as IndexPath) as! CollectionViewCell
            
            let actor = cast[indexPath.item]
            
            cell.titleLabel.text = actor.name
            cell.releaseDateLabel.text = actor.character
            
            if let profile = actor.profilePath {
                
                let url = URL(string: K.TheMovieDB.imageURL + profile)
                cell.posterImage.kf.setImage(with: url)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.MoviesCells.movieCollectionCell, for: indexPath as IndexPath) as! CollectionViewCell
            
            let movie = categoryMovies[indexPath.item]
            
            if let poster = movie.posterPath {
                
                let url = URL(string: K.TheMovieDB.imageURL + poster)
                cell.posterImage.kf.setImage(with: url)
            }
            
            cell.titleLabel.text = movie.title
            cell.releaseDateLabel.text = movie.getReleaseDate()
            
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isCast {
            collectionView.deselectItem(at: indexPath, animated: true)
            if let selectedId = categoryMovies[indexPath.item].id {
                let movieDetailsVC = MovieDetailsViewController()
                movieDetailsVC.movieId = selectedId
                self.newViewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
            }
        }
    }
}
