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
   
    private var notificationView: CustomNotitficationUIView?
    
    private var duplicateMovieDownload = false
    
    private var downLoadObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeFeedTable)
        view.backgroundColor = .systemBackground
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavigatorBar()
        
        configureHeaderView()
       
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        configureHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let observer = downLoadObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downLoadObserver = NotificationCenter.default.addObserver(
            forName: .DownloadedMovie,
            object: nil,
            queue: OperationQueue.main) { notification in
            self.animateSuccessDownload()
        }
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
     func animateSuccessDownload() {
        notificationView = CustomNotitficationUIView(frame: CGRect(x: 0, y: -50, width: view.bounds.width, height: 50))
        view.addSubview(notificationView!)
        
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeOut) {
               self.notificationView?.frame.origin.y = 50
           }
           animator.addCompletion { _ in
              self.notificationView?.animateCheckMark {
                   print("ok")
                   UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseIn], animations: {
                       self.notificationView?.frame.origin.y = -50
                   }, completion: { _ in
                       self.notificationView?.removeFromSuperview()
                       print("notifi disappear")
                   })
               }
           }
           animator.startAnimation()
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
        case ~Sections.TrendingMovies:
            APICaller.shared.getTrendingMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case ~Sections.TrendingTV:
            APICaller.shared.getTrendingTVs { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case ~Sections.Popular:
            APICaller.shared.getPopular { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case ~Sections.Upcoming:
            APICaller.shared.getUpcomingMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case ~Sections.TopRated:
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
           
           if traitCollection.userInterfaceStyle == .dark {
               // dark
               content.secondaryTextProperties.color = .white
           } else {
               // light
               content.secondaryTextProperties.color = .black
           }
           
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
