//
//  Movie.swift
//  Coding Challenge 3
//
//  Created by Gabriel Blaine Palmer on 5/20/19.
//  Copyright © 2019 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let title: String
    let year: String
    let imageURL: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imageURL = "Poster"
        case id = "imdbID"
    }
    
}

// intermediate struct used to unwrap the outer layer of json automatically
struct DecodedMovieArray: Decodable {
    let Search: [Movie]
}
