//
//  ViewController.swift
//  FoodShare
//
//  Created by Heta Gheewala on 4/15/17.
//  Copyright © 2017 Heta Gheewala. All rights reserved.
//

import UIKit
import Firebase     //To setup firebase dynamic console setup for realtime authorization
import FirebaseDatabase   //firebase database import
import CoreLocation

class LoginVC: UIViewController {

    var errorMsg:String? = ""
    var viewController:UIViewController?
    var foods:[Food] = []
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
  
    @IBAction func validateLogin(_ sender: UIButton) {
        
        userName.resignFirstResponder()
        password.resignFirstResponder()
        

        //database authentication
        if let email = userName.text, let password = password.text{   // firebase sign in authorization block
            FIRAuth.auth()?.signIn(withEmail: email, password: password ) { (user, error) in
                
                if error == nil { //will sign in if there was no error and user existed
                    print("User signed in.")
                    UserDefaults.standard.set(self.userName.text, forKey:"username")
                    self.loadDataFromPlist()
                    self.performSegue(withIdentifier: "GoToMain", sender: nil)
                }
                else {
                    print("Cannot sign in user.")
                    // create the alert
                    let alert = UIAlertController(title: "Login Failed!", message: "Incorrect Password or Unregistered User. Please Register.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
  
    @IBAction func Registration(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToRegestration", sender: self)
    }
    
    //load food data from plist
    func loadDataFromPlist() {
        if let path = Bundle.main.path(forResource: "FoodData", ofType: "plist") {
            
            let tempDict = NSDictionary(contentsOfFile: path)
            let tempArray = (tempDict!.value(forKey: "foods") as! NSArray) as Array
            
            for dict in tempArray {
                let username = dict["username"]! as! String
                let contactPerson = dict["ContactPerson"]! as! String
                let contactNo = dict["ContactNo"]! as! String
                let food = dict["food"]! as! String
                let foodDecription = dict["foodDescription"]! as! String
                let alergyAdvise = dict["alergyAdvise"]! as! String
                let pickupTime = dict["pickupTime"]! as! String
                let latitude = (dict["latitude"]! as! NSString).doubleValue
                let longitude = (dict["longitude"]! as! NSString).doubleValue
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let image = dict["image"]! as! String
                let street = dict["street"]! as! String
                let city = dict["city"]! as! String
                let state = dict["state"]! as! String
                let zipcode = dict["zipcode"]! as! String
                let locDistance = 0.0
                
                let f : Food = Food(username: username, contactPerson:contactPerson, contactNo:contactNo, food: food, foodDescription: foodDecription, alergyAdvise: alergyAdvise, pickupTime: pickupTime, location: location, image: image, street: street, city: city, state: state, zipcode: zipcode, locDistance: locDistance)
               
                    self.foods.append(f)
            }
            
            for f in self.foods {
                print("Food:\(f)")
            }
        }
        
        let foodsList = Foods()
        foodsList.foodList = self.foods
        
        //make tabbed application as default view controller and remove login as default controller
        let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: Bundle.main)
        let tabBarController: UITabBarController = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = tabBarController
        let tabBar = appDelegate.window?.rootViewController as? UITabBarController
        let navVC = tabBar?.viewControllers![0] as? UINavigationController
        let foodVC = navVC?.viewControllers[0] as! foodVC
        let mapVC = tabBar?.viewControllers![2] as! MapVC
        
        foodVC.foodList = foodsList
        mapVC.foodList = foodsList
        foodVC.mapVC = mapVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

