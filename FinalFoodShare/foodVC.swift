//
//  foodVC.swift
//  FoodShare
//
//  Created by Heta Gheewala on 5/4/17.
//  Copyright © 2017 Heta Gheewala. All rights reserved.
//

import UIKit
import MapKit

class foodVC: UITableViewController, CLLocationManagerDelegate {

    var foodList = Foods()
    var mapVC = MapVC()
    
    var locationManager : CLLocationManager?
    var location: CLLocation?

    
    var foods : [Food] {
        get {
            return self.foodList.foodList
        }
        set(val){
            self.foodList.foodList = val
        }
    }
    
    // distance from current colcation to food share person
    func calculateDistance() {
        
        for f in foods {
            let point1 = MKMapPointForCoordinate((location!.coordinate))
            let point2 = MKMapPointForCoordinate(f.coordinate)
            let distance = MKMetersBetweenMapPoints(point1, point2)
            f.set(locDistance: (distance * 0.000621371))
        }
        
        foods.sort(by: {$0.getLocDistance() < $1.getLocDistance()})
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(foods)
        locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager!.requestWhenInUseAuthorization()
        }
    
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.responds(to: #selector (CLLocationManager.requestWhenInUseAuthorization)) {
                locationManager!.requestAlwaysAuthorization()
            }
        }
        
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.startUpdatingLocation()
        locationManager!.delegate = self

    }
    
    
    // location manager 
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let errorAlert = UIAlertController(title:"Error", message:"Failed to get your location", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){(ACTION) in
            self.calculateDistance()
        }
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        locationManager!.stopUpdatingLocation()
        calculateDistance()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
        // Configure the cell...
        let food = foods[indexPath.row]
        cell.textLabel?.text = food.food
        cell.detailTextLabel?.text = "Distance: " + String(format: "%.2f",(food.locDistance)) + " miles"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = foods[indexPath.row]
        let detailVC = foodDetailVC(style: .grouped)
        detailVC.title = food.title
        detailVC.food = food
        detailVC.zoomDelegate = mapVC
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
