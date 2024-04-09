//
//  MyNetflixViewController.swift
//  Netflix Clone
//
//  Created by eren on 5.03.2024.
//

import UIKit

class MyNetflixViewController: UIViewController {
    
    private var titles: [TitleItem] = [TitleItem]()
    
    private let listTable: UITableView = {
        
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        listTable.delegate = self
        listTable.dataSource = self
        
        view.addSubview(listTable)
        
        configureNavbar()
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
        
    }
    
    private func configureNavbar() {        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.text = "My Netflix"
        let labelBarButton = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = labelBarButton

        
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
    
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingTitlesFromDataBase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.listTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        listTable.frame = view.bounds
    }

}

extension MyNetflixViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.originalName ?? title.originalTitle ?? "Unknown", posterURL: title.posterPath ?? "URL not found")
        let titleModel = Title(id: Int(title.id), mediaType: title.mediaType, originalName: title.originalName, originalTitle: title.originalTitle, posterPath: title.posterPath, backdropPath: title.backdropPath, firstAirDate: title.firstAirDate, overview: title.overview, voteCount: Int(title.voteCount), releaseDate: title.releaseDate, voteAverage: title.voteAverage, genreIds: [])
        cell.configure(with: model, and: titleModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.originalName ?? title.originalTitle else {
            return
        }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    let titleModel = Title(id: Int(title.id), mediaType: title.mediaType, originalName: title.originalName, originalTitle: title.originalTitle, posterPath: title.posterPath, backdropPath: title.backdropPath, firstAirDate: title.firstAirDate, overview: title.overview, voteCount: Int(title.voteCount), releaseDate: title.releaseDate, voteAverage: title.voteAverage, genreIds: [120])
                    vc.configure(with: TitlePreiwViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""), and: titleModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
