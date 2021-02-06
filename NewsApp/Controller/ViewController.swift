//
//  ViewController.swift
//  NewsApp
//
//  Created by K Karthikeya on 06/02/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var popularNewsTableView: UITableView!
    var newsViewModel = NewsViewModel()
    var bookmarkedItems = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    func setUp() {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Global News"
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        self.navigationItem.leftItemsSupplementBackButton = true
        newsViewModel.delegate = self
        newsViewModel.parseNews()
        setUpTableView()
    }
    
    func setUpTableView() {
        popularNewsTableView.delegate = self
        popularNewsTableView.dataSource = self

        let topNewsNib = UINib(nibName: "TopNewsTableViewCell", bundle: nil)
        popularNewsTableView.register(topNewsNib, forCellReuseIdentifier: "TopNewsTableViewCell")
        let popularNewsNib = UINib(nibName: "PopularNewsTableViewCell", bundle: nil)
        popularNewsTableView.register(popularNewsNib, forCellReuseIdentifier: "PopularNewsTableViewCell")
    }
    
    @IBAction func searchBarTapped(_ sender: Any) {
        guard let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else {
            return
        }

        if let articles = newsViewModel.articles {
            searchVC.newsArticles = articles
        }
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func bookmarksTapped(_ sender: Any) {
        guard let bookmarksVC = self.storyboard?.instantiateViewController(withIdentifier: "BookmarksViewController") as? BookmarksViewController else {
            return
        }
        bookmarksVC.bookmarkedItems = bookmarkedItems
        bookmarksVC.delegate = self
        self.navigationController?.pushViewController(bookmarksVC, animated: true)
    }
}

extension ViewController: FetchProtocol {
    func parseComplete() {
        popularNewsTableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            guard let articleCount = newsViewModel.articles?.count else {
                return 0
            }
            return  articleCount - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopNewsTableViewCell") as? TopNewsTableViewCell else {
                return UITableViewCell()
            }
            //Considering first news as top news from the api response
            let article = newsViewModel.getArticleAt(0)
            cell.configure(article: article)
            cell.delegate = self
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PopularNewsTableViewCell") as? PopularNewsTableViewCell else {
                return UITableViewCell()
            }
            //First news considered as top news
            if indexPath.row != 0 {
                let article = newsViewModel.getArticleAt(indexPath.row)
                cell.configure(article: article, isBookmarked: false)
                cell.delegate = self
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.size.width, height: 40))
            label.text = "Top News"
            label.textAlignment = .left
            label.font = UIFont.boldSystemFont(ofSize: 22.0)
            headerView.addSubview(label)
            return headerView
        } else {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.size.width, height: 40))
            label.text = "Popular News"
            label.textAlignment = .left
            label.font = UIFont.boldSystemFont(ofSize: 22.0)
            headerView.addSubview(label)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return UITableView.automaticDimension
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        let article = newsViewModel.getArticleAt(indexPath.row)
        detailVC.urlString = article?.url
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: BookmarkProtocol {
    func addToBookMark(_ article: Article?) {
        if let article = article {
            bookmarkedItems.append(article)
        }
    }
    
    func removeFromBookMark(_ article: Article?) {
        bookmarkedItems = bookmarkedItems.filter { $0 !== article }
    }
}

extension ViewController: BookmarkChangeProtocol {
    func bookmarksChanged(_ bookmarkedItems: [Article]) {
        self.bookmarkedItems = bookmarkedItems
        popularNewsTableView.reloadData()
    }
}

extension UIViewController {
    open override func awakeFromNib() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
