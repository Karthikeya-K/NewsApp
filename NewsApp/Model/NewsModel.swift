//
//  NewsModel.swift
//  NewsApp
//
//  Created by K Karthikeya on 06/02/21.
//

import Foundation
import UIKit


struct NewsModel: Codable {
    let articles: [Article]?
    let status: String?
    let totalResults: Int?
}

class Article: Codable {
    let author: String?
    let content: String?
    let description: String?
    let publishedAt: String?
    let source: Source?
    let title: String?
    let url: String?
    let urlToImage: String?
}

struct Source: Codable {
    let id: String?
    let name: String?
}
