//
//  ActivityIndicatorViewHelper.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 18/4/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import UIKit

// Class that helps to setup and manage activity indicator view
class ActivityIndicatorViewHelper {

    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                                          https://www.youtube.com/watch?v=dLfOdObZW7k
    //                                                              By:
    //                                              "Sebastian Henry aka The Swift Guy"
    //---------------------------------------------------------------------------------------------------------------------------

    // Variable that represents an activity indicator view
    static var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()

    // Function that setups the activity indicator view with the appropriate configurations:
    // 1. Ensure that the activity indicator view is displayed at the center of the view/screen
    // 2. Ensure that the activity indicator view is hidden when stopped
    // 3. Specify that the gray activity indicator view is used instead of the white colored one
    // 4. Add the activity indicator view as a subview of the given UIView
    static func setupActivityIndicatorView(view: UIView){
        activityIndicatorView.center = view.center
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicatorView)
    }

    // Function that starts the activity indicator view
    static func startActivityIndicatorView(){
        activityIndicatorView.startAnimating()
    }

    // Function that stops the activity indicator view
    static func stopActivityIndicatorView(){
        activityIndicatorView.stopAnimating()
    }

    //---------------------------------------------------------------------------------------------------------------------------

    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //              http://stackoverflow.com/questions/7953344/how-can-i-add-a-activity-indicator-below-the-uitableview
    //                                                              By:
    //                                                            "kaka"
    //---------------------------------------------------------------------------------------------------------------------------

    // Function that setups the footer activity indicator view (activity indicator view in table view's footer section) with the appropriate configurations:
    // 1. Ensure that the activity indicator view is displayed at the center of UITableView's footer section
    // 2. Ensure that the activity indicator view is hidden when stopped
    // 3. Specify that the gray activity indicator view is used instead of the white colored one
    // 4. Assign the activity indicator view as the UITableView's footer view
    static func setupFooterActivityIndicatorView(tableView: UITableView){
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 320, height: 45)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        tableView.tableFooterView = activityIndicatorView
    }

    //---------------------------------------------------------------------------------------------------------------------------

}
