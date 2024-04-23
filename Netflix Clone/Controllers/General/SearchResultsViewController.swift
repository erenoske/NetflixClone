//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by eren on 8.03.2024.
//

import UIKit

protocol SearchResultsViewControllerDelagate: AnyObject {
    func searchResultsViewControllerDidTabItem(_ viewModel: TitlePreiwViewModel, titleViewModel: Title)
    func hideKeyboard()
}


class SearchResultsViewController: UIViewController {
    
    
    public var titles: [Title] = [Title]()
    
    public weak var delegate: SearchResultsViewControllerDelagate?
    
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth / 3 - 10
        let itemHeight = itemWidth * 1.5
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.delegate?.hideKeyboard()
    }

}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.posterPath ?? "URL not found")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        let titleName = title.originalTitle ?? ""
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    self?.delegate?.searchResultsViewControllerDidTabItem(
                        TitlePreiwViewModel(
                            title: title.originalTitle ?? "",
                            youtubeView: videoElement,
                            titleOverview: title.overview ?? ""
                        ), titleViewModel: title
                    )
                }
        
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    
    }
}
