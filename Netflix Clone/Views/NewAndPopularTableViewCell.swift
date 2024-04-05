//
//  NewAndPopularTableViewCell.swift
//  Netflix Clone
//
//  Created by eren on 5.04.2024.
//

import UIKit

class NewAndPopularTableViewCell: UITableViewCell {

    static let identifier = "NewAndPopularTableViewCell"
    
    private let stackView: UIStackView = {
       
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .vertical
        return stack
    }()
    
    private let sectionStackView: UIStackView = {
       
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    private let titlesPosterUIImageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let starStackView: UIStackView = {
       
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private let dateStackView: UIStackView = {
       
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    private let dateImage: UIImageView = {
       
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        return imageView
    }()
    
    private let starImage: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    private let voteAverage: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemYellow
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        starStackView.addArrangedSubview(starImage)
        starStackView.addArrangedSubview(voteAverage)
        
        dateStackView.addArrangedSubview(dateImage)
        dateStackView.addArrangedSubview(dateLabel)
        
        sectionStackView.addArrangedSubview(starStackView)
        sectionStackView.addArrangedSubview(dateStackView)
        
        stackView.addArrangedSubview(titlesPosterUIImageView)
        stackView.addArrangedSubview(sectionStackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(overviewLabel)
        
        contentView.addSubview(stackView)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        
        let stackViewConstraints = [
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]
    
        let titlesPosterUIImageViewConstraints = [
            titlesPosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titlesPosterUIImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titlesPosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlesPosterUIImageView.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        let starImageConstraints = [
            starImage.widthAnchor.constraint(equalToConstant: 20),
            starImage.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let dateImageConstraints = [
            dateImage.widthAnchor.constraint(equalToConstant: 20),
            dateImage.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]

        let overviewLabelConstraints = [
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(titlesPosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(starImageConstraints)
        NSLayoutConstraint.activate(dateImageConstraints)
    }
    
    public func configure(with model: TitleViewModel, and titleModel: Title) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w1066_and_h600_bestv2\(model.posterURL)") else {
            return
        }
        titlesPosterUIImageView.sd_setImage(with: url, completed: nil)
        
        guard let titleName = titleModel.originalTitle ?? titleModel.originalName else {
            return
        }
        
        guard let date = titleModel.releaseDate ?? titleModel.firstAirDate else {
            return
        }
        
        titleLabel.text = titleName
        overviewLabel.text = titleModel.overview
        voteAverage.text = String(format: "%.1f", titleModel.voteAverage)
        dateLabel.text = date
    }
    
}
