//
//  MapViewController.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 7/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import Speech
import FirebaseDatabase

// Class that represents the controller for the map screen
class MapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, SFSpeechRecognizerDelegate {
    
    // Get reference to the map view
    @IBOutlet var gameStoresMapView: MKMapView!
    
    // Get reference to the table view
    @IBOutlet var gameStoresTableView: UITableView!
    
    // Get reference to the search bar
    @IBOutlet var gameStoresSearchBar: UISearchBar!
    
    // Variable that represents the location manager that manages location-related events
    var locationManager = CLLocationManager()
    
    // Variable that represents the current user location
    var currentLocation: CLLocation?
    
    // Variable that represents an array of nearby game stores fetched from the firebase database
    var gameStoresArray: [GameStoreAnnotation] = []
    
    // Variable that represents an array of filtered nearby game stores based on the search bar text
    var filteredGameStoresArray: [GameStoreAnnotation] = []
    
    // Variable that checks whether a search is currently being performed or not
    var searchMode: Bool = false
    
    // Constant that represents the speech recognizer object that will manage speech recognition
    let speechRecognizer = SFSpeechRecognizer()!
    
    // Variable that represents the speech recognition request (provides audio input to the speech recognizer)
    var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    
    // Variable that represents the speech recognition task (returns the speech recognition request result)
    var recognitionTask = SFSpeechRecognitionTask()
    
    // Constant that represents the device's audio engine (allows for audio input)
    let audioEngine = AVAudioEngine()
    
    // Variable that represents a reference to the "game-stores" node in firebase database
    var gameStoresRef: DatabaseReference!

    // Function that will be executed when the view has been added to the view hierarchy (i.e. view has appeared on the screen)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Get a reference to the "game-stores" node in firebase database and make sure that the firebase database is kept synced (i.e. sync local cached data with the data in firebase database)
        gameStoresRef = Database.database().reference(withPath: "game-stores")
        gameStoresRef.keepSynced(true)
        
        // Check for the device's internet connection
        // If there is no internet connection then display "No Internet Connection" banner and fetch local cached game stores from firebase database
        if ReachabilityHelper.reachability.connection == .none {
            BannerHelper.displayNoInternetConnectionBanner()
            self.fetchGameStoresFromFirebase()
        }
        
        // Track user's current location
        // 1. Assign the appropriate delegate for the location manager to ensure that the location-related functions get called properly
        // 2. Set the desired accuracy to the highest-level of accuracy 
        // 2.1 Although it takes more battery life using this level of accuracy, the user's current location is only requested ONCE every time the user navigates to the map screen which is more acceptable compared to requesting the user's location multiple times
        // 3. Request user's permission to use location services
        // 4. Request the user's current location once
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Assign the appropriate delegate for the game stores search bar to ensure that the search bar functions get called properly 
        gameStoresSearchBar.delegate = self
    
    }
    
    
    // Function that will be executed when the view has been loaded into the memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign the appropriate delegate for the speech recognizer to ensure that the speech recognizer functions get called properly
        speechRecognizer.delegate = self
        
        //-----------------------------------------------------------------------------------------------------------------------
        //                                                            Source:
        //                     1. https://www.captechconsulting.com/blogs/ios-10-blog-series-speech-recognition
        //                     2. http://www.appcoda.com/siri-speech-framework/
        //                                                              By:
        //                                                      1. "Josh Huerkamp"
        //                                                      2. "Sahand Edrisian"
        //-----------------------------------------------------------------------------------------------------------------------

        // Request user's permission to perform speech recognition
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            // Make sure that the authorization status are processed on the main thread
            OperationQueue.main.addOperation({
                
                // Print the appropriate messages for each authorization status for debugging purposes
                switch authStatus {
                case .authorized:
                    print("Access to speech recognition authorized by user")
                case .denied:
                    print("Access to speech recognition denied by user")
                case .restricted:
                    print("Access to speech recognition restricted on this device")
                case .notDetermined:
                    print("Access to speech recognition not yet authorized")
                @unknown default:
                    fatalError("Error accessing speech recognition")
                }
                
            })
            
        }
        
        //-----------------------------------------------------------------------------------------------------------------------
        
    }

    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    // https://www.hackingwithswift.com/example-code/location/how-to-request-a-users-location-only-once-using-requestlocation
    //                                                              By:
    //                                                            "Paul"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that will be executed when the user's location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Attempt to get the user's location data from the first element of the array of user locations
        if let location = locations.first {
            
            // Get the user's current location when it is available
            self.currentLocation = location
            
            //-------------------------------------------------------------------------------------------------------------------
            //                                                            Source:
            //              https://stackoverflow.com/questions/35705649/how-to-center-a-map-on-user-location-ios-9-swift
            //                                                              By:
            //                                                         "Clever Error"
            //-------------------------------------------------------------------------------------------------------------------
            
            // Center and zoom the map based on the user's current location
            gameStoresMapView.userTrackingMode = .follow
            
            //-------------------------------------------------------------------------------------------------------------------
            
            // Display user's current location on the map (blue dot)
            gameStoresMapView.showsUserLocation = true
            
            // Fetch up to 20 nearby game stores using the google places api, update the nearby game stores stored in the firebase database, and fetch the updated nearby game stores from firebase database
            fetchNearbyGameStores()
            
            // Make sure that the fetchNearbyGameStores() function only runs once per viewDidAppear
            self.locationManager.delegate = nil
        }
        
    }
    
    // Function that will be executed when the location manager failed to retrieve user's current location
    // 1. Print the appropriate error message for debugging purposes
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    //-------------------------------------------------------------------------------------------------------------------
    
    
    // Function that fetches up to 20 nearby game stores using the google places api, update the nearby game stores stored in the firebase database, and fetch the updated nearby game stores from firebase database
    func fetchNearbyGameStores() {
        
        // Constant that represents the GameTrooper's Google Places API key
        let googlePlacesAPIKey: String = "AIzaSyBUEDhaJ_XybbZkzv9X-QpaW3rW2wAn_Ds"
        
        // Constants that represent the latitude and longitude of the user's current location
        let currentLatitude: String = "\(self.currentLocation!.coordinate.latitude)"
        let currentLongitude: String = "\(self.currentLocation!.coordinate.longitude)"

        // Constant that represents the city in Australia (Melbourne) to search for the nearby game stores
        let city: String = "Melbourne"
        
        // Constant that represents the url to query/fetch up to 20 nearby game stores in Melbourne based on the user's current latitude and longitude via the google places api
        let url: String = "https://maps.googleapis.com/maps/api/place/textsearch/json?location=\(currentLatitude),\(currentLongitude)&rankby=distance&query=game+stores+in+\(city)&key=\(googlePlacesAPIKey)"
        
        // Print the url for debugging purposes
        print("\n\n\(url)\n\n")
        
        // Perform a request to the specified url and handles the JSON response via Alamofire
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value {
                
                // Get reference to the JSON data as a dictionary
                let JSONResult = JSON as! NSDictionary
                
                // Get reference to the array of nearby game stores
                let gameStoresArray = JSONResult.value(forKey: "results") as! NSArray
                
                // Loop through all nearby game stores
                for (index, gameStore) in (gameStoresArray as! [NSDictionary]).enumerated() {
                    
                    // Get reference to the game store name and address
                    let gameStoreName = gameStore.value(forKey: "name") as! String
                    let gameStoreAddress = gameStore.value(forKey: "formatted_address") as! String
                    
                    // Get reference to the game store geometry and location in order to get the game store's latitude and longitude
                    let geometry = gameStore.value(forKey: "geometry") as! NSDictionary
                    let location = geometry.value(forKey: "location") as! NSDictionary
                    
                    // Get reference to the game store latitude and longitude
                    let gameStoreLatitude = location.value(forKey: "lat") as! Double
                    let gameStoreLongitude = location.value(forKey: "lng") as! Double
                    
                    // Create a game store annotation object with the appropriate key (1-20) and other attribute values
                    let gameStoreAnnotation = GameStoreAnnotation(initKey: String(index+1), initTitle: gameStoreName, initSubtitle: gameStoreAddress, initLatitude: gameStoreLatitude, initLongitude: gameStoreLongitude)
                    
                    // Update existing nearby game stores stored in the firebase database by replacing the value for a given key (key is in the range of 1 to 20)
                    let gameStoreAnnotationRef = self.gameStoresRef.child(gameStoreAnnotation.key)
                    gameStoreAnnotationRef.setValue(gameStoreAnnotation.toAnyObject())
                    
                }
                
                // Fetch the updated nearby game stores from firebase database
                self.fetchGameStoresFromFirebase()
                
            }
        }
        
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                          https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
    //                                                              By:
    //                                                        "Attila Hegedus"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that fetches nearby game stores from firebase database
    func fetchGameStoresFromFirebase() {
        
        // Fetch nearby game stores from firebase database
        gameStoresRef.observeSingleEvent(of: .value, with: { snapshot in
            
            // Reset the content of the gameStoresArray as new data will be inserted to this array
            self.gameStoresArray = []
            
            // Loop through all fetched game stores
            for item in snapshot.children {
                // Create game store annotation object from the fetched game stores, append the newly created object to the gameStoresArray, and add the game store annotation to the gameStoresMapView
                let gameStoreAnnotationItem = GameStoreAnnotation(snapshot: item as! DataSnapshot)
                self.gameStoresArray.append(gameStoreAnnotationItem)
                self.gameStoresMapView.addAnnotation(gameStoreAnnotationItem)
            }
            
            // Reload the game stores table view
            self.gameStoresTableView.reloadData()
            
        })
    }

    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that will be executed when the speech recognizer button in speechRecognizerCell is tapped
    @IBAction func speechRecognizerButtonTapped() {
        // Start recording when the audio engine is NOT running
        if !audioEngine.isRunning {
            startRecording()
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                     1. https://www.captechconsulting.com/blogs/ios-10-blog-series-speech-recognition
    //                                      2. http://www.appcoda.com/siri-speech-framework/
    //                                                              By:
    //                                                     1. "Josh Huerkamp"
    //                                                     2. "Sahand Edrisian"
    //-----------------------------------------------------------------------------------------------------------------------
    
    // Function that starts the recording session via microphone and performs speech recognition on the recording
    func startRecording() {
        
        // Set a timer of 5 seconds
        // When the timer has ended, stop the recording session and filter the game stores based on the search bar text
        let timer = Timer(timeInterval: 5.0, target: self, selector: #selector(MapViewController.timerEnded), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .common)
        
        do {
            // Setup and start an audio session with the appropriate configurations:
            // 1. Set the category as recording
            // 2. Set the mode as measurement
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation) // Activate the audio session
            
            // Attempt to get a reference to the audio engine's input node
            let inputNode = audioEngine.inputNode
                
            // Specify that the results should be reported partially instead of reporting the final results only
            recognitionRequest.shouldReportPartialResults = true
            
            // Perform speech recognition
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                
                // If there is a result (result != nil) then assign the search bar text as the transcription result with highest level of confidence
                if let result = result {
                    self.gameStoresSearchBar.text = result.bestTranscription.formattedString
                }
                
            })
            
            // Add the audio input to the recognition request by first removing the tap on bus 0 before installing it again to prevent AVFoundation exception
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.removeTap(onBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { (buffer, when) in
                self.recognitionRequest.append(buffer)
            })
            
            // Prepare and start the audio engine
            audioEngine.prepare()
            try audioEngine.start()
                
            
            
        }
        catch {
            print("Error in setting up the audio session and engine")
        }

    }
    
    // Function that will be executed when the timer of 5 seconds has ended
    @objc func timerEnded() {
        // If the audio engine is running then stop recording and filter the game stores based on the search bar text
        if audioEngine.isRunning {
            stopRecording()
            filterGameStores()
        }
    }
    
    // Function that stops the recording session by stopping the audio engine, indicate that the recognition request has finished, and cancel the current speech recognition task
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest.endAudio()
        recognitionTask.cancel()
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    
    
    // Function that determines the number of sections in the table view
    // Section 0 -> speech recognizer button (speechRecognizerCell)
    // Section 1 -> list of game stores (gameStoresCell)
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Function that determines the number of rows in each section
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Only 1 row for section 0 (speechRecognizerCell)
        case 1:
            // Check whether search mode is active or not
            // If it is active then the number of rows in section 1 (gameStoresCell) is equal to the filteredGameStoresArray size
            // If it is NOT active then the number of rows in section 1 (gameStoresCell) is equal to the gameStoresArray size
            if searchMode {
                return filteredGameStoresArray.count
            }
            else {
                return gameStoresArray.count
            }
        default:
            return 0
        }
    }
    
    // Function that returns the appropriate cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Section 0 -> speechRecognizerCell
        if indexPath.section == 0{
            // Get a reference to "SpeechRecognizerTableViewCell" using "speechRecognizerCell" identifier
            let speechRecognizerCell = tableView.dequeueReusableCell(withIdentifier: "speechRecognizerCell", for: indexPath) as! SpeechRecognizerTableViewCell
            
            return speechRecognizerCell
        }
        // Section 1 -> gameStoresCell
        else{
            // Get a reference to "GameStoresTableViewCell" using "gameStoresCell" identifier
            let gameStoresCell = tableView.dequeueReusableCell(withIdentifier: "gameStoresCell", for: indexPath) as! GameStoresTableViewCell
            
            // Constant that represents the game store to be displayed
            let gameStore : GameStoreAnnotation?
            
            // Check whether search mode is active or not
            // If it is active then game stores are selected from the filteredGameStoresArray
            // If it is NOT active then game stores are selected from the gameStoresArray
            if searchMode {
                gameStore = self.filteredGameStoresArray[indexPath.row]
            }
            else {
                gameStore = self.gameStoresArray[indexPath.row]
            }
            
            // Assign the name and address label text with the appropriate game store attribute values
            gameStoresCell.gameStoreNameLabel.text = gameStore?.title
            gameStoresCell.gameStoreAddressLabel.text = gameStore?.subtitle
            
            return gameStoresCell
        }

    }
    
    // Function that will be executed when the user begins editing the search bar text
    // 1. Show the game stores table view and the search bar's cancel button
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        gameStoresTableView.isHidden = false
        gameStoresSearchBar.setShowsCancelButton(true, animated: true)
    }
    
    // Function that will be executed when the user ends editing the search bar
    // 1. Hide the search bar's cancel button
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        gameStoresSearchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    // Function that will be executed when the search bar's cancel button was tapped/clicked
    // 1. Reset the search bar to default settings (deactivate search mode, reset the search bar text, and reload the game stores table view)
    // 2. Show the game stores map view and hide the game stores table view
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetToDefaultSearchBar()
        gameStoresSearchBar.resignFirstResponder()
        gameStoresTableView.isHidden = true
    }
    
    // Function that will be executed when search bar's search button was tapped/clicked
    // 1. Filter the game stores based on the search bar text and end/finish editing the search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterGameStores()
        gameStoresSearchBar.resignFirstResponder()
    }
    
    // Function that resets the search bar to default settings:
    // 1. Deactivate search mode
    // 2. Reset the search bar text
    // 3. Reload the game stores table view
    func resetToDefaultSearchBar() {
        searchMode = false
        gameStoresSearchBar.text = ""
        self.gameStoresTableView.reloadData()
    }
    
    // Function that will be executed when there is a change in the search bar text
    // 1. Show the game stores table view and filter the game stores based on the search bar text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        gameStoresTableView.isHidden = false
        filterGameStores()
    }
    
    // Function that filters the game stores based on the search bar text
    func filterGameStores() {
        
        // Check whether the game stores search bar text contains an empty string or is nil
        // If the search bar text contains an empty string or is nil then search mode is NOT active
        // Else, search mode is active
        if gameStoresSearchBar.text == "" || gameStoresSearchBar.text == nil{
            self.searchMode = false
        }
        else{
            self.searchMode = true
            
            // Fill/assign filteredGameStoresArray with GameStoreAnnotation object(s) from gameStoresArray in which the selected GameStoreAnnotation(s) must contain the same title as the search bar text in case insensitive format
            filteredGameStoresArray = gameStoresArray.filter({$0.title!.localizedCaseInsensitiveContains(gameStoresSearchBar.text!)})
        }
        
        // Reload the game stores table view
        self.gameStoresTableView.reloadData()
    }

    
    // Function that will be executed when a particular row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Only select and display annotation on the game stores map view if row in section 1 (gameStoresCell) is selected
        if indexPath.section == 1{
            // Constant that represents the selected game store in a particular row
            let selectedGameStore: GameStoreAnnotation?
            
            // Check whether search mode is active or not
            // If it is active then game store is selected from the filteredGameStoresArray
            // If it is NOT active then game store is selected from the gameStoresArray
            if searchMode{
                selectedGameStore = self.filteredGameStoresArray[indexPath.row]
            }
            else{
                selectedGameStore = self.gameStoresArray[indexPath.row]
            }
            
            // End/finish editing the search bar
            gameStoresSearchBar.resignFirstResponder()
            
            // Hide the game stores table view
            gameStoresTableView.isHidden = true
            
            // Center the game stores map view to the selected game store coordinate
            self.gameStoresMapView.centerCoordinate = selectedGameStore!.coordinate
            
            // Select and display the selected game store annotation
            self.gameStoresMapView.selectAnnotation(selectedGameStore!, animated: true)
        }
        
        // Deselect the selected row (i.e. remove highlighting from the selected row)
        gameStoresTableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
