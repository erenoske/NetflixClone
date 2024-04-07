//
//  GenreUtility.swift
//  Netflix Clone
//
//  Created by eren on 7.04.2024.
//

import Foundation

struct Genre {
    let name: String
    let id: Int
}

struct GenreConverter {
    static let genres: [Genre] = [
        Genre(name: "Action", id: 28),
        Genre(name: "Adventure", id: 12),
        Genre(name: "Animation", id: 16),
        Genre(name: "Comedy", id: 35),
        Genre(name: "Crime", id: 80),
        Genre(name: "Documentary", id: 99),
        Genre(name: "Drama", id: 18),
        Genre(name: "Family", id: 10751),
        Genre(name: "Fantasy", id: 14),
        Genre(name: "History", id: 36),
        Genre(name: "Horror", id: 27),
        Genre(name: "Music", id: 10402),
        Genre(name: "Mystery", id: 9648),
        Genre(name: "Romance", id: 10749),
        Genre(name: "Science Fiction", id: 878),
        Genre(name: "TV Movie", id: 10770),
        Genre(name: "Thriller", id: 53),
        Genre(name: "War", id: 10752),
        Genre(name: "Western", id: 37)
    ]
    
    static func convertToGenreNames(genreIds: [Int]) -> [String] {
        var genreNames: [String] = []
        
        for id in genreIds {
            if let genre = genres.first(where: { $0.id == id }) {
                genreNames.append(genre.name)
            }
        }
        
        return genreNames
    }
}
