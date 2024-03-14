//
//  Extensions.swift
//  Netflix Clone
//
//  Created by eren on 6.03.2024.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
