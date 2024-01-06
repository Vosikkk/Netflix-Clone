//
//  NetflixViewModel.swift
//  Netflix Clone
//
//  Created by Саша Восколович on 03.01.2024.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func updateUI(with titles: [Title], for: Int)
}

class NetflixViewModel: ObservableObject {
    
    let data: DataPersistenceManager
    let apiManager: APICaller
    weak var delegate: HomeViewControllerDelegate?
    
    init(data: DataPersistenceManager, apiManager: APICaller) {
        self.data = data
        self.apiManager = apiManager
    }
    
    
    
    
    
    func getTrendingMovies(for indexPath: Int) async {
        do {
           let titles = try await apiManager.getTrendingMovies()
            delegate?.updateUI(with: titles, for: indexPath)
        } catch {
            print(error)
        }
    }
    
    
    
    
    
    
    
}
