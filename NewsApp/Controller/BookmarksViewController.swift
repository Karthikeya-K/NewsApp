//
//  BookmarksViewController.swift
//  NewsApp
//
//  Created by K Karthikeya on 06/02/21.
//

import UIKit

protocol BookmarkChangeProtocol: AnyObject {
    func bookmarksChanged(_ bookmarkedItems: [Article])
}

class BookmarksViewController: UIViewController {
    var bookmarkedItems = [Article]()
    @IBOutlet weak var bookmarksTableView: UITableView!
    weak var delegate: BookmarkChangeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Bookmark News"
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        self.navigationItem.leftItemsSupplementBackButton = true
        bookmarksTableView.delegate = self
        bookmarksTableView.dataSource = self
        let popularNewsNib = UINib(nibName: "PopularNewsTableViewCell", bundle: nil)
        bookmarksTableView.register(popularNewsNib, forCellReuseIdentifier: "PopularNewsTableViewCell")
    }
}

extension BookmarksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PopularNewsTableViewCell") as? PopularNewsTableViewCell else {
            return UITableViewCell()
        }
        let article = bookmarkedItems[indexPath.row]
        cell.configure(article: article, isBookmarked: true)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return UITableView.automaticDimension
    }
}

extension BookmarksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        let article = bookmarkedItems[indexPath.row]
        detailVC.urlString = article.url
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension BookmarksViewController: BookmarkProtocol {
    func addToBookMark(_ article: Article?) {
        if let article = article {
            bookmarkedItems.append(article)
        }
    }
    
    func removeFromBookMark(_ article: Article?) {
        bookmarkedItems = bookmarkedItems.filter { $0 !== article }
        bookmarksTableView.reloadData()
        delegate?.bookmarksChanged(bookmarkedItems)
    }
}
