//
//  AboutViewController.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 30/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import UIKit

// Class that represents the controller for the about screen
class AboutViewController: UIViewController, UITabBarControllerDelegate {
    
    // Variable that represents the previously selected view controller when the user navigates through different view controllers
    // Used to apply the appropriate "scroll-to-top" gesture when the user taps on the "About" tab bar item
    var previousViewController: UIViewController?
    
    // Get reference to the text view
    @IBOutlet var aboutTextView: UITextView!
    
    // Variable that represents an array of API details used in this project
    var apiArray: [String] = []
    
    // Variable that represents an array of icons and images references used in this project
    var iconsAndImagesArray: [String] = []
    
    // Variable that represents an array of bibliography entries used in this project
    var bibliographyArray: [String] = []
    
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                      https://stackoverflow.com/questions/10792884/uitextview-text-not-starting-from-top
    //                                                              By:
    //                                                          "Tung Fam"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that will be executed when the view controller's view has just laid out its subviews
    // 1. Ensure that the about text view's text starts from the top during initial display (i.e. when the user navigates to the about screen for the first time (when the view has been loaded into the memory for the first time))
    override func viewDidLayoutSubviews() {
        aboutTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------

    
    // Function that will be executed when the view is about to be added to the view hierarchy (i.e. about to appear on the screen)
    // 1. Assign the appropriate delegate for the tab bar controller to ensure that the "scroll-to-top" gesture works properly
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.delegate = self
    }
    
    // Function that will be executed when the view has been loaded into the memory
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //-----------------------------------------------------------------------------------------------------------------------
        //                                                            Source:
        //   https://stackoverflow.com/questions/36467985/how-to-append-attributed-text-string-with-attributed-string-in-swift
        //                                                              By:
        //                                                            "glace"
        //-----------------------------------------------------------------------------------------------------------------------

        // Constant that represents the final attributed string (combination of multiple attributed string) to be displayed to the aboutTextView.attributedText
        // This constant will be used to store all text (attributed strings) in the about screen
        // Note: Normal string will need to be converted to attributed string by using the getAttributedString() function described in the "StringExtension.swift" with the appropriate parameters
        let finalAttributedString = NSMutableAttributedString()
        
        //-----------------------------------------------------------------------------------------------------------------------
        
        
        // About screen title
        let title = "GameTrooper \nRay Krishardi Layadi - 26445549 \n\n"
        finalAttributedString.append(title.getAttributedString(bold: true, alignment: "center"))
        
        
        // Section 1 -> Introduction
        let section1 = "Introduction\n"
        finalAttributedString.append(section1.getAttributedString(bold: true, alignment: "center"))
        let section1Description = "Game Trooper is an interactive mobile application that delivers news about games from variety of game news websites. This application plans to achieve three main objectives which revolve around user experience and entertainment: \n\nThe first main objective of this application is to allow users to stay up-to-date with the current popular new games as well as the new upcoming games by providing several articles and news from various gamers’ trusted websites. Top charts of these current popular and upcoming games would also be provided by this application which would ease users in finding trending games for their beloved gaming platforms. \n\nThe second main objective of this application is to assist users in finding local game stores in Melbourne to help them buy their anticipated games in a reliable and efficient manner. \n\nThe third main objective of this application is to provide entertainment to users by allowing them to play a fun True or False quiz game. Questions are prepared based on popular game titles from various game genres. \n\nIn addition to the three main objectives of this application, there are additional features that enhance the user experience when using this application. These include speech recognition feature when searching for a game store and support for multiple gestures.\n\n"
        finalAttributedString.append(section1Description.getAttributedString(alignment: "justified"))
        
        
        // Section 2 -> Third-party Libraries (Podfile)
        let section2 = "Third-party Libraries (Podfile)\n"
        finalAttributedString.append(section2.getAttributedString(bold: true, alignment: "center"))
        
        let section2Item1 = "1. Firebase Core and Database (Apache Licensed)\n"
        let section2Item1LicenseNotice = "Apache License Version 2.0, January 2004 http://www.apache.org/licenses/LICENSE-2.0\n\n"
        finalAttributedString.append(section2Item1.getAttributedString())
        finalAttributedString.append(section2Item1LicenseNotice.getAttributedString())
        
        let section2Item2 = "2. Alamofire v4.2.0 (MIT Licensed)\n"
        let section2Item2Copyright = "Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)\n\n"
        finalAttributedString.append(section2Item2.getAttributedString())
        finalAttributedString.append(section2Item2Copyright.getAttributedString())
        
        let section2Item3 = "3. SDWebImage v3.8 (MIT Licensed)\n"
        let section2Item3Copyright = "Copyright (c) 2009-2017 Olivier Poitrey rs@dailymotion.com\n\n"
        finalAttributedString.append(section2Item3.getAttributedString())
        finalAttributedString.append(section2Item3Copyright.getAttributedString())
        
        let section2Item4 = "4. Cosmos v9.0 (MIT Licensed)\n"
        let section2Item4Copyright = "Copyright (c) 2015 Marketplacer\n\n"
        finalAttributedString.append(section2Item4.getAttributedString())
        finalAttributedString.append(section2Item4Copyright.getAttributedString())
        
        let section2Item5 = "5. ReachabilitySwift v3 (MIT Licensed)\n"
        let section2Item5Copyright = "Copyright (c) 2016 Ashley Mills\n\n"
        finalAttributedString.append(section2Item5.getAttributedString())
        finalAttributedString.append(section2Item5Copyright.getAttributedString())
        
        let section2Item6 = "6. BRYXBanner (MIT Licensed)\n"
        let section2Item6Copyright = "Copyright (c) 2015 Harlan Haskins <harlan@harlanhaskins.com>\n\n"
        finalAttributedString.append(section2Item6.getAttributedString())
        finalAttributedString.append(section2Item6Copyright.getAttributedString())
        
        
        // Section 3 -> API
        let section3 = "API\n"
        finalAttributedString.append(section3.getAttributedString(bold: true, alignment: "center"))
        
        populateApiArray()
        for item in apiArray {
            finalAttributedString.append(item.getAttributedString())
        }
        
        
        // Section 4 -> Icons and Images
        let section4 = "Icons and Images\n"
        finalAttributedString.append(section4.getAttributedString(bold: true, alignment: "center"))
        
        populateIconsAndImagesArray()
        for item in iconsAndImagesArray {
            finalAttributedString.append(item.getAttributedString())
        }
        
        
        // Section 5 -> Quiz Questions
        let section5 = "Quiz Questions\n"
        finalAttributedString.append(section5.getAttributedString(bold: true, alignment: "center"))
        
        let section5Item1 = "1. https://www.sporcle.com/games/bazmerelda/true-or-false-gaming\n\n"
        finalAttributedString.append(section5Item1.getAttributedString())
        
        
        // Section 6 -> Bibliography
        let section6 = "Bibliography\n"
        finalAttributedString.append(section6.getAttributedString(bold: true, alignment: "center"))
        
        populateBibliographyArray()
        for item in bibliographyArray {
            finalAttributedString.append(item.getAttributedString())
        }
        
        // Assign the about text view's attributed text with the final attributed string
        aboutTextView.attributedText = finalAttributedString
        
    }
    
    // Function that populates the apiArray with API details used in this project
    func populateApiArray() {
        apiArray = [
            "1. Firebase API (Core and Database)\nhttps://firebase.google.com\n\n",
            "2. News API (Gaming news from IGN and Polygon)\nhttps://newsapi.org\n\n",
            "3. Giant Bomb API (Top games out now and upcoming)\nhttps://www.giantbomb.com/api/\n\n",
            "4. Google Places API (Nearby game stores)\nhttps://developers.google.com/places/\n\n"
        ]
    }
    
    // Function that populates the iconsAndImagesArray with icons and images references used in this project
    func populateIconsAndImagesArray() {
        iconsAndImagesArray = [
            "1. placeholder-image \nhttp://hdimages.org/wp-content/uploads/2017/03/placeholder-image10.jpg\n\n",
            "2. Quiz Background \nhttp://static.simpledesktops.com/uploads/desktops/2014/05/16/Pixelmoon_by_ArMaNDJ.png.625x385_q100.png\n\n",
            "3. The rest of the icons -> https://icons8.com\nResized using -> https://makeappicon.com\n\n"
        ]
    }
    
    // Function that populates the bibliographyArray with bibliography entries used in this project
    func populateBibliographyArray() {
        bibliographyArray = [
        "-Add Firebase to your iOS Project  |  Firebase. (2017). Firebase. Retrieved 30 May 2017, from https://firebase.google.com/docs/ios/setup\n\n",
        "-Alamofire/Alamofire. (2017). GitHub. Retrieved 30 May 2017, from https://github.com/Alamofire/Alamofire\n\n",
        "-Haskins, H., & Binsz, A. (2017). bryx-inc/BRYXBanner. GitHub. Retrieved 30 May 2017, from https://github.com/bryx-inc/BRYXBanner\n\n",
        "-Installation & Setup on iOS  |  Firebase. (2017). Firebase. Retrieved 30 May 2017, from https://firebase.google.com/docs/database/ios/start\n\n",
        "-marketplacer/Cosmos. (2017). GitHub. Retrieved 30 May 2017, from https://github.com/marketplacer/Cosmos\n\n",
        "-Mills, A. (2017). ashleymills/Reachability.swift. GitHub. Retrieved 30 May 2017, from https://github.com/ashleymills/Reachability.swift\n\n",
        "-Poitrey, O. (2017). rs/SDWebImage. GitHub. Retrieved 30 May 2017, from https://github.com/rs/SDWebImage\n\n",
        "-Cezar. (2016). swift for loop: for index, element in array?. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/24028421/swift-for-loop-for-index-element-in-array\n\n",
        "-Dabus, L. (2016). Swift iOS doesRelativeDateFormatting have different values besides \"Today\" and \"Yesterday\"?. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/27310883/swift-ios-doesrelativedateformatting-have-different-values-besides-today-and\n\n",
        "-Davidson, J. (2016). Loading and Caching Images! (SDWebImage : Swift 3 in Xcode 8). Retrieved from https://www.youtube.com/watch?v=XPAaxF0rQy0\n\n",
        "-Dravidian. (2017). Firebase app not being configured. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/40322481/firebase-app-not-being-configured/40322841\n\n",
        "-drewag. (2014). Providing a default value for an Optional in Swift?. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/24099985/providing-a-default-value-for-an-optional-in-swift/25193247\n\n",
        "-Error, C. (2016). How to Center a Map on User Location IOS 9 SWIFT. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/35705649/how-to-center-a-map-on-user-location-ios-9-swift\n\n",
        "-Green, C. (2012). What is the proper way to use the radius parameter in the Google Places API?. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/10615275/what-is-the-proper-way-to-use-the-radius-parameter-in-the-google-places-api\n\n",
        "-How to hide first section header in UITableView (grouped style). (2016). Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/19056428/how-to-hide-first-section-header-in-uitableview-grouped-style\n\n",
        "-Jay. (2016). In Firebase, how can I query the most recent 10 child nodes?. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/36589452/in-firebase-how-can-i-query-the-most-recent-10-child-nodes\n\n",
        "-kaka. (2011). How can i add a activity indicator below the UITableView?. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/7953344/how-can-i-add-a-activity-indicator-below-the-uitableview\n\n",
        "-Memon, S. (2016). UITableView Pagination - Bottom Refresh to Load New Data in Swift. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/35495750/uitableview-pagination-bottom-refresh-to-load-new-data-in-swift\n\n",
        "-mokagio. (2015). How to remove the unexpected padding on the header of a UITableView. Mokagio.github.io. Retrieved 30 May 2017, from http://mokagio.github.io/tech-journal/2015/01/23/ios-unexpected-table-view-header-padding.html\n\n",
        "-paulthenerd, & Oza, M. (2015). Why does uitableview cell remain highlighted?. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/1840614/why-does-uitableview-cell-remain-highlighted\n\n",
        "-Puffelen, F. (2016). Can I get the nth item of a firebase \"query\"?. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/35079061/can-i-get-the-nth-item-of-a-firebase-query\n\n",
        "-Reilly, M. (2017). Jittery Search Bar Cancel / End Editing Animation. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/42492539/jittery-search-bar-cancel-end-editing-animation\n\n",
        "-Swift convert string to date. (2016). Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/36861732/swift-convert-string-to-date\n\n",
        "-Coder1000. (2016). How to make UILabel text appear with \"...\" at the end when text is longer than label's width. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/37091096/how-to-make-uilabel-text-appear-with-at-the-end-when-text-is-longer-than-l\n\n",
        "-The Swift Guy. (2016). How To Display An Activity Indicator In xCode 8 (Swift 3.0). Retrieved from https://www.youtube.com/watch?v=dLfOdObZW7k\n\n",
        "-user529758. (2013). Add activity indicator to web view. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/11334247/add-activity-indicator-to-web-view\n\n",
        "-Vuksanovic, M. (2016). Advanced queries in Firebase – Marko Vuksanovic – Medium. Medium. Retrieved 30 May 2017, from https://medium.com/@mvuksano/advanced-queries-in-firebase-a50f563179dd\n\n",
        "-bazmerelda. True or False: Gaming. Sporcle.com. Retrieved 30 May 2017, from https://www.sporcle.com/games/bazmerelda/true-or-false-gaming\n\n",
        "-catlan, & penatheboss. (2016). UITableView - scroll to the top. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/724892/uitableview-scroll-to-the-top\n\n",
        "-Edrisian, S. (2016). Building a Speech-to-Text App Using Speech Framework in iOS 10. Appcoda.com. Retrieved 30 May 2017, from http://www.appcoda.com/siri-speech-framework/\n\n",
        "-Hegedus, A. (2016). Firebase Tutorial: Getting Started. Ray Wenderlich. Retrieved 30 May 2017, from https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2\n\n",
        "-Huerkamp, J. (2016). Speech Recognition with SFSpeechRecognizer in iOS 10. Captech Consulting, Inc.. Retrieved 30 May 2017, from https://www.captechconsulting.com/blogs/ios-10-blog-series-speech-recognition\n\n",
        "-Jacobs, B. (2016). How to Add Pull-to-Refresh to a Table View or Collection View - Cocoacasts. Cocoacasts. Retrieved 30 May 2017, from https://cocoacasts.com/how-to-add-pull-to-refresh-to-a-table-view-or-collection-view/\n\n",
        "-Kargopolov, S. (2015). UISegmentedControl + UITableView example in Swift.. Retrieved from https://www.youtube.com/watch?v=ABVLSF3Vqdg\n\n",
        "-Paul. How to request a user's location only once using requestLocation - free Swift 3 example code. Hackingwithswift.com. Retrieved 30 May 2017, from https://www.hackingwithswift.com/example-code/location/how-to-request-a-users-location-only-once-using-requestlocation\n\n",
        "-Paul. How to scale, stretch, move and rotate UIViews using CGAffineTransform - free Swift 3 example code. Hackingwithswift.com. Retrieved 30 May 2017, from https://www.hackingwithswift.com/example-code/uikit/how-to-scale-stretch-move-and-rotate-uiviews-using-cgaffinetransform\n\n",
        "-RandallShanePhD. (2017). Exception with AVFoundation using Speech framework | Apple Developer Forums. Forums.developer.apple.com. Retrieved 30 May 2017, from https://forums.developer.apple.com/thread/51935\n\n",
        "-Scooter. (2016). Enable zooming/pinch on UIWebView. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/7134576/enable-zooming-pinch-on-uiwebview\n\n",
        "-Varghese, A., & Skledar, D. (2016). How to use pull to refresh in Swift?. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/24475792/how-to-use-pull-to-refresh-in-swift\n\n",
        "-Conway, J. (2015). Swift Subarrays: Array and ArraySlice. Blog.stablekernel.com. Retrieved 1 June 2017, from http://blog.stablekernel.com/swift-subarrays-array-and-arrayslice\n\n",
        "-mluisbrown. (2016). How to return first 5 objects of Array in Swift?. Stackoverflow.com. Retrieved 1 June 2017, from https://stackoverflow.com/questions/28527797/how-to-return-first-5-objects-of-array-in-swift/32490675#32490675\n\n",
        "-Offline Capabilities on iOS  |  Firebase. Firebase. Retrieved 1 June 2017, from https://firebase.google.com/docs/database/ios/offline-capabilities\n\n",
        "-Wilkinson, O. (2016). Scroll to top UITableView with double tap on UITabBarItem. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/37124110/scroll-to-top-uitableview-with-double-tap-on-uitabbaritem\n\n",
        "-Fam, T. (2017). UITextView text not starting from top. Stackoverflow.com. Retrieved 30 May 2017, from https://stackoverflow.com/questions/10792884/uitextview-text-not-starting-from-top\n"
        ]
    }
    
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //          https://stackoverflow.com/questions/37124110/scroll-to-top-uitableview-with-double-tap-on-uitabbaritem
    //                                                              By:
    //                                                       "Olivier Wilkinson"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that will be executed when a particular tab bar item is tapped/selected (e.g. the user navigates to "About" section from "Top Games" section)
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        // Check the previous and current/selected view controller
        // Checking of previous and current view controller is required to prevent scrolling to the top of the table view when the user is currently in a different view controller and navigates back to the intended view controller
        // i.e. Prevent scrolling to the top when the user navigates to "About" section from "Top Games" section
        if self.previousViewController == viewController {
            
            // Make sure that reference to the about view controller can be obtained
            if let aboutViewController = viewController as? AboutViewController {
                
                // Check whether the aboutViewController is already loaded into the memory and whether it is currently visible or not (additional check)
                if aboutViewController.isViewLoaded && (aboutViewController.view.window != nil) {
                    // When aboutViewController is visible then allows the "scroll-to-top" gesture to the about text view
                    aboutTextView.setContentOffset(CGPoint.zero, animated: true)
                }
            }
        }
        
        // Assign the previous view controller as the current/selected view controller
        self.previousViewController = viewController
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
