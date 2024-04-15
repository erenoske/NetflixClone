//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by eren on 5.03.2024.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreiwViewModel, titleViewModel: Title)
}


class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = [Title]()
    
    private var pageNumber = 1
    
    private let titleCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionView
    }()
    
    private let topRatedCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 190, height: 170)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TopRatedCollectionViewCell.self, forCellWithReuseIdentifier: TopRatedCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 10)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(titleCollectionView)
        contentView.addSubview(topRatedCollectionView)
        
        titleCollectionView.delegate = self
        titleCollectionView.dataSource = self
        
        topRatedCollectionView.delegate = self
        topRatedCollectionView.dataSource = self
    }

    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleCollectionView.frame = contentView.bounds
        topRatedCollectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Title], cell: Int) {
        self.titles = titles
        
        DispatchQueue.main.async { [weak self] in
            
            if cell == 2 {
                self?.topRatedCollectionView.isHidden = false
                self?.titleCollectionView.isHidden = true
            } else {
                self?.topRatedCollectionView.isHidden = true
                self?.titleCollectionView.isHidden = false
            }
            
            self?.titleCollectionView.reloadData()
            self?.topRatedCollectionView.reloadData()
            
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == titleCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            guard let model = titles[indexPath.row].posterPath else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: model)
            
            return cell
        } else if collectionView == topRatedCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRatedCollectionViewCell.identifier, for: indexPath) as? TopRatedCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            guard let model = titles[indexPath.row].posterPath else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: model, rate: indexPath.row + 1)
            
            return cell
        } else {
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.originalTitle ?? title.originalName else {
            return
        }
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                guard let strongSelf = self else {
                    return
                }
                let viewModel = TitlePreiwViewModel(
                    title: titleName,
                    youtubeView: videoElement,
                    titleOverview: titleOverview)
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel, titleViewModel: title!)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                let downloadAction = UIAction(title: "Add List", subtitle: nil, image: UIImage(systemName: "plus"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
}
