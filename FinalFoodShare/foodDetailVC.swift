//
//  foodDetailVC.swift
//  FoodShare
//
//  Created by Heta Gheewala on 5/4/17.
//  Copyright © 2017 Heta Gheewala. All rights reserved.
//

import UIKit
import MapKit

class foodDetailVC: UITableViewController, CLLocationManagerDelegate {
    
    var zoomDelegate: ZoomingProtocol?
    
    let FOODDETAIL_SECTION = 0
    let IMAGE_SECTION = 1
    let USER_SECTION = 2
    let SHOWONMAP_SECTION = 3
    
    var food:Food!
    var foodImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case FOODDETAIL_SECTION:
            return 4
        case USER_SECTION:
            return 2
        default:
            break;
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if !(cell != nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        
        // Configure the cell...
        
        switch indexPath.section{
        case FOODDETAIL_SECTION:
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Food: " + food.food
            }
            if indexPath.row == 1 {
                cell?.textLabel?.text = "Description: " + food.foodDescription
            }
            if indexPath.row == 2 {
                cell?.textLabel?.text = "Alergy Advise: " + food.alergyAdvise
            }
            if indexPath.row == 3 {
                cell?.textLabel?.text = "Food PickUp Time: " + food.pickupTime
            }
        case IMAGE_SECTION:
            cell?.imageView?.image = UIImage(named: food.image)
        case USER_SECTION:
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Contact Person: " + food.contactPerson
            }
            if indexPath.row == 1 {
                cell?.textLabel?.text = "Contact No: " + food.contactNo
            }
        case SHOWONMAP_SECTION:
            cell?.textLabel?.text = "Show On Map"
            cell?.textLabel?.textAlignment = .center
        default:
            break;
        }
        cell?.textLabel?.numberOfLines = 0
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            zoomDelegate?.zoomOnAnnotation(food)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
