//
//  StocksViewerViewController.swift
//  StocksViewer
//
//  Created by Kevin Huang on 17/06/21.
//

import UIKit

class StocksViewerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel : StocksViewerViewModel
    private var models : [CryptoModel]
    
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
        
        viewModel.onViewDidLoad()
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
    
    func presentNewsModelWith(news: [CryptoNewsModel]) {
        
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
        let model = models[indexPath.row]
        print("Model Clicked: \(model.fullName ?? "N/A")")
    }
}
