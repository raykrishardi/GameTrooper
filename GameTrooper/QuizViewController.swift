//
//  QuizViewController.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 16/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import UIKit
import CoreMotion
import FirebaseDatabase

// Class that represents the controller for the quiz screen
class QuizViewController: UIViewController {

//-------------------------------------------------------------------------------------------------------------------------------
//                                                          Quiz Main Screen
//-------------------------------------------------------------------------------------------------------------------------------

    @IBOutlet var titleTrueLabel: UILabel! // "TRUE" in "TRUE OR FALSE" title
    @IBOutlet var titleOrLabel: UILabel! // "OR" in "TRUE OR FALSE" title
    @IBOutlet var titleFalseLabel: UILabel! // "FALSE" in "TRUE OR FALSE" title
    @IBOutlet var playButton: UIButton! // "Play" button
    
//-------------------------------------------------------------------------------------------------------------------------------

    
//-------------------------------------------------------------------------------------------------------------------------------
//                                                          Quiz In-game Screen
//-------------------------------------------------------------------------------------------------------------------------------
    
    // Quiz question
    @IBOutlet var questionLabel: UILabel!
    
    // Quiz game progress indicator (dice, filled dice, small green check mark, and small red cross mark)
    @IBOutlet var questionImageView1: UIImageView!
    @IBOutlet var questionImageView2: UIImageView!
    @IBOutlet var questionImageView3: UIImageView!
    @IBOutlet var questionImageView4: UIImageView!
    @IBOutlet var questionImageView5: UIImageView!
    
    // Quiz user response mechanism
    @IBOutlet var arrow: UIImageView! // Left and right arrow
    @IBOutlet var answerTrue: UIImageView! // Big green check mark
    @IBOutlet var answerFalse: UIImageView! // Big red cross mark
    
    // Quiz answer and answer detail
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var answerDetailLabel: UILabel!
    
    // "Next" button
    @IBOutlet var nextButton: UIButton!
    
//-------------------------------------------------------------------------------------------------------------------------------

    
//-------------------------------------------------------------------------------------------------------------------------------
//                                                          Quiz Game Over Screen
//-------------------------------------------------------------------------------------------------------------------------------

    @IBOutlet var titleGameOverLabel: UILabel! // "GAME OVER" title
    @IBOutlet var titleThankYouForPlayingLabel: UILabel! // "Thank you for playing" title
    @IBOutlet var replayButton: UIButton! // "Replay" button
    
//-------------------------------------------------------------------------------------------------------------------------------
   
    
    // Variable that represents the motion manager that starts and manages motion services
    var motionManager: CMMotionManager = CMMotionManager()
    
    // Variable that represents a reference to the "quiz" node in firebase database
    var quizRef: FIRDatabaseReference!
    
    // Variable that represents an array of quiz questions fetched from the firebase database
    var quizQuestionArray: [QuizQuestion] = []
    
    // Variable that represents the quiz question index (i.e. current quiz question)
    var quizQuestionIndex: Int = 0
    
    // Constant that represents the maximum number of quiz questions
    let maxNumberOfQuizQuestions: Int = 5
    
    
    // Function that will be executed when the view has been loaded into the memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get a reference to the "quiz" node in firebase database and make sure that the firebase database is kept synced (i.e. sync local cached data with the data in firebase database)
        quizRef = FIRDatabase.database().reference(withPath: "quiz")
        quizRef.keepSynced(true)
        
        // Fetch quiz questions from the firebase database
        fetchQuizQuestions()
        
    }
    
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                          https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
    //                                                              By:
    //                                                        "Attila Hegedus"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // Function that fetches quiz questions from firebase database
    func fetchQuizQuestions() {
        
        // Fetch quiz questions from firebase database
        quizRef.observeSingleEvent(of: .value, with: { snapshot in
            
            // Loop through all fetched quiz questions
            for item in snapshot.children {
                // Create quiz question object from the fetched quiz questions and append the newly created quiz question object to the quizQuestionArray
                let quizItem = QuizQuestion(snapshot: item as! FIRDataSnapshot)
                self.quizQuestionArray.append(quizItem)
            }
            
        })
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    
    
    // Function that will be executed when the "Play" button in "Quiz Main Screen" is tapped
    // 1. Display the initial "Quiz In-game Screen" (i.e. 1st quiz question)
    // 2. Play game (user can now move the arrow to the left or right by tilting their device to the left or right)
    @IBAction func playButtonTapped() {
        displayInitialInGameScreen()
        playGame()
    }
    
    // Function that will be executed when the "Next" button in "Quiz In-game Screen" is tapped
    @IBAction func nextButtonTapped() {
        // Set the appropriate quiz game progress indicator (dice, filled dice, small green check mark, and small red cross mark)
        setNextQuestionImageView()
        
        // Increment the quiz question index (i.e. next quiz question)
        quizQuestionIndex += 1

        // Check whether there is still a quiz question to be displayed or not
        // If there is still a quiz question to be displayed then display subsequent "Quiz In-game Screen" (2nd to 5th quiz questions) and play the game
        // If there is NO FURTHER quiz question to be displayed then display the "Quiz Game Over Screen"
        if quizQuestionIndex < maxNumberOfQuizQuestions {
            displaySubsequentInGameScreen()
            playGame()
        }
        else {
            displayGameOverScreen()
        }

    }
    
    // Function that will be executed when the "Replay" button in "Quiz Game Over Screen" is tapped
    // 1. Reset the quiz question index
    // 2. Display the initial "Quiz In-game Screen" (i.e. 1st quiz question)
    // 3. Play game (user can now move the arrow to the left or right by tilting their device to the left or right)
    @IBAction func replayButtonTapped() {
        quizQuestionIndex = 0
        displayInitialInGameScreen()
        playGame()
    }
    
    
    // Function that displays the initial "Quiz In-game Screen" (i.e. 1st quiz question)
    // 1. Display and hide the appropriate UI elements/outlets
    func displayInitialInGameScreen() {
        
        // Hide the "Quiz Main Screen" UI elements/outlets
        playButton.isHidden = true
        titleGameOverLabel.isHidden = true
        titleThankYouForPlayingLabel.isHidden = true
        replayButton.isHidden = true
        
        // Display the appropriate "Quiz In-game Screen" UI elements/outlets
        questionLabel.text = quizQuestionArray[quizQuestionIndex].question // Assign the question label text with the 1st quiz question
        
        questionLabel.isHidden = false
        
        questionImageView1.image = #imageLiteral(resourceName: "Quiz Dice Filled")
        questionImageView2.image = #imageLiteral(resourceName: "Quiz Dice")
        questionImageView3.image = #imageLiteral(resourceName: "Quiz Dice")
        questionImageView4.image = #imageLiteral(resourceName: "Quiz Dice")
        questionImageView5.image = #imageLiteral(resourceName: "Quiz Dice")
        
        questionImageView1.isHidden = false
        questionImageView2.isHidden = false
        questionImageView3.isHidden = false
        questionImageView4.isHidden = false
        questionImageView5.isHidden = false
        
        answerTrue.isHidden = false
        answerFalse.isHidden = false
        
        arrow.isHidden = false
    }
    
    // Function that displays subsequent "Quiz In-game Screen" (2nd to 5th quiz questions)
    // 1. Display and hide the appropriate UI elements/outlets
    func displaySubsequentInGameScreen() {
        
        // Assign the question label text with the appropriate quiz question
        questionLabel.text = quizQuestionArray[quizQuestionIndex].question

        // Reset the x and y coordinates of the arrow back to the original coordinates (i.e. reset the arrow back to the middle/center of the screen)
        arrow.transform = CGAffineTransform.identity
        
        // Hide the quiz answer, answer detail, and "Next" button
        hideAnswer()
    }
    
    // Function that displays the "Quiz Game Over Screen"
    // 1. Display and hide the appropriate UI elements/outlets
    func displayGameOverScreen() {
        titleGameOverLabel.isHidden = false
        titleThankYouForPlayingLabel.isHidden = false
        replayButton.isHidden = false
        
        questionLabel.isHidden = true
        answerTrue.isHidden = true
        answerFalse.isHidden = true
        arrow.isHidden = true
        hideAnswer()
    }
    
    // Function that displays the quiz answer, answer detail, and "Next" button
    func displayAnswer() {
        answerLabel.isHidden = false
        answerDetailLabel.isHidden = false
        nextButton.isHidden = false
    }
    
    // Function that hides the quiz answer, answer detail, and "Next" button
    func hideAnswer() {
        answerLabel.isHidden = true
        answerDetailLabel.isHidden = true
        nextButton.isHidden = true
    }
    
    // Function that controls and manages the quiz user response mechanism
    // 1. Control the arrow's movement when the user tilts their device to the left or right
    // 2. Detect and respond appropriately when the arrow has reached the big green check mark or big red cross mark
    func playGame() {
        // Start device-motion updates on the main thread
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
            
            // Check the returned result data and print the appropriate error message for debugging purposes
            guard data != nil else {
                print("There was an Gravity error: \(String(describing: error))")
                return
            }
            
            // Get the X-axis acceleration in G's (gravitational force)
            // In this case, the X-axis is multiplied by 250 to increase the speed of the arrow's movement (higher number = more speed)
            let x = CGFloat((data?.gravity.x)! * 250)
            
            // Change the arrow image direction properly according to the X-axis
            self.changeArrowImageDirection(x: x)
            
            // Stop device-motion updates on the main thread and check the user's answer when the arrow has reached the big green check mark or big red cross mark
            self.stopMotionSensorAndCheckAnswer(x: x)
            
            //-------------------------------------------------------------------------------------------------------------------
            //                                                            Source:
            //          https://www.hackingwithswift.com/example-code/uikit/how-to-scale-stretch-move-and-rotate-uiviews-using-cgaffinetransform
            //                                                              By:
            //                                                            "Paul"
            //-------------------------------------------------------------------------------------------------------------------

            // Move the arrow to the left or right when the user tilts their device to the left or right by using the arrow's X-axis
            self.arrow.transform = CGAffineTransform(translationX: x, y: 0)
            
            //-------------------------------------------------------------------------------------------------------------------
            
        }
    }
    
    // Function that changes the arrow image direction properly according to the X-axis
    // If x is greater than 0 then change the arrow image direction to right arrow
    // Else, change the arrow image direction to left arrow
    func changeArrowImageDirection(x: CGFloat) {
        if x > 0 {
            self.arrow.image = #imageLiteral(resourceName: "Quiz Right Arrow")
        }
        else {
            self.arrow.image = #imageLiteral(resourceName: "Quiz Left Arrow")
        }
    }
    
    // Function that stops the device-motion updates on the main thread and check the user's answer when the arrow has reached the big green check mark or big red cross mark
    // If x is greater than 80 then the user answer is "false" (i.e. the arrow has reached the big red cross mark)
    // If x is less than 80 then the user answer is "true" (i.e. the arrow has reached the big green check mark)
    func stopMotionSensorAndCheckAnswer(x: CGFloat) {
        if x > 80 {
            self.motionManager.stopDeviceMotionUpdates()
            checkAnswer(userAnswer: "false")
        }
        else if x < -80 {
            self.motionManager.stopDeviceMotionUpdates()
            checkAnswer(userAnswer: "true")
        }
    }
    
    // Function that checks the user's answer against the actual quiz answer, display the appropriate answer based on the user's answer, and set the appropriate game progress indicator
    func checkAnswer(userAnswer: String) {
        // Get reference to the current quiz question
        let quizQuestion = quizQuestionArray[quizQuestionIndex]

        // Check the user's answer against the actual quiz answer
        // 1. Assign the appropriate answer label text based on the user's answer and the actual quiz answer (i.e. "Correct" if they match and "Incorrect" if they do NOT match)
        // 2. Assign the appropriate text color for the answer and answer detail label based on the user's answer and the actual quiz answer (i.e. green if they match and red if they do NOT match)
        // 3. Set the appropriate game progress indicator based on the user's answer and the actual quiz answer (i.e. small green check mark if they match and small red cross mark if they do NOT match)
        if userAnswer == quizQuestion.answer {
            answerLabel.text = "Correct"
            answerLabel.textColor = UIColor.green
            answerDetailLabel.textColor = UIColor.green
            setCurrentQuestionImageView(correct: true)
        }
        else {
            answerLabel.text = "Incorrect"
            answerLabel.textColor = UIColor.red
            answerDetailLabel.textColor = UIColor.red
            setCurrentQuestionImageView(correct: false)
        }
        
        // Assign the answer detail label text with the appropriate answer detail
        answerDetailLabel.text = quizQuestion.detail
        
        // Display the quiz answer, answer detail, and "Next" button
        displayAnswer()
    }
    
    // Function that sets the appropriate game progress indicator based on the user's answer and the actual quiz answer (i.e. small green check mark if they match (correct) and small red cross mark if they do NOT match (incorrect)) for each questions
    func setCurrentQuestionImageView(correct: Bool) {
        switch quizQuestionIndex {
        case 0:
            if correct {
                questionImageView1.image = #imageLiteral(resourceName: "Quiz Checked")
            }
            else {
                questionImageView1.image = #imageLiteral(resourceName: "Quiz Cancel")
            }
        case 1:
            if correct {
                questionImageView2.image = #imageLiteral(resourceName: "Quiz Checked")
            }
            else {
                questionImageView2.image = #imageLiteral(resourceName: "Quiz Cancel")
            }
        case 2:
            if correct {
                questionImageView3.image = #imageLiteral(resourceName: "Quiz Checked")
            }
            else {
                questionImageView3.image = #imageLiteral(resourceName: "Quiz Cancel")
            }
        case 3:
            if correct {
                questionImageView4.image = #imageLiteral(resourceName: "Quiz Checked")
            }
            else {
                questionImageView4.image = #imageLiteral(resourceName: "Quiz Cancel")
            }
        case 4:
            if correct {
                questionImageView5.image = #imageLiteral(resourceName: "Quiz Checked")
            }
            else {
                questionImageView5.image = #imageLiteral(resourceName: "Quiz Cancel")
            }
        default:
            break
        }
    }
    
    // Function that sets the appropriate game progress indicator for the next question (i.e. filled dice image for next question)
    func setNextQuestionImageView() {
        switch quizQuestionIndex {
        case 0:
            questionImageView2.image = #imageLiteral(resourceName: "Quiz Dice Filled")
        case 1:
            questionImageView3.image = #imageLiteral(resourceName: "Quiz Dice Filled")
        case 2:
            questionImageView4.image = #imageLiteral(resourceName: "Quiz Dice Filled")
        case 3:
            questionImageView5.image = #imageLiteral(resourceName: "Quiz Dice Filled")
        default:
            break
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
