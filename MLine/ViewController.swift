
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
    
    let pollServerInterval = 5.0
    
    let trolleyTrack: Track = Track()


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
        self.drawLines()
        
        
        self.centerSelf()
    }
    
    
    func drawLines()
    {
        self.polylines = MKPolyline(coordinates: &trolleyTrack.trackPoints, count: trolleyTrack.trackPoints.count)
        print(polylines)
        
        self.mapView.add(self.polylines)

    }
   
    //Add trolley stops presumably give it, its own class.
    func addStops()
    {
        
        
    }
    
    
    //NEED A WAY TO REMOVE OLD TROLLEYS STORE IN MEMORY
    //LETS KEEP TRACK OF THEIR ENTIRE PATH???? OR JUST A LIST OF POINTS
    //TODO: Clear old trolleys from memory.
    //TODO: Use a map to find and compare trolleys based on ID number.
    //Issue regarding drawing both trolleys when they are at their night rest stop with the fi statement
    //line 88
    
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
//                        if(!(trolleysInMember.currentLocation == trolley.currentLocation)){
                            trolleysInMember.lastUpdated = Date()
                            trolleysInMember.locations.append(trolley.currentLocation)
                            trolleysInMember.currentLocation = trolley.currentLocation
//                        }
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
                                
                                print(location)
                                
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
