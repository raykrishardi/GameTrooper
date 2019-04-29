//
//  GameNewsTableViewCell.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 16/4/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import UIKit

// Class that represents the gameNewsCell in newsTableView
class GameNewsTableViewCell: UITableViewCell {

    // Get references to the labels and image view in gameNewsCell
    @IBOutlet var newsSourceLabel: UILabel!
    @IBOutlet var newsTimeLabel: UILabel!
    @IBOutlet var newsTitleLabel: UILabel!
    @IBOutlet var newsImageView: UIImageView!
    
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
