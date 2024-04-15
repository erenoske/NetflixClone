//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by eren on 5.03.2024.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case TopRated = 2
    case Popular = 3
    case Upcoming = 4
}

class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    private var bgColor: UIColor?
    private var page = 1
    private let refreshControl = UIRefreshControl()
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Top Rated", "Populer", "Up Coming Movies"]
    
    private let homeFeedTable: UITableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 520))
        headerView?.delegate = self
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
        setupRefreshControl()
}
    
    private func setupRefreshControl() {
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        homeFeedTable.refreshControl = refreshControl
    }
    
    @objc private func refreshContent() {
        configureHeroHeaderView()
    }
    
    private func configureHeroHeaderView() {
        let group = DispatchGroup()
        
        group.enter()
        APICaller.shared.getTrendingMovies(page: 1) { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(
                    with: TitleViewModel(
                        titleName: selectedTitle?.originalName ?? selectedTitle?.originalName ?? "",
                        posterURL: selectedTitle?.posterPath ?? ""
                    ),
                    and: selectedTitle
                )
                print(selectedTitle!.id)
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.homeFeedTable.refreshControl?.endRefreshing()
            self.headerView?.downloadButton.configuration?.image = UIImage(systemName: "plus")
        }
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = 
        UIBarButtonItem(
            image: image,
            style: .done,
            target: self,
            action: nil
        )
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "magnifyingglass"),
                style: .done, 
                target: self,
                action: #selector(rightBarButtonTapped)
            ),
        ]
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    @objc private func rightBarButtonTapped() {
        let viewController = SearchViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
            
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies(page: 1) { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles, cell: Sections.TrendingMovies.rawValue)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs(page: 1) { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles, cell: Sections.TrendingTv.rawValue)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular(page: 1) { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles, cell: Sections.Popular.rawValue)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies(page: 1) { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles, cell: Sections.Upcoming.rawValue)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated(page: 1) { result in
                switch result {
                case .success(let titles):
                    let top = Array(titles.prefix(10))
                    cell.configure(with: top, cell: Sections.TopRated.rawValue)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.text = sectionTitles[section]
        
        headerView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}


extension HomeViewController: CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreiwViewModel, titleViewModel: Title) {
        DispatchQueue.main.async  { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel, and: titleViewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }

    }
}

extension HomeViewController: HeroHeaderUIViewDelegate {
    
    func listPopup(title: String) {
        let popupVC = PopupViewController(popupText: title)
        popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: true, completion: nil)
    }
    
    
    func didSelectMovie(viewModel: TitlePreiwViewModel, titleViewModel: Title) {
        DispatchQueue.main.async  { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel, and: titleViewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
