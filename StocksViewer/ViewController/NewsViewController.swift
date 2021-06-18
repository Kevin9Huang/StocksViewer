//
//  NewsViewController.swift
//  StocksViewer
//
//  Created by Kevin Huang on 18/06/21.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var newsModel = [CryptoNewsModel]()
    
    public func initWithNewsModel(newsModel: [CryptoNewsModel]) {
        self.newsModel = newsModel
    }
    
    //MARK- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
