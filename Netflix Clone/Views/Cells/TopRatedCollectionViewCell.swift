//
//  TopRatedCollectionViewCell.swift
//  Netflix Clone
//
//  Created by eren on 14.04.2024.
//

import UIKit
import SDWebImage

class TopRatedCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TopRatedCollectionViewCell"
    
    private var rate = 1
    
    private let posterImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 60, weight: .heavy)
        label.textColor = .systemGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.spacing = -10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(posterImageView)
        contentView.addSubview(stackView)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ]
        
        let titleLabelConstraints = [
            titleLabel.widthAnchor.constraint(equalToConstant: 75)
        ]

        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = contentView.bounds
    }
    
    public func configure(with model: String, rate: Int) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else {
            return
        }
        
        posterImageView.sd_setImage(with: url)
        
        titleLabel.text = String(rate)
        
    }
}

