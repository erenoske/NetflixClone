//
//  NewAndPopularTableViewCell.swift
//  Netflix Clone
//
//  Created by eren on 5.04.2024.
//

import UIKit

protocol NewAndPopularTableViewCellDelegate: AnyObject {
    func listPopup()
}

class NewAndPopularTableViewCell: UITableViewCell {

    static let identifier = "NewAndPopularTableViewCell"
    
    private var titleModel: Title?
    
    weak var delegate: NewAndPopularTableViewCellDelegate?
    
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
    
    private let downloadButton: UIButton = {
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = "List"
        configuration.image = UIImage(systemName: "plus")
        configuration.baseBackgroundColor = .black
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
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
        stackView.addArrangedSubview(downloadButton)
        
        contentView.addSubview(stackView)
        
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        
        applyConstraints()
    }
    
    @objc func downloadButtonTapped() {
        
        if self.downloadButton.configuration?.image == UIImage(systemName: "plus") {
            DataPersistenceManager.shared.downloadTitleWith(model: titleModel!) { result in
                switch result {
                case .success():
                    self.downloadButton.configuration?.image = UIImage(systemName: "checkmark")
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } 
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
    
        let titlesPosterUIImageViewConstraints = [
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
        ]
        
        // Constraints for downloadButton
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            downloadButton.heightAnchor.constraint(equalToConstant: 35),
            downloadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            downloadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ]

        
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(titlesPosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(starImageConstraints)
        NSLayoutConstraint.activate(dateImageConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
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
        
        self.titleModel = titleModel
        titleLabel.text = titleName
        overviewLabel.text = titleModel.overview
        voteAverage.text = String(format: "%.1f", titleModel.voteAverage)
        dateLabel.text = date
    }
    
}
