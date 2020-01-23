//
//  CoffeeShopItemTableViewCell.swift
//  SNInterview
//
//  Created by Mingjun on 1/21/20.
//  Copyright © 2020 ServiceNow. All rights reserved.
//

import UIKit

class CoffeeShopItemTableViewCell: UITableViewCell {
    static let id = "CoffeeShopItemTableViewCell"
    
    @IBOutlet weak var itemView: CoffeeShopItemView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
