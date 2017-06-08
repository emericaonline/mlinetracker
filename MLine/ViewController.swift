
//  ViewController.swift
//  MLine
//
//  Created by Jonathan Tran on 10/15/16.
//  Copyright © 2016 Jonathan Tran. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var path: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    var locationManager: CLLocationManager!
    
    var polylines: MKPolyline = MKPolyline()
    
    var lastLocation: CLLocation?
    
    var trolleys: [Trolley]?
    
    var headingLine: MKPolyline?
    
    let pollServerInterval = 3.0
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.refreshData()
        Timer.scheduledTimer(timeInterval: pollServerInterval, target: self, selector: #selector(self.refreshData), userInfo: nil, repeats: true)
        self.mapView.delegate = self
        mapView.showsUserLocation = true
        self.addPoints()
        self.drawLines()
        
        self.centerSelf()
    }
    
    
    func drawLines()
    {
        self.polylines = MKPolyline(coordinates: &path, count: path.count)
        print(polylines)
        
        self.mapView.add(self.polylines)

    }
   
    
    func addStops()
    {
        
        
    }
    
    
    //NEED A WAY TO REMOVE OLD TROLLEYS STORE IN MEMORY
    //LETS KEEP TRACK OF THEIR ENTIRE PATH???? OR JUST A LIST OF POINTS
    //TODO: Clear old trolleys from memory.
    //TODO: Use a map to find and compare trolleys based on ID number.
    
    func updateTrolleys(trolleyList: [Trolley])
    {
        if (trolleys != nil)
        {
            for trolley in trolleyList
            {
                for trolleysInMember in trolleys!
                {
                    if(trolley == trolleysInMember)
                    {
                        if(!(trolleysInMember.currentLocation == trolley.currentLocation)){
                            trolleysInMember.lastUpdated = Date()
                            trolleysInMember.locations.append(trolley.currentLocation)
                            trolleysInMember.currentLocation = trolley.currentLocation
                        }
                    }
                }
            }
        }
        else
        {
            trolleys = trolleyList
        }
       
        placeTrolleys()
        drawHeading()
    }
   
    func placeTrolleys()
    {
        for trolley in trolleys!
        {
            let annote = MKPointAnnotation.init()
            annote.coordinate = trolley.locations.last?.coordinate ?? CLLocationCoordinate2D()
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annote)
            }
            
        }
    }
    
    //TODO: Draw an actual heading, via an arrow possibly or the updated trolley graphic.
    //Currently shows a trail rather than a heading.
    func drawHeading()
    {
        if headingLine != nil {
            for overlayToRemove in self.mapView.overlays {
                if(overlayToRemove as! MKPolyline != polylines)
                {
                    self.mapView.remove(overlayToRemove)
                }
            }
        }
        for trolley in trolleys!
        {
            if(trolley.locations.count > 1)
            {
                var coordinates = [CLLocationCoordinate2D]()
                let lastIndex = trolley.locations.endIndex
                coordinates.append(trolley.locations[lastIndex-2].coordinate)
                coordinates.append(trolley.locations[lastIndex-1].coordinate)
                
                headingLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
                mapView.add(headingLine!)
            }
        }
    }
    
    
    func centerSelf()
    {
        #if arch(i386) || arch(x86_64)
            let mapCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 32.807928, longitude: -96.796825)
        #else
            let mapCenter: CLLocationCoordinate2D = (self.locationManager.location?.coordinate)!
        #endif
        
        let regionRadius: CLLocationDistance = 2000
        let mapMKCenter = MKCoordinateRegionMakeWithDistance(mapCenter, regionRadius, regionRadius)
        self.mapView.setRegion(mapMKCenter, animated: true)
    }
    
    
    func placeAnnotation(lat: Double, long: Double)
    {
        let annote = MKPointAnnotation.init()
        annote.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annote)
        }
    }
    
    func placeAnnotation(location: CLLocation)
    {
        let annote = MKPointAnnotation.init()
        annote.coordinate = location.coordinate
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annote)
        }
        
    }
    
    func refreshData()
    {
        print("Data refreshing")
        let mataUrl = "http://track.mata.org:7170/allCars"
        
        let url = URL(string:mataUrl)
        
        let task = URLSession.shared.dataTask(with: url!)
        {
            
            (data, response, error) -> Void in
            
            let httpURLResponse = response as? HTTPURLResponse
            if( httpURLResponse?.statusCode == 200 )
            {
                do
                {
                    DispatchQueue.main.async {
                        self.mapView.removeAnnotations(self.mapView.annotations)
                    }
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: AnyObject] {
                        
                        var trolleyList: [Trolley] = [Trolley]()
                        
                        for item in json
                        {
                            if(item.key.lengthOfBytes(using: String.Encoding.utf8) < 4)
                            {
                                print(item.key)
                                let arraytype = item.value as! Array<AnyObject>
                                let lats = arraytype[0]
                                let longs = arraytype[1]
                           
                                let location = CLLocation(latitude: lats as! Double, longitude: longs as! Double)
                                let trolley = Trolley(id: Int(item.key)!, location: location)
                                
                                trolleyList.append(trolley)
                            }
                        }
                        self.updateTrolleys(trolleyList: trolleyList)
                    }
                }
                catch {
                    print("Error with Json: \(error)")
                }
            }
            else {
                
                
            }
        }
        task.resume()
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        print(coord.latitude)
        print(coord.longitude)
    }
    
    
    //MARK:- IBActions
    @IBAction func CenterMe(_ sender: UIButton) {
        self.centerSelf()
    }
    
    
    //MARK:- MapViewDelegate methods
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline && overlay as? MKPolyline == headingLine {
            
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.red
            polylineRenderer.fillColor = UIColor.red
            polylineRenderer.lineWidth = 2
            polylineRenderer.alpha = 0.8
            return polylineRenderer
            
        }
        else if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.purple
            polylineRenderer.fillColor = UIColor.red
            polylineRenderer.lineWidth = 2
            polylineRenderer.alpha = 0.8
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    
    //These points make up the track.
    func addPoints()
    {
        //TODO: Move this to info.plist or somewhere else suitable.
        self.path.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(32.801866), longitude: CLLocationDegrees(-96.800921)))
        self.path.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(32.807605), longitude: CLLocationDegrees(-96.797218)))
        self.path.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(32.807928), longitude: CLLocationDegrees(-96.796825)))
        self.path.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(32.80555), longitude: CLLocationDegrees(-96.79408700000002)))
        self.path.append(CLLocationCoordinate2D(latitude: 32.80558, longitude: -96.79405200000001))
        self.path.append(CLLocationCoordinate2D(latitude: 32.807965, longitude: -96.796784))
        self.path.append(CLLocationCoordinate2D(latitude: 32.808701, longitude: -96.79587))
        self.path.append(CLLocationCoordinate2D(latitude: 32.809536, longitude: -96.796814))
        self.path.append(CLLocationCoordinate2D(latitude: 32.807955, longitude: -96.798829))
        self.path.append(CLLocationCoordinate2D(latitude: 32.8071, longitude: -96.799828))
        self.path.append(CLLocationCoordinate2D(latitude: 32.806619, longitude: -96.799275))
        self.path.append(CLLocationCoordinate2D(latitude: 32.805047, longitude: -96.80029))
        self.path.append(CLLocationCoordinate2D(latitude: 32.803497, longitude: -96.801327))
        self.path.append(CLLocationCoordinate2D(latitude: 32.802399, longitude: -96.802053))
        self.path.append(CLLocationCoordinate2D(latitude: 32.801826, longitude: -96.802391))
        self.path.append(CLLocationCoordinate2D(latitude: 32.800725, longitude: -96.801144))
        self.path.append(CLLocationCoordinate2D(latitude: 32.800448, longitude: -96.80093))
        self.path.append(CLLocationCoordinate2D(latitude: 32.800163, longitude: -96.800837))
        self.path.append(CLLocationCoordinate2D(latitude: 32.799744, longitude: -96.800919))
        self.path.append(CLLocationCoordinate2D(latitude: 32.797646, longitude: -96.801428))
        self.path.append(CLLocationCoordinate2D(latitude: 32.795088, longitude: -96.802172))
        self.path.append(CLLocationCoordinate2D(latitude: 32.792926, longitude: -96.80288800000001))
        self.path.append(CLLocationCoordinate2D(latitude: 32.791663, longitude: -96.803337))
        self.path.append(CLLocationCoordinate2D(latitude: 32.789312, longitude: -96.804016))
        self.path.append(CLLocationCoordinate2D(latitude: 32.788596, longitude: -96.80315200000001))
        self.path.append(CLLocationCoordinate2D(latitude: 32.788087, longitude: -96.802504))
        self.path.append(CLLocationCoordinate2D(latitude: 32.78612, longitude: -96.800205))
        self.path.append(CLLocationCoordinate2D(latitude: 32.784398, longitude: -96.798264))
        self.path.append(CLLocationCoordinate2D(latitude: 32.784347, longitude: -96.798114))
        self.path.append(CLLocationCoordinate2D(latitude: 32.784379, longitude: -96.797961))
        self.path.append(CLLocationCoordinate2D(latitude: 32.784431, longitude: -96.797831))
        self.path.append(CLLocationCoordinate2D(latitude: 32.784518, longitude: -96.797697))
        self.path.append(CLLocationCoordinate2D(latitude: 32.785051, longitude: -96.797057))
        self.path.append(CLLocationCoordinate2D(latitude: 32.785577, longitude: -96.79669500000001))
        self.path.append(CLLocationCoordinate2D(latitude: 32.78566200000001, longitude: -96.796515))
        self.path.append(CLLocationCoordinate2D(latitude: 32.785738, longitude: -96.796344))
        self.path.append(CLLocationCoordinate2D(latitude: 32.785849, longitude: -96.79626300000001))
        self.path.append(CLLocationCoordinate2D(latitude: 32.785965, longitude: -96.796281))
        self.path.append(CLLocationCoordinate2D(latitude: 32.786035, longitude: -96.796364))
        self.path.append(CLLocationCoordinate2D(latitude: 32.786139, longitude: -96.796555))
        self.path.append(CLLocationCoordinate2D(latitude: 32.786868, longitude: -96.797337))
        self.path.append(CLLocationCoordinate2D(latitude: 32.787655, longitude: -96.798363))
        self.path.append(CLLocationCoordinate2D(latitude: 32.787863, longitude: -96.798653))
        self.path.append(CLLocationCoordinate2D(latitude: 32.788047000000006, longitude: -96.79893900000002))
        self.path.append(CLLocationCoordinate2D(latitude: 32.788266, longitude: -96.799532))
        self.path.append(CLLocationCoordinate2D(latitude: 32.788431, longitude: -96.799783))
        self.path.append(CLLocationCoordinate2D(latitude: 32.788918, longitude: -96.800427))
        self.path.append(CLLocationCoordinate2D(latitude: 32.789342, longitude: -96.800946))
        self.path.append(CLLocationCoordinate2D(latitude: 32.789875, longitude: -96.80152))
        self.path.append(CLLocationCoordinate2D(latitude: 32.791487, longitude: -96.803248))
        self.path.append(CLLocationCoordinate2D(latitude: 32.791631, longitude: -96.803289))
        self.path.append(CLLocationCoordinate2D(latitude: 32.792908, longitude: -96.802836))
        self.path.append(CLLocationCoordinate2D(latitude: 32.79508, longitude: -96.802138))
        self.path.append(CLLocationCoordinate2D(latitude: 32.79764, longitude: -96.801398))
        self.path.append(CLLocationCoordinate2D(latitude: 32.799732, longitude: -96.800865))
        self.path.append(CLLocationCoordinate2D(latitude: 32.80024, longitude: -96.800755))
        self.path.append(CLLocationCoordinate2D(latitude: 32.801715, longitude: -96.800966))
        self.path.append(CLLocationCoordinate2D(latitude: 32.801808, longitude: -96.80095))
        self.path.append(CLLocationCoordinate2D(latitude: 32.801866, longitude: -96.800921))
        
        
    }

    
}


extension CLLocation {
    
    static func == (left: CLLocation, right: CLLocation) -> Bool
    {
        if(left.coordinate.latitude == right.coordinate.latitude
            && left.coordinate.longitude == right.coordinate.longitude) {
            return true
        }
        else {
            return false
        }
    }
   
    
    //Logic needs to be updated.
    static func != (left: CLLocation, right: CLLocation) -> Bool
    {
        if(left.coordinate.latitude != right.coordinate.latitude
            || left.coordinate.longitude != right.coordinate.longitude) {
            return false
        }
        else {
            return false
        }
        
    }
        
}
