//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by eren on 8.03.2024.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private var titleModel: Title?
    
    private var casts: [Cast] = [Cast]()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
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
    
    private let voteAverage: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemYellow
        return label
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let castCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 220)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let castLabel: UILabel = {
       
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    private let labelScrollView: UIScrollView = {
       
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        // Add scrollView to view
        view.addSubview(scrollView)
        
        // Add contentView to scrollView
        scrollView.addSubview(contentView)
        
        // Stack
        starStackView.addArrangedSubview(starImage)
        starStackView.addArrangedSubview(voteAverage)
        
        dateStackView.addArrangedSubview(dateImage)
        dateStackView.addArrangedSubview(dateLabel)
        
        // Add subviews to contentView
        contentView.addSubview(webView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starStackView)
        contentView.addSubview(dateStackView)
        contentView.addSubview(labelScrollView)
        contentView.addSubview(overviewLabel)

        contentView.addSubview(downloadButton)
        
        contentView.addSubview(castLabel)
        contentView.addSubview(castCollectionView)
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        configureConstraints()
        
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        
        APICaller.shared.getMovieCasts(with: titleModel!.id) { result in
            switch result {
            case .success(let titles):
                self.casts = titles
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        DispatchQueue.main.async {
            if self.casts.count > 0 {
                self.castLabel.text = "Cast"
            }
        }
        
        // MARK: - Genres Label
        
        var labelArray = [UILabel]()
        
        var previousLabel: UILabel?
        
        DispatchQueue.main.async {
            let titles = GenreConverter.convertToGenreNames(genreIds: self.titleModel!.genreIds)

            for title in titles {
                let label = UILabel()
                label.text = title
                label.textColor = .label
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 16)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.layer.borderWidth = 1.0
                label.layer.borderColor = UIColor.label.cgColor
                label.layer.cornerRadius = 3
                self.labelScrollView.addSubview(label)
                labelArray.append(label)
                
                let tempLabel = UILabel()
                tempLabel.text = title
                tempLabel.font = UIFont.systemFont(ofSize: 16)
                let size = tempLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.size.height))
                let labelWidth = size.width + 16
                
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: self.labelScrollView.topAnchor),
                    label.bottomAnchor.constraint(equalTo: self.labelScrollView.bottomAnchor),
                    label.heightAnchor.constraint(equalTo: self.labelScrollView.heightAnchor),
                    label.widthAnchor.constraint(equalToConstant: labelWidth)
                ])
                
                if let previousLabel = previousLabel {
                    label.leadingAnchor.constraint(equalTo: previousLabel.trailingAnchor, constant: 8).isActive = true
                } else {
                    label.leadingAnchor.constraint(equalTo: self.labelScrollView.leadingAnchor).isActive = true
                }
                
                previousLabel = label
            }

            if let lastLabel = labelArray.last {
                lastLabel.trailingAnchor.constraint(equalTo: self.labelScrollView.trailingAnchor).isActive = true
            }

        }

    }
    
    @objc private func downloadButtonTapped() {
        
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
        } else {
            let popupVC = PopupViewController(popupText: "Allready exists.")
            popupVC.modalPresentationStyle = .overCurrentContext
            self.present(popupVC, animated: true, completion: nil)
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    func configureConstraints() {
        
        // Constraints for scrollView
        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        // Constraints for contentView
        let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
        
        let width = view.frame.width
        let webViewHeight: CGFloat = width * 9 / 16 // Aspect ratio 16:9

        // Constraints for webView
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: webViewHeight)
        ]
        
        let starStackViewConstraints = [
            starStackView.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 10),
            starStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ]
        
        let dateStackViewConstraints = [
            dateStackView.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 10),
            dateStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]
        
        let labelScrollViewConstraints = [
            labelScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            labelScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            labelScrollView.topAnchor.constraint(equalTo: starStackView.bottomAnchor, constant: 10),
            labelScrollView.heightAnchor.constraint(equalToConstant: 30)
        ]

        // Constraints for titleLabel
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: labelScrollView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]

        // Constraints for overviewLabel
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]

        // Constraints for downloadButton
        let downloadButtonConstraints = [
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 10),
            downloadButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            downloadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]
        
        let castLabelConstraints = [
            castLabel.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 10),
            castLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            castLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]
        
        let castCollectionViewConstraints = [
            castCollectionView.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 10),
            castCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            castCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            castCollectionView.heightAnchor.constraint(equalToConstant: 250),
            castCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]

        // Activate constraints
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(contentViewConstraints)
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(starStackViewConstraints)
        NSLayoutConstraint.activate(dateStackViewConstraints)
        NSLayoutConstraint.activate(labelScrollViewConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        NSLayoutConstraint.activate(castLabelConstraints)
        NSLayoutConstraint.activate(castCollectionViewConstraints)
    }
    
    func configure(with model: TitlePreiwViewModel, and titleModel: Title) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        voteAverage.text = String(format: "%.1f", titleModel.voteAverage)
        dateLabel.text = titleModel.releaseDate ?? titleModel.firstAirDate
        
        self.titleModel = titleModel
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }

}

extension TitlePreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

         if casts.count < 12 {
             return casts.count
         } else {
             return 12
         }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell else {
             return UICollectionViewCell()
         }
         
         let cast = casts[indexPath.row]
         
         cell.configure(with: cast.profilePath, title: cast.name, character: cast.character)
         return cell
    }
    
}

