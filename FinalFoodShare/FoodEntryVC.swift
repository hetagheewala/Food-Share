//
//  FoodEntryVC.swift
//  FoodShare
//
//  Created by Heta Gheewala on 5/4/17.
//  Copyright © 2017 Heta Gheewala. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import KeychainSwift

class FoodEntryVC: UIViewController { //UIImagePickerControllerDelegate, UINavigationControllerDelegate

    var ref:FIRDatabaseReference?
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBAction func uploadImage(_ sender: Any) {
        //Image upload code is not working
        /*
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
         */
    }
    @IBOutlet weak var foodName: UITextField!
    
    @IBOutlet weak var foodDescription: UITextView!
    
    @IBOutlet weak var alergyAdvise: UITextField!
    
    @IBOutlet weak var pickuptime: UITextField!
    
    @IBOutlet weak var street: UITextField!
    
    @IBOutlet weak var city: UITextField!

    @IBOutlet weak var state: UITextField!

    @IBOutlet weak var zipcode: UITextField!
    
    @IBAction func cancel(_ sender: UIButton) {
    }
    
    @IBAction func shareFood(_ sender: UIButton) {
        
        foodName.resignFirstResponder()
        foodDescription.resignFirstResponder()
        alergyAdvise.resignFirstResponder()
        pickuptime.resignFirstResponder()
        street.resignFirstResponder()
        city.resignFirstResponder()
        state.resignFirstResponder()
        zipcode.resignFirstResponder()
        
        if (foodName.text != "" && foodDescription.text != "" && pickuptime.text != "" && street.text != "" && city.text != "" && state.text != "" && zipcode.text != "" && alergyAdvise.text != ""){
        
        let dbFoodName = foodName.text! + String(describing: NSDate())
            
        //Database insert 
            
        ref = FIRDatabase.database().reference()
        ref?.child("SharedFood").child(dbFoodName).child("food").setValue(foodName.text)
        ref?.child("SharedFood").child(dbFoodName).child("foodDescription").setValue(foodDescription.text)
        ref?.child("SharedFood").child(dbFoodName).child("allergyAdvise").setValue(alergyAdvise.text)
        ref?.child("SharedFood").child(dbFoodName).child("pickUpTimings").setValue(pickuptime.text)
        ref?.child("SharedFood").child(dbFoodName).child("street").setValue(street.text)
        ref?.child("SharedFood").child(dbFoodName).child("city").setValue(city.text)
        ref?.child("SharedFood").child(dbFoodName).child("state").setValue(state.text)
        ref?.child("SharedFood").child(dbFoodName).child("zipCode").setValue(zipcode.text)
       
        let foodSave = UIAlertController(title: "Food Shared", message: "Thank you sharing food", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) {(ACTION) in
                self.foodName.text = ""
                self.foodDescription.text = ""
                self.alergyAdvise.text = ""
                self.pickuptime.text = ""
                self.street.text = ""
                self.city.text = ""
                self.state.text = ""
                self.zipcode.text = ""
            }
       
        foodSave.addAction(OKAction)
        present(foodSave, animated: true, completion: nil)
        }
        else { // incomplete info
            let foodSave = UIAlertController(title: "Incomplete Info", message: "Please fill up proper food detail", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            foodSave.addAction(OKAction)
            present(foodSave, animated: true, completion: nil)
        }
    }
    
    //Image upload code is not working
    /*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        foodImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
