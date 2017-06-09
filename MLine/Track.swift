//
//  Track.swift
//  MLine
//
//  Created by Jonathan Tran on 6/8/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import Foundation
import MapKit

class Track
{
    //MARK:- Properties
    var trackPoints: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    
    //MARK:- Initialization
    required init(){
        addPoints()
    }
    
    
    //MARK:- Methods
    
    //Methods for finding a location nearest to the track
    //Pass in trolley location, find the proper location and pin it to the track.
    
    func addPoints()
    {
        //TODO: Move this to info.plist or somewhere else suitable.
        self.trackPoints.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(32.801866), longitude: CLLocationDegrees(-96.800921)))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(32.807605), longitude: CLLocationDegrees(-96.797218)))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(32.807928), longitude: CLLocationDegrees(-96.796825)))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(32.80555), longitude: CLLocationDegrees(-96.79408700000002)))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.80558, longitude: -96.79405200000001))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.807965, longitude: -96.796784))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.808701, longitude: -96.79587))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.809536, longitude: -96.796814))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.807955, longitude: -96.798829))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.8071, longitude: -96.799828))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.806619, longitude: -96.799275))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.805047, longitude: -96.80029))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.803497, longitude: -96.801327))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.802399, longitude: -96.802053))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.801826, longitude: -96.802391))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.800725, longitude: -96.801144))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.800448, longitude: -96.80093))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.800163, longitude: -96.800837))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.799744, longitude: -96.800919))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.797646, longitude: -96.801428))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.795088, longitude: -96.802172))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.792926, longitude: -96.80288800000001))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.791663, longitude: -96.803337))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.789312, longitude: -96.804016))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.788596, longitude: -96.80315200000001))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.788087, longitude: -96.802504))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.78612, longitude: -96.800205))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.784398, longitude: -96.798264))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.784347, longitude: -96.798114))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.784379, longitude: -96.797961))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.784431, longitude: -96.797831))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.784518, longitude: -96.797697))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.785051, longitude: -96.797057))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.785577, longitude: -96.79669500000001))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.78566200000001, longitude: -96.796515))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.785738, longitude: -96.796344))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.785849, longitude: -96.79626300000001))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.785965, longitude: -96.796281))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.786035, longitude: -96.796364))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.786139, longitude: -96.796555))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.786868, longitude: -96.797337))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.787655, longitude: -96.798363))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.787863, longitude: -96.798653))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.788047000000006, longitude: -96.79893900000002))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.788266, longitude: -96.799532))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.788431, longitude: -96.799783))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.788918, longitude: -96.800427))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.789342, longitude: -96.800946))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.789875, longitude: -96.80152))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.791487, longitude: -96.803248))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.791631, longitude: -96.803289))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.792908, longitude: -96.802836))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.79508, longitude: -96.802138))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.79764, longitude: -96.801398))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.799732, longitude: -96.800865))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.80024, longitude: -96.800755))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.801715, longitude: -96.800966))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.801808, longitude: -96.80095))
        self.trackPoints.append(CLLocationCoordinate2D(latitude: 32.801866, longitude: -96.800921))
    }

    
}
