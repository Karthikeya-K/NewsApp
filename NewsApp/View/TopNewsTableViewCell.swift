//
//  TopNewsTableViewCell.swift
//  NewsApp
//
//  Created by K Karthikeya on 06/02/21.
//

import UIKit

protocol BookmarkProtocol: AnyObject {
    func addToBookMark(_ article: Article?)
    func removeFromBookMark(_ article: Article?)
}

class TopNewsTableViewCell: UITableViewCell {
    @IBOutlet weak var topNewsImageView: UIImageView!
    @IBOutlet weak var topNewsTitle: UILabel!
    @IBOutlet weak var topNewsDescription: UILabel!
    @IBOutlet weak var topNewsSource: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    var bookMarked: Bool = false
    weak var delegate: BookmarkProtocol?
    var article: Article?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(article: Article?) {
        self.article = article
        let title = article?.title
        let description = article?.description
        let imageUrlString = article?.urlToImage
        let source = article?.source?.name
        
        topNewsTitle.text = title
        topNewsDescription.text = description
        topNewsSource.text = source
        topNewsSource.layer.cornerRadius = 5
        topNewsSource.layer.masksToBounds = true
        if let imageUrlString = imageUrlString, let url = URL(string: imageUrlString) {
            getNewsImage(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.topNewsImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    @IBAction func bookmarkTapped(_ sender: Any) {
        if !bookMarked {
            bookmarkButton.setImage(UIImage(named: "bookmark2.png"), for: .normal)
            bookMarked = true
            delegate?.addToBookMark(self.article)
        } else {
            bookmarkButton.setImage(UIImage(named: "bookmark.png"), for: .normal)
            bookMarked = false
            delegate?.removeFromBookMark(self.article)
        }
    }
    
    func getNewsImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
