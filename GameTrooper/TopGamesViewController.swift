//
//  TopGamesViewController.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 18/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage

// Class that represents the controller for the top games screen
class TopGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate {

    // Variable that represents the previously selected view controller when the user navigates through different view controllers
    // Used to apply the appropriate "scroll-to-top" gesture when the user taps on the "Top Games" tab bar item
    var previousViewController: UIViewController?
    
    // Get reference to the segmented control
    @IBOutlet var topGamesSegmentedControl: UISegmentedControl!
    
    // Get reference to the table view
    @IBOutlet var topGamesTableView: UITableView!
    
    // Variable that indicates whether the syncing of top games (fetchTopGames) from the firebase database has been completed or not
    var syncCompleted: Bool = false
    
    // Variable that represents an array of top games out now fetched from the firebase database
    var topGamesOutNowArray: [TopGame] = []
    
    // Variable that represents an array of upcoming top games fetched from the firebase database
    var topGamesUpcomingArray: [TopGame] = []
    
    // Variable that represents a reference to the "top-games" node in firebase database
    var topGamesRef: DatabaseReference!

    // Function that will be executed when there is a change in the segmented control value (i.e. the user navigates to "Out Now" section from "Upcoming" section and vice versa)
    @IBAction func topGamesSegmentedControlValueChanged() {
        //-----------------------------------------------------------------------------------------------------------------------
        //                                                            Source:
        //                          https://stackoverflow.com/questions/724892/uitableview-scroll-to-the-top
        //                                                              By:
        //                                                   "catlan" and "penatheboss"
        //-----------------------------------------------------------------------------------------------------------------------
        // Apply "scroll-to-top" gesture when there is a change in the segmented control value
        topGamesTableView.setContentOffset(CGPoint.zero, animated: true)
        //-----------------------------------------------------------------------------------------------------------------------
        topGamesTableView.reloadData() // Reload the top games table view
    }
    
    // Function that will be executed when the view is about to be added to the view hierarchy (i.e. about to appear on the screen)
    // 1. Assign the appropriate delegate for the tab bar controller to ensure that the "scroll-to-top" gesture works properly
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.delegate = self
    }
    
    // Function that will be executed when the view has been loaded into the memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check for the device's internet connection and display the "No Internet Connection" banner if there is no internet connection
        ReachabilityHelper.checkForInternetConnection()
        
        // Get a reference to the "top-games" node in firebase database and make sure that the firebase database is kept synced (i.e. sync local cached data with the data in firebase database)
        topGamesRef = Database.database().reference(withPath: "top-games")
        topGamesRef.keepSynced(true)
        
        // Setup and start the activity indicator view when the top games are about to be fetched from the firebase database
        ActivityIndicatorViewHelper.setupActivityIndicatorView(view: self.view)
        ActivityIndicatorViewHelper.startActivityIndicatorView()
        
        // Fetch top games out now and upcoming from the firebase database
        fetchTopGames()
        
        // Indicate that the syncing of top games (fetchTopGames) from the firebase database has been completed
        syncCompleted = true

    }
    
    // Function that fetches top games out now and upcoming from the firebase database
    func fetchTopGames(){
        
        // Fetch top games out now and upcoming from the firebase database
        topGamesRef.observeSingleEvent(of: .value, with: { snapshot in
            
            // Constant that represents top games as a dictionary
            let topGames = snapshot.value as! NSDictionary
            
            // Loop through all top games out now
            for (index, item) in (topGames["out-now"] as! NSArray).enumerated() {
                
                // Ignore index 0 as it contains NSNull (key starts from 1 to 10)
                if index >= 1 {
                    // Create top game object from the fetched top games out now and append the newly created top game object to the topGamesOutNowArray
                    let topGamesItem = TopGame(initKey: String(index), snapshotValue: item as! NSDictionary)
                    self.topGamesOutNowArray.append(topGamesItem)
                }

            }
            
            // Loop through all upcoming top games
            for (index, item) in (topGames["upcoming"] as! NSArray).enumerated() {

                // Ignore index 0 as it contains NSNull (key starts from 1 to 10)
                if index >= 1 {
                    // Create top game object from the fetched upcoming top games and append the newly created top game object to the topGamesUpcomingArray
                    let topGamesItem = TopGame(initKey: String(index), snapshotValue: item as! NSDictionary)
                    self.topGamesUpcomingArray.append(topGamesItem)
                }
                
            }
            
            // Stop the activity indicator view and reload the top games table view
            ActivityIndicatorViewHelper.stopActivityIndicatorView()
            self.topGamesTableView.reloadData()
            
        })
        
    }
    
    
    // Function that determines the number of sections in the table view
    // Section 0 -> list of top games (topGamesCell)
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Function that determines the number of rows in the top games section
    // If syncing of top games (fetchTopGames) from the firebase database has been completed then display the top games
    // If syncing of top games (fetchTopGames) from the firebase database has NOT been completed then display empty table view (no row)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if syncCompleted{
            return topGamesOutNowArray.count // Can also use the topGamesUpcomingArray.count as both returns 10 top games
        }
        else{
            return 0
        }
    }
    
    // Function that returns the topGamesCell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a reference to "TopGamesTableViewCell" using "topGamesCell" identifier
        let topGamesCell = tableView.dequeueReusableCell(withIdentifier: "topGamesCell", for: indexPath) as! TopGamesTableViewCell
        
        // Constant that represents the top game to be displayed
        let topGame: TopGame!
        
        // Check which top games section is active ("Out Now" or "Upcoming" section)
        // If "Out Now" section (index 0) is active then select top games from the topGamesOutNowArray
        // If "Upcoming" section (index 1) is active then select top games from the topGamesUpcomingArray
        if topGamesSegmentedControl.selectedSegmentIndex == 0 {
            topGame = self.topGamesOutNowArray[indexPath.row]
        }
        else {
            topGame = self.topGamesUpcomingArray[indexPath.row]
        }
        
        // Assign the number label text with the appropriate top game key attribute value (1-10)
        topGamesCell.topGamesNumberLabel.text = "\(topGame.key)."
        
        // Attempt to get valid url from the top game's urlToImage attribute value
        // Required because the value of urlToImage could be "null"
        if let topGameUrlToImage = URL(string: topGame.urlToImage){
            //-------------------------------------------------------------------------------------------------------------------
            //                                                            Source:
            //                                          https://www.youtube.com/watch?v=XPAaxF0rQy0
            //                                                              By:
            //                                                        "Jared Davidson"
            //-------------------------------------------------------------------------------------------------------------------

            // If the urlToImage attribute value is a valid url then set the appropriate image to the image view by using the given url (SDWebImage is used to download and set the image from the url)
            // If the urlToImage attribute value is NOT a valid url then set the default placeholder image to the image view
            // Options -> continue downloading the image if the app goes to background and enables progressive download
            topGamesCell.topGamesImageView.sd_setImage(with: topGameUrlToImage, placeholderImage: #imageLiteral(resourceName: "placeholder-image"))
            
            //-------------------------------------------------------------------------------------------------------------------
        }
        
        // Assign the name and platform label text with the appropriate top game attribute values
        topGamesCell.topGamesNameLabel.text = topGame.title
        topGamesCell.platformLabel.text = topGame.platform
        
        // Set the star rating based on the top game rating value
        // If the top game rating value is NOT nil then assign the appropriate star rating
        // If the top game rating value is nil then assign star rating of 0
        if topGame.rating != nil {
            // Explicit cast to double to account for half filled stars (e.g. 2.5 star rating)
            topGamesCell.starRating.rating = Double(topGame.rating!)
        }
        else {
            topGamesCell.starRating.rating = 0
        }
                
        return topGamesCell
    }
    

    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //          https://stackoverflow.com/questions/19056428/how-to-hide-first-section-header-in-uitableview-grouped-style
    //                                                              By:
    //                                                         "user3378170"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Hide padding on the header of the UITableView by setting the appropriate header height
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    // Hide padding on the footer of the UITableView by setting the appropriate footer height
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    //---------------------------------------------------------------------------------------------------------------------------

    // Function that will be executed when a particular row is selected
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Constant that represents the selected top game in a particular row
        let selectedTopGame: TopGame!
        
        // Check which top games section is active ("Out Now" or "Upcoming" section)
        // If "Out Now" section (index 0) is active then select top game from the topGamesOutNowArray
        // If "Upcoming" section (index 1) is active then select top game from the topGamesUpcomingArray
        if topGamesSegmentedControl.selectedSegmentIndex == 0 {
            selectedTopGame = self.topGamesOutNowArray[indexPath.row]
        }
        else {
            selectedTopGame = self.topGamesUpcomingArray[indexPath.row]
        }
        
        // Perform segue with the specified identifier and send the selected top game object
        performSegue(withIdentifier: "TopGamesDetailSegue", sender: selectedTopGame)
        
        // Deselect the selected row (i.e. remove highlighting from the selected row)
        topGamesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Prepare for segue function that will be executed when a particular segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If "TopGamesDetailSegue" is performed then pass the selected top game object in a particular row to the "TopGamesDetailViewController" selectedTopGame variable
        if segue.identifier == "TopGamesDetailSegue"{
            let destinationController: TopGamesDetailViewController = segue.destination as! TopGamesDetailViewController
            destinationController.selectedTopGame = sender as? TopGame
        }
    }
    
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //          https://stackoverflow.com/questions/37124110/scroll-to-top-uitableview-with-double-tap-on-uitabbaritem
    //                                                              By:
    //                                                       "Olivier Wilkinson"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that will be executed when a particular tab bar item is tapped/selected (e.g. the user navigates to "Top Games" section from "News" section)
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        // Check the previous and current/selected view controller
        // Checking of previous and current view controller is required to prevent scrolling to the top of the table view when the user is currently in a different view controller and navigates back to the intended view controller
        // i.e. Prevent scrolling to the top when the user navigates to "Top Games" section from "News" section
        if self.previousViewController == viewController {
            
            // Make sure that reference to the navigation controller and the top games view controller can be obtained
            if let topGamesNavigationController = viewController as? UINavigationController, let topGamesViewController = topGamesNavigationController.viewControllers.first as? TopGamesViewController {
                
                // Check whether the topGamesViewController is already loaded into the memory and whether it is currently visible or not
                // Used to prevent scrolling to the top when the user navigates from TopGamesDetailViewController to TopGamesViewController by tapping the "Top Games" tab bar item
                if topGamesViewController.isViewLoaded && (topGamesViewController.view.window != nil) {
                    // When topGamesViewController is visible then allows the "scroll-to-top" gesture to the top games table view
                    topGamesViewController.topGamesTableView.setContentOffset(CGPoint.zero, animated: true)
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
