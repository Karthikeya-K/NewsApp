//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by K Karthikeya on 06/02/21.
//

import Foundation

protocol FetchProtocol: AnyObject {
    func parseComplete()
}

class NewsViewModel {
    var newsModel: NewsModel? = nil
    weak var delegate: FetchProtocol?
    var articles: [Article]?

    func parseNews() {
        //Loading news from json for testing purpose
        guard let url = Bundle.main.url(forResource: "news", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        do {
            newsModel = try? JSONDecoder().decode(NewsModel.self, from: data)
            articles = newsModel?.articles
            delegate?.parseComplete()
        }
    }

    func getArticleAt(_ index: Int) -> Article? {
        return articles?[index]
    }
}
