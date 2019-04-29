//
//  GameNewsViewController.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 21/4/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage

// Class that represents the controller for the game news screen
class GameNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate {

    // Variable that represents the previously selected view controller when the user navigates through different view controllers
    // Used to apply the appropriate "scroll-to-top" gesture when the user taps on the "News" tab bar item
    var previousViewController: UIViewController?
    
    // Get reference to the table view
    @IBOutlet var newsTableView: UITableView!

    // Variable that indicates whether the syncing of news (fetchNews) from the firebase database has been completed or not
    var syncCompleted: Bool = false
    
    // Variable that represents an array of first one hundred news fetched from the firebase database
    var firstOneHundredNewsArray: [News] = []
    
    // Variable that represents an array of news to be displayed on the screen
    var newsFeedArray: ArraySlice<News> = []
    
    // Constant that represents the maximum number of news to be displayed in each page
    let maxNumberOfNewsForEachPage: Int = 5
    
    // Variable that represents a reference to the "news" node in firebase database
    var newsRef: FIRDatabaseReference!
    
    // Variable that represents the refresh control for the built-in "pull-to-refresh" gesture
    var refreshControl: UIRefreshControl!
    
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
        
        // Get a reference to the "news" node in firebase database and make sure that the firebase database is kept synced (i.e. sync local cached data with the data in firebase database)
        newsRef = FIRDatabase.database().reference(withPath: "news")
        newsRef.keepSynced(true)
        
        // Setup the refresh control for the built-in "pull-to-refresh" gesture
        setupRefreshControl()
        
        // Setup and start the activity indicator view when the news are about to be fetched from the firebase database
        ActivityIndicatorViewHelper.setupActivityIndicatorView(view: self.view)
        ActivityIndicatorViewHelper.startActivityIndicatorView()
        
        // Fetch news from the firebase database
        fetchNews()
        
        // Indicate that the syncing of news (fetchNews) from the firebase database has been completed
        syncCompleted = true

    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                          https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
    //                                                              By:
    //                                                        "Attila Hegedus"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that fetches news from the firebase database
    func fetchNews(){
        
        // Constant that represents the amount of news to be fetched from the firebase database
        let limit: UInt = 100
        
        // Fetch the last 100 news from the firebase database and order them by the child node "publishedAt"
        // queryLimited(toLast: 100) -> because when the news are ordered by "publishedAt", the latest news are located in the last part
        newsRef.queryOrdered(byChild: "publishedAt").queryLimited(toLast: limit).observeSingleEvent(of: .value, with: { snapshot in
            
            // Reset the content of the arrays as new data will be inserted to these arrays
            self.firstOneHundredNewsArray = []
            self.newsFeedArray = []
            
            // Loop through all fetched news
            for item in snapshot.children {
                // Create news object from the fetched news and append the newly created news object to the firstOneHundredNewsArray
                let newsItem = News(snapshot: item as! FIRDataSnapshot)
                self.firstOneHundredNewsArray.append(newsItem)
            }
            
            // Reverse the content of the firstOneHundredNewsArray
            // Reason why reverse manually -> queryOrdered(byChild: "") only accepts sorting in ascending order
            // Therefore, by reversing the array, the news are now sorted in descending order based on the "publishedAt" (i.e. latest news are now located at the beginning of the array)
            self.firstOneHundredNewsArray.reverse()
            
            // Populate the news to be displayed as the first five news from the array of all 100 news and remove these news from the array of all 100 news
            self.newsFeedArray = self.firstOneHundredNewsArray.prefix(self.maxNumberOfNewsForEachPage)
            self.firstOneHundredNewsArray.removeFirst(self.maxNumberOfNewsForEachPage)
            
            // Stop refresh operation and the activity indicator view
            self.refreshControl.endRefreshing()
            ActivityIndicatorViewHelper.stopActivityIndicatorView()
            
            // Reload the news table view
            self.newsTableView.reloadData()
        })
        
    //---------------------------------------------------------------------------------------------------------------------------
        

    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                     1. https://stackoverflow.com/questions/24475792/how-to-use-pull-to-refresh-in-swift
    //                     2. https://cocoacasts.com/how-to-add-pull-to-refresh-to-a-table-view-or-collection-view/
    //                                                              By:
    //                                                1. "Anil Varghese" and "Dejan Skledar"
    //                                                       2. "Bart Jacobs"
    //---------------------------------------------------------------------------------------------------------------------------

    // Function that setups the refresh control for the built-in "pull-to-refresh" gesture
    // 1. Create refresh control object, add function to be executed when the "pull-to-refresh" gesture is performed, and add the refresh control as a subview to the table view
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(GameNewsViewController.refresh(sender:)), for: .valueChanged)
        self.newsTableView.addSubview(refreshControl)
    }
    
    // Function that will be executed when the "pull-to-refresh" gesture is performed
    // 1. Check for the device's internet connection and display the "No Internet Connection" banner if there is no internet connection
    // 2. Fetch news from firebase database
    func refresh(sender:AnyObject) {
        ReachabilityHelper.checkForInternetConnection()
        fetchNews()
    }

    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that determines the number of sections in the table view
    // Section 0 -> list of news (gameNewsCell)
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Function that determines the number of rows in the news section
    // If syncing of news (fetchNews) from the firebase database has been completed then display the news
    // If syncing of news (fetchNews) from the firebase database has NOT been completed then display empty table view (no row)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if syncCompleted{
            return newsFeedArray.count
        }
        else{
            return 0
        }
    }
    
    // Function that returns the gameNewsCell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a reference to "GameNewsTableViewCell" using "gameNewsCell" identifier
        let gameNewsCell = tableView.dequeueReusableCell(withIdentifier: "gameNewsCell", for: indexPath) as! GameNewsTableViewCell
        
        // Constant that represents the news to be displayed
        let news: News = self.newsFeedArray[indexPath.row] 
        
        // Assign the source and title label text with the appropriate news attribute values
        gameNewsCell.newsSourceLabel.text = news.source
        gameNewsCell.newsTitleLabel.text = news.title
        
        // Assign the time label text with the news date published in relative time format instead of ISO8601 date format
        let datePublished = news.getFormattedDate()
        gameNewsCell.newsTimeLabel.text = datePublished.relativeTime
        
        // Attempt to get valid url from the news's urlToImage attribute value
        // Required because the value of urlToImage could be "null"
        if let newsUrlToImage = URL(string: news.urlToImage){
            
            //-------------------------------------------------------------------------------------------------------------------
            //                                                         Source:
            //                                       https://www.youtube.com/watch?v=XPAaxF0rQy0
            //                                                           By:
            //                                                     "Jared Davidson"
            //-------------------------------------------------------------------------------------------------------------------

            // If the urlToImage attribute value is a valid url then set the appropriate image to the image view by using the given url (SDWebImage is used to download and set the image from the url)
            // If the urlToImage attribute value is NOT a valid url then set the default placeholder image to the image view
            // Options -> continue downloading the image if the app goes to background and enables progressive download
            gameNewsCell.newsImageView.sd_setImage(with: newsUrlToImage, placeholderImage: #imageLiteral(resourceName: "placeholder-image"), options: [.continueInBackground, .progressiveDownload])
            
            //-------------------------------------------------------------------------------------------------------------------
            
        }
        
        return gameNewsCell
    }
    
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //          https://stackoverflow.com/questions/35495750/uitableview-pagination-bottom-refresh-to-load-new-data-in-swift
    //                                                              By:
    //                                                        "Sohil R. Memon"
    //---------------------------------------------------------------------------------------------------------------------------

    // Function that will be executed when the dragging ended in the scroll view
    // Used for pagination of news when the user scrolls to the bottom of the table view
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Check whether the scroll view object that has finished scrolling is the news table view's scroll view object
        if scrollView == newsTableView {
            
            // Make sure that the scroll view has reached the appropriate position/height
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                
                // Setup and start the footer activity indicator view when more news are about to be fetched from the array of all 100 news
                ActivityIndicatorViewHelper.setupFooterActivityIndicatorView(tableView: self.newsTableView)
                ActivityIndicatorViewHelper.startActivityIndicatorView()
                
                // Fetch more news from the array of all 100 news
                print("\n\n End of table view, load more! \n\n")
                self.fetchMoreNews()
            }
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    
    
    // Function that fetches more news from the array of all 100 news
    func fetchMoreNews(){
        
        // Constant that represents the news to be added to the newsFeedArray
        // Attempt to get the first five news from the array of all 100 news
        // Note: Prefix is bounds safe which means that if the value of maxNumberOfNewsForEachPage (5) is larger than the size of the array then prefix will return the entire array
        let newsToBeAddedArray = self.firstOneHundredNewsArray.prefix(self.maxNumberOfNewsForEachPage)
        
        // Only process the newsToBeAddedArray if it is NOT empty
        // If there is/are news to be added to the newsFeedArray from the array of all 100 news fetched from the firebase database then: 
        // 1. Add the news to the newsFeedArray and remove the news from the array of all 100 news
        // 2. Reload the news table view
        if !newsToBeAddedArray.isEmpty {
            self.newsFeedArray += newsToBeAddedArray
            self.firstOneHundredNewsArray.removeFirst(newsToBeAddedArray.count)
            self.newsTableView.reloadData()
        }
        
        // Stop and hide the footer activity indicator view 
        ActivityIndicatorViewHelper.stopActivityIndicatorView()
        
        // Hide the table footer view that is used by the footer activity indicator view
        self.newsTableView.tableFooterView = nil
        
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
        // Constant that represents the selected news in a particular row
        let selectedNews = newsFeedArray[indexPath.row]
        
        // Perform segue with the specified identifier and send the selected news object
        performSegue(withIdentifier: "GameNewsDetailSegue", sender: selectedNews)
        
        // Deselect the selected row (i.e. remove highlighting from the selected row)
        newsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Prepare for segue function that will be executed when a particular segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If "GameNewsDetailSegue" is performed then pass the selected news object in a particular row to the "GameNewsDetailViewController" selectedNews variable
        if segue.identifier == "GameNewsDetailSegue"{
            let destinationController: GameNewsDetailViewController = segue.destination as! GameNewsDetailViewController
            destinationController.selectedNews = sender as? News
        }
    }
    
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //          https://stackoverflow.com/questions/37124110/scroll-to-top-uitableview-with-double-tap-on-uitabbaritem
    //                                                              By:
    //                                                       "Olivier Wilkinson"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that will be executed when a particular tab bar item is tapped/selected (e.g. the user navigates to "News" section from "Top Games" section)
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        // Check the previous and current/selected view controller
        // Checking of previous and current view controller is required to prevent scrolling to the top of the table view when the user is currently in a different view controller and navigates back to the intended view controller
        // i.e. Prevent scrolling to the top when the user navigates to "News" section from "Top Games" section
        if self.previousViewController == viewController {
            
            // Make sure that reference to the navigation controller and the game news view controller can be obtained
            if let newsNavigationController = viewController as? UINavigationController, let gameNewsViewController = newsNavigationController.viewControllers.first as? GameNewsViewController {
                
                // Check whether the gameNewsViewController is already loaded into the memory and whether it is currently visible or not
                // Used to prevent scrolling to the top when the user navigates from GameNewsDetailsViewController to GameNewsViewController by tapping the "News" tab bar item
                if gameNewsViewController.isViewLoaded && (gameNewsViewController.view.window != nil) {
                    // When gameNewsViewController is visible then allows the "scroll-to-top" gesture to the news table view
                    gameNewsViewController.newsTableView.setContentOffset(CGPoint.zero, animated: true)
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
