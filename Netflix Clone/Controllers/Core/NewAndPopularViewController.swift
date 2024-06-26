//
//  NewAndPopularViewController.swift
//  Netflix Clone
//
//  Created by eren on 5.03.2024.
//

import UIKit

class NewAndPopularViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    private var page = 1
    
    private let upcomingTable: UITableView = {
        
        let table = UITableView()
        table.register(NewAndPopularTableViewCell.self, forCellReuseIdentifier: NewAndPopularTableViewCell.identifier)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureNavbar()
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming(pageNumber: 1)
    }
    
    private func configureNavbar() {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.text = "New And Popular"
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming(pageNumber: Int) {
        APICaller.shared.getUpcomingMovies(page: pageNumber) { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles.append(contentsOf: titles)
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension NewAndPopularViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewAndPopularTableViewCell.identifier, for: indexPath) as? NewAndPopularTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.originalTitle ?? title.originalName) ?? "Unknown Name", posterURL: title.backdropPath ?? "Url not found"), and: title)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 420
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
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""), and: title)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 250 {
            if page < 4 {
                page += 1
                fetchUpcoming(pageNumber: page)
                print(page)
            }
        }
    }
}

extension NewAndPopularViewController: NewAndPopularTableViewCellDelegate {
    
    func listPopup() {
        let popupVC = PopupViewController(popupText: "Successfully registered.")
        popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: true, completion: nil)
    }
    
}
