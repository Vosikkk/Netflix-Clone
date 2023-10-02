//
//  YouTubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Саша Восколович on 02.10.2023.
//

import Foundation

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
