//
//  News.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 30/4/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Class that represents news
class News {
    
    // Constant that represents the unique key of a particular news stored in firebase database
    let key: String
    
    // Constant that represents the news source (i.e. ign/polygon)
    let source: String
    
    // Constant that represents the author of the news
    let author: String
    
    // Constant that represents the news title
    let title: String
    
    // Constant that represents the url to the news
    let url: String
    
    // Constant that represents the url to the news image
    let urlToImage: String
    
    // Constant that represents the date and time the news was published in ISO8601 format
    let publishedAt: String
    
    // Constant that represents the firebase database reference to a particular news
    let ref: FIRDatabaseReference?
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                          https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
    //                                                              By:
    //                                                        "Attila Hegedus"
    //---------------------------------------------------------------------------------------------------------------------------

    // 1-parameter constructor that initialises the news object with the appropriate values based on the given firebase data snapshot
    init(snapshot: FIRDataSnapshot) {
        
        // Initialise the key based on the given firebase data snapshot's key
        key = snapshot.key
        
        // Constant that represents the firebase data snapshot's value as a dictionary
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // Initialise the source using the snapshot's value dictionary key "source" and convert the value as string
        source = snapshotValue["source"] as! String
        
        // Initialise the author using the snapshot's value dictionary key "author" and check whether the value can be converted to string or not
        // If the value for key "author" can be converted to string then assign the value to the author
        // If the value for key "author" can NOT be converted to string (i.e. nil) then assign the author with "null"
        // In this case, default value "null" is given because the value for key "author" can be nil
        author = snapshotValue["author"] as? String ?? "null"
        
        // Initialise the title using the snapshot's value dictionary key "title" and convert the value as string
        title = snapshotValue["title"] as! String
        
        // Initialise the url using the snapshot's value dictionary key "url" and convert the value as string
        url = snapshotValue["url"] as! String
        
        // Initialise the urlToImage using the snapshot's value dictionary key "urlToImage" and check whether the value can be converted to string or not
        // If the value for key "urlToImage" can be converted to string then assign the value to the urlToImage
        // If the value for key "urlToImage" can NOT be converted to string (i.e. nil) then assign the urlToImage with "null"
        // In this case, default value "null" is given because the value for key "urlToImage" can be nil
        urlToImage = snapshotValue["urlToImage"] as? String ?? "null"
        
        // Initialise the publishedAt using the snapshot's value dictionary key "publishedAt" and convert the value as string
        publishedAt = snapshotValue["publishedAt"] as! String
        
        // Initialise the ref based on the given firebase data snapshot's reference
        ref = snapshot.ref
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                          https://stackoverflow.com/questions/36861732/swift-convert-string-to-date
    //                                                              By:
    //                                                            "vadian"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that returns the value of publishedAt in ISO8601 date format
    // Conversion to ISO8601 date format is required to display the date published as the corresponding relative time format for the game news section
    func getFormattedDate() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        let datePublished = dateFormatter.date(from: self.publishedAt)
        
        return datePublished!
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    
}
