//
//  Title.swift
//  Netflix Clone
//
//  Created by Саша Восколович on 30.09.2023.
//

import Foundation

// Model which accordance to json file received from database(TMBD)

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {

    let id: Int
    let media_type: String?
    let original_language: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    let original_name: String?

}

// Some another implementation

// struct TrendingMoviesResponse: Codable {
//
//    let results: [Movie]
//
//    struct Movie: Codable {
//
//        let id: Int
//        let media_type: String?
//        let original_language: String?
//        let original_title: String?
//        let poster_path: String?
//        let overview: String?
//        let vote_count: Int
//        let release_date: String?
//        let vote_average: Double
//    }
//
//    init?(json: Data) {
//        if let newValue = try? JSONDecoder().decode(TrendingMoviesResponse1.self, from: json) {
//            self = newValue
//        } else {
//            return nil
//        }
//    }
//}
