//
//  MoviesController.swift
//  Coding Challenge 3
//
//  Created by Gabriel Blaine Palmer on 5/20/19.
//  Copyright © 2019 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation

//episode type doesn't seem to work
enum MediaType {
    case movie
    case series
    case episode
    case game
}

class MoviesController {
    static let shared = MoviesController()
    
    var favorites: [Movie] = []
    
    fileprivate let baseURL = URL(string: "http://www.omdbapi.com/")!
    fileprivate var favoritesArchiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("favorites").appendingPathExtension("plist")
    }
    
    func fetchMedia(searchTerm: String, type: MediaType, completion: @escaping ([Movie]) -> Void) {
        DispatchQueue.global().async {
            
            let searchType: String
            switch type {
            case .movie:
                searchType = "movie"
            case .series:
                searchType = "series"
            case .episode:
                searchType = "episode"
            case .game:
                searchType = "game"
            }
            
            var queries: Dictionary<String, String> = [
                "apikey" : "c33320f0",
                "r" : "json",
                "type" : searchType,
                "s" : searchTerm,
                "page" : "1"
            ]
            
            var movies: [Movie] = []
            let group = DispatchGroup()
            
            for index in 1...3 {
                group.enter()
                queries["page"] = String(index)
                
                guard let searchURL = self.baseURL.withQueries(queries) else {
                    group.leave()
                    break
                }
                
                NetworkController.fetchData(from: searchURL) { (data) in
                    if let data = data {
                        let decoder = JSONDecoder()
                        
                        do {
                            let decodedMovies = try decoder.decode(DecodedMovieArray.self, from: data).Search
                            movies += decodedMovies
                        } catch {
                            print("unable to decode json data")
                        }
                    }
                    
                    group.leave()
                }
            }
            
            group.wait()
            completion(movies)
        }
    }
    
    func loadFavoriteMovies() {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedMoviesData = try? Data(contentsOf: favoritesArchiveURL),
            let decodedmovies = try? propertyListDecoder.decode(Array<Movie>.self, from: retrievedMoviesData) {
            
            favorites = decodedmovies
        } else {
            print("Could not load favorites data")
        }
    }
    
    func saveFavoriteMovies() {
        do {
            let propertyListEncoder = PropertyListEncoder()
            let encodedSets = try propertyListEncoder.encode(favorites)
            try encodedSets.write(to: favoritesArchiveURL, options: .noFileProtection)
            print("updated favorites")
        } catch {
            print("failed to save favorites")
            print(error)
        }
    }
    
}


