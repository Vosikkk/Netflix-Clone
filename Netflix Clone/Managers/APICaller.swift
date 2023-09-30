//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Саша Восколович on 30.09.2023.
//

import Foundation

struct Constants {
    static let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ZDA3ZDFiNTk2MmM0M2UwZmFmNmFlNjM3MGI3OGIwMSIsInN1YiI6IjY1MTgwZDJjMDcyMTY2MDEzOWM1M2Y1ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._RJHpNwQ5bfgRo2oW0LSqESDEOyiAh6EBYCAMEYbZxo"
    ]
    static let API_KEY = "5d07d1b5962c43e0faf6ae6370b78b01"
    static let httpMethod = "GET"
}

enum APIError: Error {
    
}

class APICaller {
    
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
       
        let urlString = "https://api.themoviedb.org/3/trending/all/day?language=en-US"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        request.allHTTPHeaderFields = Constants.headers
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
    func getTrendingTVs(completion: @escaping (Result<[Title], Error>) -> Void) {
    
        let urlString = "https://api.themoviedb.org/3/trending/tv/day?language=en-US"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        request.allHTTPHeaderFields = Constants.headers
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    

    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        request.allHTTPHeaderFields = Constants.headers
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        let urlString = "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        request.allHTTPHeaderFields = Constants.headers
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        request.allHTTPHeaderFields = Constants.headers
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
    
    
  //"https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1"
    
    
    
//    func getTrandingMoviesByAnotherWay(completion: @escaping (Data?, Error?) -> Void) {
//        let headers = [
//             "accept": "application/json",
//             "Authorization": "Bearer \(Constants.TOKEN)"
//        ]
//        let urlString = "https://api.themoviedb.org/3/trending/all/day?language=en-US"
//        guard let url = URL(string: urlString) else {
//            completion(nil, NSError(domain: "Invalid URL", code: 0))
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//        let task = URLSession.shared.dataTask(with: request) { data, response , error in
//            if (error != nil) {
//                print(error as Any)
//              } else {
//                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse!)
//                completion(data,nil)
//              }
//        }
//
//        task.resume()
//    }
    
}
