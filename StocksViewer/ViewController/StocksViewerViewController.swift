//
//  StocksViewerViewController.swift
//  StocksViewer
//
//  Created by Kevin Huang on 17/06/21.
//

import UIKit

class StocksViewerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var viewModel : StocksViewerViewModel
    private var models : [CryptoModel]
    private let refreshControl = UIRefreshControl()
    
    init(with viewModel: StocksViewerViewModel) {
        self.viewModel = viewModel
        self.models = [CryptoModel]()
        super.init(nibName: "StocksViewerViewController", bundle: nil)
        
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Toplists"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StocksTableViewCell.nib, forCellReuseIdentifier: StocksTableViewCell.cellIdentifier)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        viewModel.onViewDidLoad()
    }
    
    @objc func pullToRefresh() {
        viewModel.pulledToRefresh()
    }
    
    deinit {
        viewModel.onDeinit()
    }
    
}

extension StocksViewerViewController : StocksViewerViewModelDelegate {
    func reloadTableWith(models: [CryptoModel]?) {
        guard let models = models else {
            return
        }
        self.models = models
        tableView.reloadData()
    }
    
    func stopRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func presentNewsModelVC(with vm: NewsViewModel) {
        let newsVC = NewsViewController(with: vm)
        present(newsVC, animated: true, completion: nil)
    }
    
    func showLoadingIndicator(isShow: Bool) {
        DispatchQueue.main.async {
            if isShow {
                self.spinner.startAnimating()
                self.spinner.isHidden = false
                
            } else {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
            }
        }
    }
}

extension StocksViewerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StocksTableViewCell.cellIdentifier, for: indexPath) as? StocksTableViewCell else {
            fatalError()
        }
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.cellTapped(at: indexPath.row)
    }
    
    func showAlertWith(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message:
                                                        message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            
            self.present(alertController, animated: true) {
                self.stopRefreshControl()
            }
        }
    }
}
