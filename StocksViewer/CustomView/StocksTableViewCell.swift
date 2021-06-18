//
//  StocksTableViewCell.swift
//  StocksViewer
//
//  Created by Kevin Huang on 17/06/21.
//

import UIKit

class StocksTableViewCell: UITableViewCell {
    @IBOutlet weak var shortNameLabel: UILabel!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceChangeContainerView: UIView!
    static public let cellIdentifier = "StocksTableViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shortNameLabel.text = nil
        fullNameLabel.text = nil
        priceLabel.text = nil
        priceChangeLabel.text = nil
    }
    
    static var nib: UINib {
        return UINib.init(nibName: StocksTableViewCell.cellIdentifier, bundle: nil)
    }
    
    //MARK: - Public Method
    func configure(with model: CryptoModel) {
        configureView()
        
        shortNameLabel.text = model.shortName
        fullNameLabel.text = model.fullName
        priceLabel.text = model.price_usd
        priceChangeLabel.text = "\(model.change24Hour ?? "N/A")(\(model.changePct24Hour ?? "N/A")%)"
        if let change = model.changePct24Hour {
            if change.contains("-") {
                priceChangeContainerView.backgroundColor = .red
            }
            else {
                priceChangeContainerView.backgroundColor = .green
            }
        }
    }
    
    //MARK: - Private Method
    private func configureView() {
        shortNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        fullNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        fullNameLabel.textColor = .gray
        priceLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        priceChangeLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        priceChangeLabel.textColor = .white
        priceChangeContainerView.backgroundColor = .green
        priceChangeContainerView.layer.masksToBounds = true
        priceChangeContainerView.layer.cornerRadius = 6
    }
}
