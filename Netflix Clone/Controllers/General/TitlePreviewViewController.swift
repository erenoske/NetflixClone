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

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        contentView.addSubview(overviewLabel)

        contentView.addSubview(downloadButton)
        
        configureConstraints()
        
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
    }
    
    @objc private func downloadButtonTapped() {
        
        if let safeTitleModel = titleModel {
            DataPersistenceManager.shared.downloadTitleWith(model: safeTitleModel) { result in
                switch result {
                case .success():
                    let popupVC = PopupViewController(popupText: "Successfully registered.")
                    popupVC.modalPresentationStyle = .overCurrentContext
                    self.present(popupVC, animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
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

        // Constraints for titleLabel
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: voteAverage.bottomAnchor, constant: 10),
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
            downloadButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            downloadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            downloadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]

        // Activate constraints
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(contentViewConstraints)
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(starStackViewConstraints)
        NSLayoutConstraint.activate(dateStackViewConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
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
