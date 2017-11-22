//
//  TableViewCell.swift
//  MakeInventory
//
//  Created by Erik Perez on 11/14/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var profileImage:UIImageView!
    var inventory: Inventory!
    var indexPath: IndexPath!
    weak var delegate: stackDelegate?
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton){
        delegate?.updateFavorite(self.inventory, self.indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
protocol stackDelegate: class{
    func updateFavorite(_ inventory: Inventory, _ indexPath: IndexPath)
}
