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
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Populer", "Up Coming Movies", "Top rated"]
    
    private let homeFeedTable: UITableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = false
        return table
    }()
    
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
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
        APICaller.shared.getTrendingMovies { [weak self] result in
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
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.homeFeedTable.refreshControl?.endRefreshing()
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
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
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
        return 200
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y , width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    // Menu bar staying on top
   // func scrollViewDidScroll(_ scrollView: UIScrollView) {
   //     let defaultOffset = view.safeAreaInsets.top
   //     let offset = scrollView.contentOffset.y + defaultOffset
   //
   //     navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
   // }

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
    
    func listPopup() {
        let popupVC = PopupViewController(popupText: "Successfully registered.")
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

