//
//  NewsTableViewCell.swift
//  StocksViewer
//
//  Created by Kevin Huang on 18/06/21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    static public let cellIdentifier = "NewsTableViewCell"
    
    static var nib: UINib {
        return UINib.init(nibName: NewsTableViewCell.cellIdentifier, bundle: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text = nil
        titleLabel.text = nil
        bodyLabel.text = nil
    }
    
    //MARK: - Public Method
    func configureViewWith(newsModel: CryptoNewsModel) {
        configureView()
        sourceLabel.text = newsModel.source_info_name
        titleLabel.text = newsModel.title
        bodyLabel.text = newsModel.body
    }
    
    //MARK: - Private Method
    private func configureView() {
        sourceLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        sourceLabel.textColor = .gray
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        bodyLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
}
