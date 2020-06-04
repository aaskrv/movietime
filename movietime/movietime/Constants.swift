//
//  Constants.swift
//  movietime
//
//  Created by Adilet on 6/2/20.
//  Copyright © 2020 Adilet. All rights reserved.
//

import Foundation

struct K {
    
    struct TheMovieDB {
        static let apiKey = "?api_key=02da584cad2ae31b564d940582770598&language=en-US"
        static let baseURL = "https://api.themoviedb.org/3"
        static let imageURL = "https://image.tmdb.org/t/p/w500"
    }
    
    struct Segues {
        static let movieFromGenreSegue = "movieDetailsFromGenres"
        static let movieDetailsSegue = "movieDetails"
        static let movieFromSearch = "movieFromSearch"
    }
    
    struct DetailsCells {
        static let movieDetailsCell = "movieDetailsCell"
        static let movieDetailsCellNibName = "MovieDetailsCell"
    }
    
    struct MoviesCells {
        static let categoryCell = "categoryCell"
        static let categoryCellNibName = "CategoryCell"
        
        static let movieCollectionCell = "movieCollectionCell"
        static let movieCollectionCellNibName = "CollectionViewCell"
        
        static let movieCell = "movieCell"
        static let movieCellNibName = "MovieCell"
    }
    
}

enum Query: String {
    case movie = "/movie"
    case nowPlaying = "now_playing"
    case credits = "/credits"
    case recommend = "/recommendations"
    case search = "/search/movie"
    case query = "&query="
    case genres = "/genre/movie/list"
    case discover = "/discover/movie"
    case withGenres = "&with_genres="
}
