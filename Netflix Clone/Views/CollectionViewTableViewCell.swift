//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Саша Восколович on 29.09.2023.
//

import UIKit


extension NSNotification.Name {
    static let DownloadedMovie = Notification.Name("Downloaded")
}



// MARK: - Protocol
protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
    func collectionViewTableViewCellDidDownLoadDuplicate()
}

class CollectionViewTableViewCell: UITableViewCell {

    
    // MARK: - Properties
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = [Title]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collection
    }()
    
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - super func
    
    // We get new info about films
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        DataPersistenceManager.shared.downloadTitle(with: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    NotificationCenter.default.post(name: .DownloadedMovie, object: nil)
                case.failure(let error):
                    if let dataError = error as? DatabaseError, dataError == .duplicateItem {
                        self?.delegate?.collectionViewTableViewCellDidDownLoadDuplicate()
                    } else {
                        print(error.localizedDescription)
               }
           }
       }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        // Received path to the poster of the film
        guard let model = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        
        // Make it beautiful
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        // You tap on the cell, so make request to the youtube, receive info to the HOmeController
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] results in
            switch results {
            case .success(let videoElement):
               
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else { return }
                guard let strongSelf = self else { return }
                let model = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: model)
            
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configure = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ in
                let downloadAction = UIAction(title: "Download") { _ in
                    if let indexPath = indexPaths.first {
                        self.downloadTitleAt(indexPath: indexPath)
                    }
                }
                return UIMenu(options: .displayInline, children: [downloadAction])
        }
        return configure
    }
}
