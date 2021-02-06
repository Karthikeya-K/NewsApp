//
//  DetailViewController.swift
//  NewsApp
//
//  Created by K Karthikeya on 06/02/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    var webView = WKWebView(frame: .zero)
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = urlString
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        self.navigationItem.leftItemsSupplementBackButton = true
        webView.frame.size = CGSize(width: contentView.bounds.width, height: contentView.bounds.height)
        contentView.addSubview(webView)
        if let urlString = urlString {
            let myURL = URL(string: urlString)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    }

}
