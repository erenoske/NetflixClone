//
//  Cast.swift
//  Netflix Clone
//
//  Created by eren on 6.04.2024.
//

import Foundation

struct CastResponse: Codable {
    let cast: [Cast]
}

struct Cast: Codable {
    let name: String?
    let profilePath: String?
    let character: String?
}
