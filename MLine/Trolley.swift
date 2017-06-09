//
//  Trolley.swift
//  MLine
//
//  Created by Jonathan Tran on 6/4/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class Trolley
{
    //MARK:- Properties
    let name: String = String()
    let thumbnail: UIImage?
    let identifier: Int
    var lastUpdated: Date
    var locations: [CLLocation] = [CLLocation]()
    
    var previousLocation: CLLocation?
    var currentLocation: CLLocation
    
    
    
    //MARK:- Initialization
    required init(image: UIImage, id: Int, location: CLLocation) {
        self.thumbnail = image
        self.identifier = id
        self.currentLocation = location
        self.lastUpdated = Date()
    }
    
    init(id: Int, location: CLLocation) {
        self.identifier = id
        self.currentLocation = location
        self.thumbnail = UIImage()
        self.lastUpdated = Date()
    }
    
    
    //MARK:- Methods
    func determineHeading()
    {
        
        //Few ideas:
        //Use direct opposite/extend the line forward from the locations array.
        //Use locations array to predict direction, look at trolley track to draw an arrow parallel to that.
        
    }
    
    //MARK:- Operators
    static func == (left: Trolley, right: Trolley) -> Bool
    {
        if(left.identifier == right.identifier) {
            return true
        }
        else {
            return false
        }
            
    }
    
}
