//
//  GameStoreAnnotation.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 8/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import Foundation
import MapKit
import FirebaseDatabase

// Class that represents game store annotation for the gameStoresMapView
class GameStoreAnnotation: NSObject, MKAnnotation {
    
    // Constant that represents the unique key of a particular game store annotation stored in firebase database
    let key: String
    
    // Variable that represents the game store annotation title (i.e. game store name)
    var title: String?
    
    // Variable that represents the game store annotation subtitle (i.e. game store address)
    var subtitle: String?
    
    // Variable that represents the game store annotation coordinate (i.e. game store latitude and longitude)
    var coordinate: CLLocationCoordinate2D
    
    // Constant that represents the firebase database reference to a particular game store annotation
    let ref: FIRDatabaseReference?
    
    // 5-parameter constructor that initialises the game store annotation object with the appropriate values 
    init(initKey: String, initTitle: String, initSubtitle: String, initLatitude: Double, initLongitude: Double) {
        key = initKey
        title = initTitle
        subtitle = initSubtitle
        
        // Create a location coordinate for the game store annotation
        coordinate = CLLocationCoordinate2D()
        coordinate.latitude = initLatitude // Specify the latitude
        coordinate.longitude = initLongitude // Specify the longitude
        
        ref = nil // No reference to the firebase data snapshot's reference
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                          https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
    //                                                              By:
    //                                                        "Attila Hegedus"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // 1-parameter constructor that initialises the game store annotation object with the appropriate values based on the given firebase data snapshot
    init(snapshot: FIRDataSnapshot) {
        
        // Initialise the key based on the given firebase data snapshot's key
        key = snapshot.key
        
        // Constant that represents the firebase data snapshot's value as a dictionary
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // Initialise the title using the snapshot's value dictionary key "title" and convert the value as string
        title = snapshotValue["title"] as? String
        
        // Initialise the subtitle using the snapshot's value dictionary key "subtitle" and convert the value as string
        subtitle = snapshotValue["subtitle"] as? String
        
        // Create a location coordinate for the game store annotation
        coordinate = CLLocationCoordinate2D()
        
        // Specify the latitude using the snapshot's value dictionary key "latitude" as degrees
        coordinate.latitude = snapshotValue["latitude"] as! CLLocationDegrees
        
        // Specify the longitude using the snapshot's value dictionary key "longitude" as degrees
        coordinate.longitude = snapshotValue["longitude"] as! CLLocationDegrees
        
        // Initialise the ref based on the given firebase data snapshot's reference
        ref = snapshot.ref
    }
    
    // Function that returns a number of game store annotation details as key-value pairs
    // Used to add value for a particular key of a particular game store annotation in firebase database
    func toAnyObject() -> Any {
        return [
            "title": title!,
            "subtitle": subtitle!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude
        ]
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    
}
