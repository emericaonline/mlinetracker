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
//    let name: String?
    let thumbnail: UIImage?
    let identifier: Int
    var lastUpdated: Date
    var locations: [CLLocation] = [CLLocation]()
    
    var previousLocation: CLLocation?
    var currentLocation: CLLocation
    
    
    
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
