//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by eren on 5.03.2024.
//

import UIKit

protocol HeroHeaderUIViewDelegate: AnyObject {
    func didSelectMovie(viewModel: TitlePreiwViewModel, titleViewModel: Title)
    func listPopup(title: String)
    func color(averageColor: UIColor)
}

class HeroHeaderUIView: UIView {
    
    weak var delegate: HeroHeaderUIViewDelegate?
    
    private var title: Title?
    
    private var imageColor: UIColor?
    
    private let titleLabel: UILabel = {
       
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public let downloadButton: UIButton = {
       
        var configuration = UIButton.Configuration.plain()
        configuration.title = "List"
        configuration.image = UIImage(systemName: "plus")
        configuration.baseBackgroundColor = .black
        configuration.imagePadding = 10
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        return button
    }()
    
    private let playButton: UIButton = {
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Play"
        configuration.image = UIImage(systemName: "play.fill")
        configuration.baseBackgroundColor = .black
        configuration.imagePadding = 10
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.backgroundColor = .white
        button.tintColor = .black
        button.clipsToBounds = true
        return button
    }()
    
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        return view
    }()

    
    private let heroImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.label.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let labelScrollView: UIScrollView = {
       
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.cornerRadius = 5
        
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layerWidth: CGFloat = 338
        let layerHeight: CGFloat = 200
        
        gradientLayer.frame = CGRect(x: (bounds.width - layerWidth) / 2,
                                     y: 309,
                                        width: layerWidth,
                                        height: layerHeight)
        
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(downloadButton)
        addSubview(shadowView)
        shadowView.addSubview(heroImageView)
        layer.insertSublayer(gradientLayer, below: self.layer)
        addSubview(titleLabel)
        addSubview(labelScrollView)
        addSubview(stackView)

        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        
        applyConstraints()

        backgroundColor = .clear
    }
    
    @objc func downloadButtonTapped() {
        
        if self.downloadButton.configuration?.image == UIImage(systemName: "plus") {
            DataPersistenceManager.shared.downloadTitleWith(model: title!) { result in
                switch result {
                case .success():
                    self.downloadButton.configuration?.image = UIImage(systemName: "checkmark")
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            self.delegate?.listPopup(title: "Allready exist.")
        }
        

    }
    
    @objc func playButtonTapped() {
        guard let titleName = title?.originalTitle ?? title?.originalName else {
            return
        }
        
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                
                guard let titleOverview = self?.title?.overview else {
                    return
                }
                
                let viewModel = TitlePreiwViewModel(
                    title: titleName,
                    youtubeView: videoElement,
                    titleOverview: titleOverview)
                self?.delegate?.didSelectMovie(viewModel: viewModel, titleViewModel: self!.title!)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func applyConstraints() {
        
        let heroImageViewConstraints = [
            heroImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            heroImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            heroImageView.widthAnchor.constraint(equalToConstant: 340),
            heroImageView.heightAnchor.constraint(equalToConstant: 500)
        ]
        
        let titleLabelConstraints = [
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -95),
            titleLabel.widthAnchor.constraint(equalToConstant: 310)
        ]
        
        let labelScrollViewConstraints = [
            labelScrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelScrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -65),
            labelScrollView.heightAnchor.constraint(equalToConstant: 30)        
        ]

        let stackViewConstraints = [
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -23),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        let playButtonConstraints = [
            playButton.widthAnchor.constraint(equalToConstant: 150),
            playButton.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.widthAnchor.constraint(equalToConstant: 150),
            downloadButton.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(heroImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        NSLayoutConstraint.activate(labelScrollViewConstraints)
    }
    
    public func configure(with model: TitleViewModel, and title: Title?) {
        
        guard let safeTitle = title else {
            return
        }
        
        guard let titleName = title?.originalTitle ?? title?.originalName else {
            return
        }
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else {
            return
        }
        
        self.title = safeTitle
        
        heroImageView.sd_setImage(with: url) { (image, error, cacheType, url) in
            if let image = image {
                if let averageColor = image.averageColor() {
                    print("General color: \(averageColor)")
                    self.delegate?.color(averageColor: averageColor)
                    self.gradientLayer.colors = [
                        UIColor.clear.cgColor,
                        averageColor.cgColor
                    ]
                }
            }
        }
        
        DispatchQueue.main.async {
            self.titleLabel.text = titleName
        }
        
        
        // MARK: - Genres Label
        genresLabel(title: safeTitle)

    }
    
    private var labelArray = [UILabel]()
    private var tempLabelArray = [UILabel]()

    private func genresLabel(title: Title) {
        DispatchQueue.main.async {
            self.labelArray.forEach { $0.removeFromSuperview() }
            self.labelArray.removeAll()
            self.tempLabelArray.removeAll()

            let genres = GenreConverter.convertToGenreNames(genreIds: title.genreIds)

            for (_, genre) in genres.prefix(4).enumerated() {
                let label = UILabel()
                label.text = genre
                label.textColor = .label
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 15)
                label.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(label)
                self.labelArray.append(label)
                
                let tempLabel = UILabel()
                tempLabel.text = genre
                tempLabel.font = UIFont.systemFont(ofSize: 15)
                self.tempLabelArray.append(tempLabel)
                
                let size = tempLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.size.height))
                let labelWidth = size.width
                
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: self.labelScrollView.topAnchor),
                    label.bottomAnchor.constraint(equalTo: self.labelScrollView.bottomAnchor),
                    label.heightAnchor.constraint(equalTo: self.labelScrollView.heightAnchor),
                    label.widthAnchor.constraint(equalToConstant: labelWidth)
                ])
                
                if let previousLabel = self.labelArray.last(where: { $0 != label }) {
                    label.leadingAnchor.constraint(equalTo: previousLabel.trailingAnchor, constant: 8).isActive = true
                } else {
                    label.leadingAnchor.constraint(equalTo: self.labelScrollView.leadingAnchor).isActive = true
                }
            }

            if let lastLabel = self.labelArray.last {
                lastLabel.trailingAnchor.constraint(equalTo: self.labelScrollView.trailingAnchor).isActive = true
            }
        }
    }




    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
