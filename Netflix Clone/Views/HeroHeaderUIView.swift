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
    
    private let downloadButton: UIButton = {
       
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let playButton: UIButton = {
       
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let heroImageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
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
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        
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

        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    public func configure(with model: TitleViewModel, and title: Title?) {
        
        guard let safeTitle = title else {
            return
        }
        
        self.title = safeTitle
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else {
            return
        }
        
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
