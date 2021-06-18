//
//  NewsViewController.swift
//  StocksViewer
//
//  Created by Kevin Huang on 18/06/21.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var newsModelArray = [CryptoNewsModel]()
    private var viewModel : NewsViewModel
    
    init(with viewModel: NewsViewModel) {
        self.viewModel = viewModel
        self.newsModelArray = [CryptoNewsModel]()
        super.init(nibName: "NewsViewController", bundle: nil)
        
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.nib, forCellReuseIdentifier: NewsTableViewCell.cellIdentifier)
        tableView.separatorColor = .black
        viewModel.onViewDidLoad()
        
    }
}

extension NewsViewController: NewsViewModelDelegate {
    func reloadTableWith(newsModelArray: [CryptoNewsModel]?) {
        guard let newsModelArray = newsModelArray else {
            return
        }
        self.newsModelArray = newsModelArray
        tableView.reloadData()
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.cellIdentifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configureViewWith(newsModel: newsModelArray[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
