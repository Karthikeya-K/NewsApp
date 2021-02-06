//
//  SearchViewController.swift
//  NewsApp
//
//  Created by K Karthikeya on 06/02/21.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var newsSearchBar: UISearchBar!
    @IBOutlet weak var newsSearchTableView: UITableView!
    var searchItems = [Article]()
    var newsArticles = [Article]()
    var searching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        newsSearchBar.delegate = self
        newsSearchTableView.delegate = self
        newsSearchTableView.dataSource = self
        let popularNewsNib = UINib(nibName: "PopularNewsTableViewCell", bundle: nil)
        newsSearchTableView.register(popularNewsNib, forCellReuseIdentifier: "PopularNewsTableViewCell")
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        let article: Article
        if searching {
            article = searchItems[indexPath.row]
        } else {
            article = newsArticles[indexPath.row]
        }
        detailVC.urlString = article.url
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchItems.count
        } else {
            return newsArticles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PopularNewsTableViewCell") as? PopularNewsTableViewCell else {
            return UITableViewCell()
        }
        let article: Article
        if searching {
            article = searchItems[indexPath.row]
        } else {
            article = newsArticles[indexPath.row]
        }
        cell.configure(article: article, isBookmarked: true)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return UITableView.automaticDimension
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Searching done based on title of the news.
        searchItems = newsArticles.filter { ($0.title?.contains(searchText))!  }
        searching = true
        newsSearchTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        newsSearchTableView.reloadData()
    }
}
