//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Саша Восколович on 29.09.2023.
//

import UIKit

enum Sections: Int {
    case TrendingMovies, TrendingTV, Popular, Upcoming, TopRated
}



class HomeViewController: UIViewController {
    
    
    // MARK: - Properties
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    
    private var randomTrandingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
   
    private var bannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var duplicateMovieDownload = false
    
    // MARK: - Lifecycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeFeedTable)
        view.backgroundColor = .systemBackground
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavigatorBar()
        
       
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2))
        homeFeedTable.tableHeaderView = headerView
        
        configureHeaderView()
        NotificationCenter.default.addObserver(self, selector: #selector(downloadComleted), name: NSNotification.Name("Download Completed"), object: nil)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    // MARK: - Private Methods
    
    private func configureNavigatorBar() {
        var image = UIImage(named: "netflix_logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] results in
            switch results {
            case.success(let titles):
                let title = titles.randomElement()
                self?.randomTrandingMovie = title
                self?.headerView?.configure(with: TitleViewModel(titleName: title?.original_title ?? "", posterURL: title?.poster_path ?? ""))
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    @objc func downloadComleted() {
           bannerView.frame = CGRect(x: 0, y: -100, width: view.frame.width, height: 100)
           view.addSubview(bannerView)
       
           // Анімація виведення банера
           UIView.animate(withDuration: 0.3) {
               self.bannerView.frame.origin.y = 0
           }
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] timer in
            self?.hideBanner()
           }
    }
    
    private func hideBanner() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.bannerView.frame.origin.y = -100
        }
        bannerView.removeFromSuperview()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        
        // Assign this controller as delegate
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTV.rawValue:
            APICaller.shared.getTrendingTVs { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { results in
                switch results {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        var content = header.defaultContentConfiguration()
        content.secondaryText = sectionTitles[section].capitalizeFirstLetter()
        content.secondaryTextProperties.font = .systemFont(ofSize: 18, weight: .semibold)
        content.directionalLayoutMargins = .init(top: 0, leading: 0, bottom: 5, trailing: 0)
        content.secondaryTextProperties.color = .white
        header.contentConfiguration = content
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // If we go down, bar disappear, when go up it's appear)
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewCellDidDownLoadDuplicate() {
        if !duplicateMovieDownload {
            let alert = UIAlertController(title: "Download Failed",
                                          message:"You already have this movie in your downloads.\nDo you want to show this warning in the future?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Keep Warning", style: .default))
            alert.addAction(UIAlertAction(title: "Stop Warning", style: .destructive, handler: { action in
                self.duplicateMovieDownload = true
            }))
            present(alert, animated: true)
        }
    }
    
    
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
       // We tap on the cell and we want to see youtube video and info about the film so let's go
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
