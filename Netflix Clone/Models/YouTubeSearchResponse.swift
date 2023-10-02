//
//  YouTubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Саша Восколович on 02.10.2023.
//

import Foundation

// This model save path to the video on youtube

struct YouTubeSearchResponse: Codable {
    let items: [VideoElement]
}
struct VideoElement: Codable {
    let id: IDVideoElement
}

struct IDVideoElement: Codable {
    let kind: String
    let videoId: String
}
