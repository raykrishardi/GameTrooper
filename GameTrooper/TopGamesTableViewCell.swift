//
//  TopGamesTableViewCell.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 18/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import UIKit
import Cosmos

// Class that represents the topGamesCell in topGamesTableView
class TopGamesTableViewCell: UITableViewCell {
    
    // Get references to the labels, image view, and cosmos view in topGamesCell
    @IBOutlet var topGamesNumberLabel: UILabel!
    @IBOutlet var topGamesImageView: UIImageView!
    @IBOutlet var topGamesNameLabel: UILabel!
    @IBOutlet var starRating: CosmosView!
    @IBOutlet var platformLabel: UILabel!
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                                              https://github.com/marketplacer/Cosmos
    //                                                              By:
    //                                                         "marketplacer"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that setups the cosmos view (i.e. starRating) with the appropriate configurations:
    // 1. Disable touch interaction to the star rating (i.e. only display the star rating)
    // 2. Account for half filled stars (e.g. 2.5 star rating)
    func setupStarRating() {
        starRating.settings.updateOnTouch = false
        starRating.settings.fillMode = .half
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    
    //-----------------------------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Setup the star rating with the appropriate configurations
        setupStarRating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //-----------------------------------------------------------------
    
}
