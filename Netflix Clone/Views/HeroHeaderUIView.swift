//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by eren on 5.03.2024.
//

import UIKit

protocol HeroHeaderUIViewDelegate {
    func didSelectMovie(viewModel: TitlePreiwViewModel)
}

class HeroHeaderUIView: UIView {
    
    var delegate: HeroHeaderUIViewDelegate?
    
    private var title: Title?
    
    private let titleLabel: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let downloadButton: UIButton = {
       
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.tintColor = .label
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return button
    }()
    
    private let playButton: UIButton = {
       
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.tintColor = .label
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return button
    }()
    
    private let heroImageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.label.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(downloadButton)
        
        addSubview(heroImageView)
        addGradient()
        addSubview(titleLabel)
        addSubview(stackView)
        
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        applyConstraints()
        
    }
    
    @objc func playButtonTapped() {
        guard let titleName = title?.original_title ?? title?.original_name else {
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
                self?.delegate?.didSelectMovie(viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func applyConstraints() {
        
        let heroImageViewConstraints = [
            heroImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            heroImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            heroImageView.widthAnchor.constraint(equalToConstant: 300),
            heroImageView.heightAnchor.constraint(equalToConstant: 420)
        ]
        
        let titleLabelConstraints = [
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -80)
        ]

        let playButtonConstraints = [
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(heroImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    public func configure(with model: TitleViewModel, and title: Title?) {
        
        guard let safeTitle = title else {
            return
        }
        
        guard let titleName = title?.original_title ?? title?.original_name else {
            return
        }
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else {
            return
        }
        
        self.title = safeTitle
        
        heroImageView.sd_setImage(with: url, completed: nil)
        
        DispatchQueue.main.async {
            self.titleLabel.text = titleName
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
