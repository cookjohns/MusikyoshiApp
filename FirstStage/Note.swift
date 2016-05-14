//
//  Note.swift
//  Trumpet1
//
//  Created by Adam Kinney on 11/6/15.
//  Copyright © 2015 ADKINN, LLC. All rights reserved.
//

import UIKit

class Note
{
    var frequency: Float!
    var name: String!
    var octave: Int!
    var orderId: Int!
    var flatName: String!
    
    var xPos = 0.0
    var isRest = false
    var length : NoteLength = .Whole
    
    var friendlyName : String{
        get{
            if flatName != "" {
                return flatName
            } else {
                return name
            }
        }
    }
    
    var fullName : String{
        get{
            return friendlyName + String(octave)
        }
    }
    
    init(){
        
    }
    
    init(_ frequency: Float, _ name: String, _ octave: Int, _ orderId: Int) {
        self.frequency = frequency
        self.name = name
        self.octave = octave
        self.orderId = orderId
        self.flatName = ""
    }
    
    init(_ frequency: Float, _ name: String, _ octave: Int, _ orderId: Int, _ flatName: String) {
        self.frequency = frequency
        self.name = name
        self.octave = octave
        self.orderId = orderId
        self.flatName = flatName
    }
}