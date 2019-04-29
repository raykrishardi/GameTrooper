//
//  TopGame.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 18/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Class that represents top game (out now and upcoming)
class TopGame {
    
    // Constant that represents the unique key of a particular top game stored in firebase database
    let key: String
    
    // Constant that represents the top game title
    let title: String
    
    // Constant that represents the url to the top game
    let url: String
    
    // Constant that represents the url to the top game image
    let urlToImage: String
    
    // Constant that represents the top game rating (0-5 star rating)
    let rating: Int?
    
    // Constant that represents the top game available platform(s) (i.e. PC, PlayStation 4, etc)
    let platform: String
    
    // 2-parameter constructor that initialises the top game object with the appropriate values
    init(initKey: String, snapshotValue: NSDictionary) {
        key = initKey

        // Initialise the title using the snapshot's value dictionary key "title" and convert the value as string
        title = snapshotValue["title"] as! String
        
        // Initialise the url using the snapshot's value dictionary key "url" and convert the value as string
        url = snapshotValue["url"] as! String
        
        // Initialise the urlToImage using the snapshot's value dictionary key "urlToImage" and check whether the value can be converted to string or not
        // If the value for key "urlToImage" can be converted to string then assign the value to the urlToImage
        // If the value for key "urlToImage" can NOT be converted to string (i.e. nil) then assign the urlToImage with "null"
        // In this case, default value "null" is given because the value for key "urlToImage" can be nil
        urlToImage = snapshotValue["urlToImage"] as? String ?? "null"
        
        // Initialise the rating using the snapshot's value dictionary key "rating" and convert the value as integer
        rating = snapshotValue["rating"] as? Int
        
        // Initialise the platform using the snapshot's value dictionary key "platform" and convert the value as string
        platform = snapshotValue["platform"] as! String
        
    }
    
}

