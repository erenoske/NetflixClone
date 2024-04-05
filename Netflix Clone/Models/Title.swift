//
//  Movie.swift
//  Netflix Clone
//
//  Created by eren on 6.03.2024.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let mediaType: String?
    let originalName: String?
    let originalTitle: String?
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let overview: String?
    let voteCount: Int
    let releaseDate: String?
    let voteAverage: Double
}
