//
//  PopularNewsTableViewCell.swift
//  NewsApp
//
//  Created by K Karthikeya on 06/02/21.
//

import UIKit

class PopularNewsTableViewCell: UITableViewCell {
    @IBOutlet weak var popularNewsImageView: UIImageView!
    @IBOutlet weak var popularNewsTitle: UILabel!
    @IBOutlet weak var popularNewsDescription: UILabel!
    @IBOutlet weak var popularNewsSource: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    var bookMarked: Bool = false
    weak var delegate: BookmarkProtocol?
    var article: Article?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(article: Article?, isBookmarked: Bool) {
        self.article = article
        let title = article?.title
        let description = article?.description
        let imageUrlString = article?.urlToImage
        let source = article?.source?.name
        
        if isBookmarked {
            bookMarked = true
            bookmarkButton.setImage(UIImage(named: "bookmark2.png"), for: .normal)
        } else {
            bookMarked = false
            bookmarkButton.setImage(UIImage(named: "bookmark.png"), for: .normal)
        }
        
        popularNewsTitle.text = title
        popularNewsDescription.text = description
        popularNewsSource.text = source
        popularNewsSource.layer.cornerRadius = 5
        popularNewsSource.layer.masksToBounds = true
        if let imageUrlString = imageUrlString, let url = URL(string: imageUrlString) {
            getNewsImage(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.popularNewsImageView.image = UIImage(data: data)
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
