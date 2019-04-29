//
//  QuizQuestion.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 16/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Class that represents quiz question
class QuizQuestion {
    
    // Constant that represents the quiz question
    let question: String
    
    // Constant that represents the quiz answer
    let answer: String
    
    // Constant that represents the quiz answer detail
    let detail: String
    
    // Constant that represents the firebase database reference to a particular quiz question
    let ref: DatabaseReference?
    
    //---------------------------------------------------------------------------------------------------------------------------
    //                                                            Source:
    //                          https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
    //                                                              By:
    //                                                        "Attila Hegedus"
    //---------------------------------------------------------------------------------------------------------------------------
    
    // 1-parameter constructor that initialises the quiz question object with the appropriate values based on the given firebase data snapshot
    init(snapshot: DataSnapshot) {
        
        // Initialise the question based on the given firebase data snapshot's key (quiz question as snapshot key)
        question = snapshot.key
        
        // Constant that represents the firebase data snapshot's value as a dictionary
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // Initialise the answer using the snapshot's value dictionary key "answer" and convert the value as string
        answer = snapshotValue["answer"] as! String
        
        // Initialise the answer detail using the snapshot's value dictionary key "detail" and convert the value as string
        detail = snapshotValue["detail"] as! String
        
        // Initialise the ref based on the given firebase data snapshot's reference
        ref = snapshot.ref
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    
}

