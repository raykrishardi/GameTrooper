//
//  GameStoresTableViewCell.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 7/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import UIKit

// Class that represents the gameStoresCell in gameStoresTableView
class GameStoresTableViewCell: UITableViewCell {

    // Get references to the labels and image view in gameStoresCell
    @IBOutlet var mapPinImageView: UIImageView!
    @IBOutlet var gameStoreNameLabel: UILabel!
    @IBOutlet var gameStoreAddressLabel: UILabel!
    
    
    //-----------------------------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //-----------------------------------------------------------------

}
