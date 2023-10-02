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
   
    static func getAuthToken() -> String {
           guard let authToken = ProcessInfo.processInfo.environment["MY_API_TOKEN"] else {
               fatalError("Token not found in environment variables")
           }
           return authToken
       }
    static func getAPIKey() -> String {
        guard let APIKey = ProcessInfo.processInfo.environment["API_KEY"] else {
            fatalError("Api key not found in environment variables")
        }
        return APIKey
    }
    
    static func getYouTubeAPIKey() -> String {
        guard let YouTubeAPIKey = ProcessInfo.processInfo.environment["API_YOUTUBE_KEY"] else {
            fatalError("Api key not found in environment variables")
        }
        return YouTubeAPIKey
    }
    
    static let httpMethod = "GET"
    static let baseImageURL = "https://image.tmdb.org/t/p/w500"
    static let baseURL = "https://api.themoviedb.org/3/"
    static let baseYouTubeURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    static let shared = APICaller()
    
   func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
       
        let urlString = "\(Constants.baseURL)trending/all/day?language=en-US"
        
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
    
        let urlString = "\(Constants.baseURL)trending/tv/day?language=en-US"
        
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
        
        let urlString = "\(Constants.baseURL)movie/upcoming?language=en-US&page=1"
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
        
        let urlString = "\(Constants.baseURL)movie/popular?language=en-US&page=1"
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
        
        let urlString = "\(Constants.baseURL)movie/top_rated?language=en-US&page=1"
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
    
   
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc"
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
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string:"\(Constants.baseURL)search/movie?query=\(query)&api_key=\(Constants.getAPIKey())") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseYouTubeURL)q=\(query)&key=\(Constants.getYouTubeAPIKey())") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    
}
