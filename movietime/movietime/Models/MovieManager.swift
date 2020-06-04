//
//  MovieManager.swift
//  movietime
//
//  Created by Adilet on 6/3/20.
//  Copyright © 2020 Adilet. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol MovieManagerDelegate {
    func didFetchMovies(with result: [Movie])
    func didFetchCast(with resultCast: [Cast])
    func didFetchMovieDetails(with resultDetails: Movie)
    func didFetchGenres(with allGenres: [(Int, String)])
}

struct MovieManager {
    
    let movieBaseUrl = K.TheMovieDB.baseURL + Query.movie.rawValue
    
    var delegate: MovieManagerDelegate?
    
    // MARK: - Fetch Movie Details
    
    func fetchMovie(with movieId: Int) {
        
        let requestUrl = movieBaseUrl + "/\(movieId)" + K.TheMovieDB.apiKey
        
        AF.request(requestUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var movie = Movie()
                
                var genres = [String]()
                
                for genre in json["genres"].arrayValue {
                    genres.append(genre["name"].stringValue)
                }
                
                let title = json["title"].stringValue
                let rating = json["vote_average"].doubleValue
                let releaseDate = json["release_date"].stringValue
                
                let posterPath = json["poster_path"].string
                let backdropPath = json["backdrop_path"].string
                let budget = json["budget"].intValue
                let revenue = json["revenue"].intValue
                let duration = json["runtime"].intValue
                let description = json["overview"].stringValue
                
                let movieDetails = Movie(title: title, posterPath: posterPath, backdropPath: backdropPath, rating: rating, duration: duration, genres: genres, releaseDate: releaseDate, budget: budget, revenue: revenue, description: description)
                
                movie = movieDetails
                
                self.delegate?.didFetchMovieDetails(with: movie)
                
            case .failure(let error):
                print("Error requesting movie details, \(error)")
            }
        }
    }

    
    // MARK: - Fetching for Categories
    // Fetch Movies for Chosen Category (Popular or Upcoming)
    func fetchCategory(for category: String) {
        
        let requestUrl = movieBaseUrl + "/\(category)" + K.TheMovieDB.apiKey
        
        AF.request(requestUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var movies = [Movie]()
                
                for item in json["results"].arrayValue {
                    
                    let title = item["title"].stringValue
                    let id = item["id"].intValue
                    let rating = item["vote_average"].doubleValue
                    let releaseDate = item["release_date"].stringValue
                    
                    let posterPath = item["poster_path"].string
                        
                    let movie = Movie(id: id, title: title, posterPath: posterPath, rating: rating, releaseDate: releaseDate)
                    
                    movies.append(movie)
                }
                
                self.delegate?.didFetchMovies(with: movies)
                
            case .failure(let error):
                print("Error requesting category movies, \(error)")
            }
            
        }
    }
    
    
    // MARK: - Fetching for Cast
    func fetchCast(for movieId: Int) {
        
        let requestUrl = movieBaseUrl + "/\(movieId)" + Query.credits.rawValue + K.TheMovieDB.apiKey
        
        AF.request(requestUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var movieCast = [Cast]()
                
                for actor in json["cast"].arrayValue {
                    
                    let name = actor["name"].stringValue
                    let profilePath = actor["profile_path"].string
                    let character = actor["character"].string
                    
                    movieCast.append(Cast(name: name, profilePath: profilePath, character: character))
                }
                
                self.delegate?.didFetchCast(with: movieCast)
                
            case .failure(let error):
                print("Error requesting movie cast, \(error)")
            }
        }
    }
    
    // MARK: - Search
    
    func searchMovie(with query: String) {
        
        let replacedQuery = query.replacingOccurrences(of: " ", with: "%20")
        
        let requestUrl = K.TheMovieDB.baseURL + Query.search.rawValue + K.TheMovieDB.apiKey + Query.query.rawValue + replacedQuery
        
        AF.request(requestUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var results = [Movie]()
                
                for item in json["results"].arrayValue {
                    
                    let title = item["title"].stringValue
                    let id = item["id"].intValue
                    let rating = item["vote_average"].doubleValue
                    let releaseDate = item["release_date"].stringValue
                    
                    let posterPath = item["poster_path"].string
                        
                    let movie = Movie(id: id, title: title, posterPath: posterPath, rating: rating, releaseDate: releaseDate)
                    results.append(movie)
                    
                }
                
                self.delegate?.didFetchMovies(with: results)
                
            case .failure(let error):
                print("Error requesting search results for query = \(query), \(error)")
            }
            
        }
    }
    
    // MARK: - Recommend
    
    func fetchRecommendations(for movieId: Int) {
        
        let requestUrl = movieBaseUrl + "/\(movieId)" + Query.recommend.rawValue + K.TheMovieDB.apiKey
        
        AF.request(requestUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var recommended = [Movie]()
                
                for item in json["results"].arrayValue {
                    
                    let title = item["title"].stringValue
                    let id = item["id"].intValue
                    let rating = item["vote_average"].doubleValue
                    let releaseDate = item["release_date"].stringValue
                    
                    let posterPath = item["poster_path"].string
                        
                    let movie = Movie(id: id, title: title, posterPath: posterPath, rating: rating, releaseDate: releaseDate)
                    recommended.append(movie)
                }
                
                self.delegate?.didFetchMovies(with: recommended)
                
            case .failure(let error):
                print("Error requesting recommended movies, \(error)")
            }
            
        }
    }
    
    // MARK: - Genres
    
    func fetchGenres() {
        
        let requestUrl = K.TheMovieDB.baseURL + Query.genres.rawValue + K.TheMovieDB.apiKey
        
        AF.request(requestUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var allGenres = [(Int, String)]()
                
                for item in json["genres"].arrayValue {
                    allGenres.append((item["id"].intValue, item["name"].stringValue))
                }
                
                self.delegate?.didFetchGenres(with: allGenres)
                
            case .failure(let error):
                print("Error requesting genres, \(error)")
            }
        }
    }
    
    func getMovies(for genreId: Int) {
        
        let requestUrl = K.TheMovieDB.baseURL + Query.discover.rawValue + K.TheMovieDB.apiKey + Query.withGenres.rawValue + "\(genreId)"
        
        AF.request(requestUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var moviesForGenre = [Movie]()
                
                for item in json["results"].arrayValue {
                    
                    let title = item["title"].stringValue
                    let id = item["id"].intValue
                    let rating = item["vote_average"].doubleValue
                    let releaseDate = item["release_date"].stringValue
                    
                    let posterPath = item["poster_path"].string
                        
                    let movie = Movie(id: id, title: title, posterPath: posterPath, rating: rating, releaseDate: releaseDate)
                    moviesForGenre.append(movie)
                }
                
                self.delegate?.didFetchMovies(with: moviesForGenre)
                
            case .failure(let error):
                print("Error requesting getting movies for genre \(genreId), \(error)")
            }
        }
    }
}

extension MovieManagerDelegate {
    func didFetchMovies(with result: [Movie]) {}
    func didFetchCast(with resultCast: [Cast]) {}
    func didFetchMovieDetails(with resultDetails: Movie) {}
    func didFetchGenres(with allGenres: [(Int, String)]) {}
}

