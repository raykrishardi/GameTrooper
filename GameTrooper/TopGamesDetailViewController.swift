//
//  TopGamesDetailViewController.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 18/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import UIKit

// Class that represents the controller for the top games detail screen
class TopGamesDetailViewController: UIViewController, UIWebViewDelegate {

    // Get reference to the web view
    @IBOutlet var topGamesWebView: UIWebView!
    
    // Variable that represents the selected top game from the TopGamesViewController's topGamesTableView
    var selectedTopGame: TopGame?
    
    // Function that will be executed when the view has been loaded into the memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign the appropriate delegate for the topGamesWebView to ensure that the webViewDidFinishLoad() and didFailLoadWithError() functions get called properly
        topGamesWebView.delegate = self
        
        // Setup and start the activity indicator view when the top game's url content is about to be loaded by the topGamesWebView
        // The reason why the activity indicator view starts animating in the viewDidLoad() is because if you start animating in the webViewDidStartLoad() function then it will show and hide itself numerous times
        ActivityIndicatorViewHelper.setupActivityIndicatorView(view: self.view)
        ActivityIndicatorViewHelper.startActivityIndicatorView()
        
        // Attempt to get valid url from the top game's url attribute value
        // If the url attribute value is a valid url then load the url content and display the content within the topGamesWebView
        if let urlToTopGame = URL(string: selectedTopGame!.url){
            self.topGamesWebView.loadRequest(URLRequest(url: urlToTopGame))
        }

    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                         https://stackoverflow.com/questions/11334247/add-activity-indicator-to-web-view
    //                                                              By:
    //                                                          "user529758"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that will be executed when the web view has finished loading the top game's url content
    // 1. Stop the activity indicator view when the content has been loaded
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ActivityIndicatorViewHelper.stopActivityIndicatorView()
    }
    
    // Function that will be executed when the web view failed to load the top game's url content
    // 1. Check whether the failure is due to no internet connection. If it is then display "No Internet Connection" banner
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        ReachabilityHelper.checkForInternetConnection()
    }
    
    //---------------------------------------------------------------------------------------------------------------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
