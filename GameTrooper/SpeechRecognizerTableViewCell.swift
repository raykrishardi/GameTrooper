//
//  SpeechRecognizerTableViewCell.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 7/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import UIKit

// Class that represents the speechRecognizerCell in gameStoresTableView
class SpeechRecognizerTableViewCell: UITableViewCell {

    // Get reference to the button in speechRecognizerCell
    @IBOutlet var speechRecognizerButton: UIButton!
    
    // Function that will be executed when the speech recognizer button is tapped
    // 1. Change the image of the button to an audio wave image to indicate that the speech recognition has started
    // 2. Set a timer of 5 seconds and change the image of the button back to microphone image when the timer ends to indicate that the speech recognition has finished
    @IBAction func speechRecognizerButtonTapped() {
        speechRecognizerButton.setImage(#imageLiteral(resourceName: "Audio Wave"), for: UIControlState.normal)
        let timer = Timer(timeInterval: 5.0, target: self, selector: #selector(SpeechRecognizerTableViewCell.timerEnded), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    // Function that will be executed when the timer ends
    // 1. Change the image of the button back to microphone image to indicate that the speech recognition has finished
    func timerEnded() {
        speechRecognizerButton.setImage(#imageLiteral(resourceName: "Microphone"), for: UIControlState.normal)
    }
    
    //-----------------------------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //-----------------------------------------------------------------

}
