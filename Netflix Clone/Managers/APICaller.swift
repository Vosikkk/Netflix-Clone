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
        "Authorization": "Bearer \(getAuthToken())"
    ]
   
    static let httpMethod = "GET"
    
    static func getAuthToken() -> String {
           guard let authToken = ProcessInfo.processInfo.environment["MY_API_TOKEN"] else {
               fatalError("Token not found in environment variables")
           }
           return authToken
       }
}

enum APIError: Error {
    case failedToGetData
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
                completion(.failure(APIError.failedToGetData))
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
                completion(.failure(APIError.failedToGetData))
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
                completion(.failure(APIError.failedToGetData))
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
                completion(.failure(APIError.failedToGetData))
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
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    
    
    
 
    
    
    
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
