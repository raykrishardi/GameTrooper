//
//  ReachabilityHelper.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 1/6/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import Foundation
import Reachability

// Class that helps to setup and manage reachability notification (i.e. check for internet connection)
class ReachabilityHelper {
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                                        https://github.com/ashleymills/Reachability.swift
    //                                                              By:
    //                                                         "ashleymills"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Constant that represents the device's network status/state
    static let reachability = Reachability()!
    
    // Function that setups the reachability notification
    // 1. Add an observer that monitors the device's network state
    // 2. Start the notifier to get the current status of the device's network state
    static func setupReachabilityNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    // Function that is called when there is a change in the device's network state 
    // 1. Check for internet connection each time the network state changes
    @objc static func reachabilityChanged(note: NSNotification) {
        ReachabilityHelper.checkForInternetConnection()
    }

    // Function that checks for the device's internet connection
    // 1. If there is no internet connection then display "No Internet Connection" banner
    static func checkForInternetConnection() {
        if reachability.connection == .none {
            print("Network not reachable")
            BannerHelper.displayNoInternetConnectionBanner()
        }
    }

    //---------------------------------------------------------------------------------------------------------------------------

}
