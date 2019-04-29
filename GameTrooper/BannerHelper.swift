//
//  BannerHelper.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 29/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import Foundation
import BRYXBanner

// Class that helps to setup and display the "No Internet Connection" banner
class BannerHelper {

    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                                              https://github.com/bryx-inc/BRYXBanner
    //                                                              By:
    //                                                          "bryx-inc"
    //---------------------------------------------------------------------------------------------------------------------------

    // Function that setups and displays the "No Internet Connection" banner with the appropriate configurations:
    // 1. Ensure that the banner's title is "No Internet Connection", use the appropriate image (Disconnected image), and use the lightgray background color
    // 2. Ensure that the banner dismisses on tap
    // 3. Display the banner for 2 seconds then dismiss the banner
    static func displayNoInternetConnectionBanner() {
        let banner = Banner(title: "No Internet Connection", subtitle: "", image: #imageLiteral(resourceName: "Disconnected"), backgroundColor: UIColor(red:211.0/255.0, green:211.0/255.0, blue:211.0/255.0, alpha:1.000))
        banner.dismissesOnTap = true
        banner.show(duration: 2.0)
    }

    //---------------------------------------------------------------------------------------------------------------------------

}
