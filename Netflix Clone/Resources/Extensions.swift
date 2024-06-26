//
//  Extensions.swift
//  Netflix Clone
//
//  Created by eren on 6.03.2024.
//

import Foundation
import UIKit

extension String {
    func capitalizeFirstLetterOfEachWord() -> String {
        let words = self.components(separatedBy: " ")
        var capitalizedWords = [String]()
        
        for word in words {
            let capitalizedWord = word.prefix(1).uppercased() + word.lowercased().dropFirst()
            capitalizedWords.append(capitalizedWord)
        }
        
        return capitalizedWords.joined(separator: " ")
    }
}

extension UIImage {
    func averageColor() -> UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: nil)
        
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: 1.0)
    }
}

extension UIViewController {
     func interpolateColor(from startColor: UIColor, to endColor: UIColor, with progress: CGFloat) -> UIColor {
        var startRed: CGFloat = 0, startGreen: CGFloat = 0, startBlue: CGFloat = 0, startAlpha: CGFloat = 0
        var endRed: CGFloat = 0, endGreen: CGFloat = 0, endBlue: CGFloat = 0, endAlpha: CGFloat = 0
        
        startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
        
        let blendedRed = startRed + (endRed - startRed) * progress
        let blendedGreen = startGreen + (endGreen - startGreen) * progress
        let blendedBlue = startBlue + (endBlue - startBlue) * progress
        let blendedAlpha = startAlpha + (endAlpha - startAlpha) * progress
        
        return UIColor(red: blendedRed, green: blendedGreen, blue: blendedBlue, alpha: blendedAlpha)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

