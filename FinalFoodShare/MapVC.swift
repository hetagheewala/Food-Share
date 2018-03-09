//
//  MapVC.swift
//  FinalFoodShare
//
//  Created by Heta Gheewala on 5/6/17.
//  Copyright © 2017 Heta Gheewala. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Contacts

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,ZoomingProtocol {
    
    var locationManager : CLLocationManager?
    var location: CLLocation?
    
    var foodList = Foods()
    var foods : [Food] {
        get {
            return self.foodList.foodList
        }
        set(val) {
            self.foodList.foodList = val
        }
    }
    
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //zooming protocol
    func zoomOnAnnotation(_ annotation:MKAnnotation){
        tabBarController?.selectedViewController = self
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 5000, 5000)
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func startUpdatingLocation(){
        locationManager!.startUpdatingLocation()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
    }
    
    func stopUpdatingLocation(){
        locationManager!.stopUpdatingLocation()
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager!.requestWhenInUseAuthorization()
        }
        
        mapView.addAnnotations(foods)
        mapView.delegate = self
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.responds(to: #selector (CLLocationManager.requestWhenInUseAuthorization)) {
                locationManager!.requestAlwaysAuthorization()
            }
        }
        
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.startUpdatingLocation()
        activityIndicator.startAnimating()
        locationManager!.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let errorAlert = UIAlertController(title:"Error", message:"Failed to get your location", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        activityIndicator.stopAnimating()
        locationManager!.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case.authorizedAlways:
            locationManager!.startUpdatingLocation()
        case.notDetermined:
            locationManager!.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .restricted, .denied:
            let alertController = UIAlertController(title: "Background Location Access Disabled", message: "In order to keep updateing location for this app, please open this app's setting and set location access to always", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Setting", style: .default){
                (ACTION) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
            alertController.addAction(openAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - MKMapViewDelegate Methods
    
    // This delegate method is called once for every annotation that is created.
    // If no view is returned by this method, then only the default pin is seen by the user
    func mapView(_ mv: MKMapView, viewFor  annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView
        let identifier = "Pin"
        
        if annotation is MKUserLocation {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        if annotation !== mv.userLocation   {
            //look for an existing view to reuse
            if let dequeuedView = mv.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.pinTintColor = MKPinAnnotationView.purplePinColor()
                view.animatesDrop = true
                view.canShowCallout = true
                let leftButton = UIButton(type: .infoLight)
                let rightButton = UIButton(type: .detailDisclosure)
                leftButton.tag = 0
                rightButton.tag = 1
                view.leftCalloutAccessoryView = leftButton
                view.rightCalloutAccessoryView = rightButton
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mv: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let foodAnnotation = view.annotation as! Food
        switch control.tag {
        case 0: //left button - call to contact person
            if let url = URL(string:"tel://\(foodAnnotation.getContactNo())"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        case 1: //right button
            let fromPlacePlaceMark =  MKPlacemark(coordinate: (foodAnnotation.getLocation()?.coordinate)!)
            let addressDict = fromPlacePlaceMark.addressDictionary
            let place = MKPlacemark(coordinate: (foodAnnotation.getLocation()?.coordinate)!, addressDictionary: addressDict as? [String : Any])
            let mapItem = MKMapItem(placemark: place)
            let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
            mapItem.name = foodAnnotation.getFood()
            mapItem.openInMaps(launchOptions: options)
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.addAnnotations(foods)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.addAnnotations(foods)
    }
    
}
