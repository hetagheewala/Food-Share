//
//  RegestrationVC.swift
//  FoodShare
//
//  Created by Student on 4/26/17.
//  Copyright © 2017 Heta Gheewala. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation

class RegestrationVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
    
    var ref:FIRDatabaseReference?
    
    var errorMsg:String? = ""
    var foods:[Food] = []
    
    var statePickerValue = "AL"
    
    var agree:Bool = false
    
    //agree to use app
    let agreeMsg:String = "By using this FoodShare App, you agree to accept these terms and conditions, so please be sure to read them carefully.  If you do not agree with them, please do not use the App.  We reserve the right, at our discretion, to change, modify, add or remove portions of these terms and conditions at any time.  Please check this page periodically for changes.  Unless the law requires otherwise, your continued use of the App following the posting of changes to these terms will mean that you accept those changes."
    
    // state picker fill up
    var stateList = 	["AL","AK","AS","AZ","AR","CA","CO","CT","DE","DC","FM","FL","GA","GU","HI","ID","IL","IN","IA","KS","KY","LA","ME","MH","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","MP","OH","OK","OR","PW","PA","PR","RI","SC","SD","TN","TX","UT","VT","VI","VA","WA","WV","WI","WY"]
    
    // security question picker fill up
    var securityQueList = ["In what city or town did your mother and father meet?","What is your favorite team?","What is your mother's maiden name?","What was the make and model of your first car?","In what city were you born?","What is the name of your favorite pet?","What high school did you attend?"]
    
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var streetAptno: UITextField!
    @IBOutlet weak var city:UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repassword: UITextField!
    @IBOutlet weak var secutiryQueText: UITextField!
    @IBOutlet weak var securityAns: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var acceptTerms: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var securityQueDropdown: UIPickerView!
    @IBOutlet weak var state: UIPickerView!
    
    
    // accept terms to use app
    @IBAction func acceptTerms(_ sender: Any) {
        let regTerms = UIAlertController(title: "Terms & Conditions", message: agreeMsg, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default){(ACTION) in
            self.agree = true
        }
        
        let declineAction = UIAlertAction(title: "Decline", style: .cancel){(ACTION) in
            self.agree = false
        }
        
        regTerms.addAction(acceptAction)
        regTerms.addAction(declineAction)
        present(regTerms, animated: true, completion: nil)
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToCancelLogin", sender: self)
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
      validateRegestration()
        
        //Authentication
        if(errorMsg == ""){
        
        if let email = emailId.text, let password = password.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if (error == nil) {
                    print("Registered")
                    
                    let userName = self.firstName.text! + self.lastName.text!
                    
                    self.ref = FIRDatabase.database().reference()
                    
                    self.ref?.child("Registration").child(userName).child("lastName").setValue(self.lastName.text!)
                    
                    self.ref?.child("Registration").child(userName).child("firstName").setValue(self.firstName.text)
                    self.ref?.child("Registration").child(userName).child("street").setValue(self.streetAptno.text)
                    self.ref?.child("Registration").child(userName).child("city").setValue(self.city.text)
                    self.ref?.child("Registration").child(userName).child("state").setValue(self.statePickerValue)
                    self.ref?.child("Registration").child(userName).child("zipCode").setValue(self.zipCode.text)
                    self.ref?.child("Registration").child(userName).child("mobile").setValue(self.mobile.text)
                    self.ref?.child("Registration").child(userName).child("emailId").setValue(self.emailId.text)
                    self.ref?.child("Registration").child(userName).child("password").setValue(self.password.text)
                    self.ref?.child("Registration").child(userName).child("securityQue").setValue(self.secutiryQueText.text)
                    self.ref?.child("Registration").child(userName).child("securityAns").setValue(self.securityAns.text)
                    self.loadDataFromPlist()
                
                   self.performSegue(withIdentifier: "GoToMainReg", sender: nil)
                }
                else{
                    print("Registration Problem")
                }
            }
        }
    }
    }
    
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
    

    //State Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        var data = ""
        if(pickerView.tag == 0){
            data = stateList[row]
        }
        if(pickerView.tag == 1) {
            data = securityQueList[row]
        }
        
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightRegular)])
        label?.attributedText = title
        label?.textAlignment = .center
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 0) {
            return stateList.count
        }
        if(pickerView.tag == 1) {
            return securityQueList.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0) {
            return stateList[row]
        }
        if(pickerView.tag == 1) {
            self.view.endEditing(true)
            return securityQueList[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1) {
            self.secutiryQueText.text = self.securityQueList[row]
            self.securityQueDropdown.isHidden = true
        }
        if(pickerView.tag == 0){
            statePickerValue =  stateList[row] as String
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.secutiryQueText! {
            self.securityQueDropdown.isHidden = false
        }
    }
    
    //Regestartion validation
    func validateRegestration(){
        
        errorMsg = ""
        
        lastName.resignFirstResponder()
        firstName.resignFirstResponder()
        streetAptno.resignFirstResponder()
        city.resignFirstResponder()
        zipCode.resignFirstResponder()
        mobile.resignFirstResponder()
        emailId.resignFirstResponder()
        password.resignFirstResponder()
        repassword.resignFirstResponder()
        secutiryQueText.resignFirstResponder()
        securityAns.resignFirstResponder()
        
        
        let nameRegEx = "[a-zA-Z]{2,30}"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        if(!nameTest.evaluate(with: firstName.text)){
            errorMsg = errorMsg! + "Please enter valid first name.\n"
        }
        if(!nameTest.evaluate(with: lastName.text)){
            errorMsg = errorMsg! + "Please enter valid last name.\n"
        }
        
        let addrRegEx = "\\d+[ ](?:[A-Za-z0-9.-]+[ ]?)+(?:Avenue|Lane|Road|Boulevard|Drive|Street|Ave|Dr|Rd|Blvd|Ln|St|avenue|lane|road|boulevard|drive|street|ave|dr|rd|blvd|sn|st)\\.?"
        let addrTest = NSPredicate(format:"SELF MATCHES %@", addrRegEx)
        if(!addrTest.evaluate(with: streetAptno.text)){
            errorMsg = errorMsg! + "Please enter valid street address.\n"
        }
        
        let cityRegEx = "^[a-zA-Z]+(?:[\\s-][a-zA-Z]+)*$"
        let cityTest = NSPredicate(format:"SELF MATCHES %@", cityRegEx)
        if(!cityTest.evaluate(with: city.text)){
            errorMsg = errorMsg! + "Please enter valid city.\n"
        }
        
        let zipRegEx =  "^\\d{5}(?:[-\\s]\\d{4})?$"
        let zipTest = NSPredicate(format:"SELF MATCHES %@", zipRegEx)
        if(!zipTest.evaluate(with: zipCode.text)){
            errorMsg = errorMsg! + "Please enter valid zip code.\n"
        }
        
        if((mobile.text?.characters.count)! != 10){
            errorMsg = errorMsg! + "Please enter valid mobile number.\n"
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if(!emailTest.evaluate(with: emailId.text)){
            errorMsg = errorMsg! + "Please enter valid email id.\n"
        }
        
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        if(!passwordTest.evaluate(with: password.text)){
            errorMsg = errorMsg! + "Please enter correct password. Make sure minimum lenght 8 charaters and one number.\n"
        }
        
        if(password.text != repassword.text){
            errorMsg = errorMsg! + "Password and confirm password id must be same.\n"
        }
        
        if(secutiryQueText.text == "") {
            errorMsg = errorMsg! + "Please select atleast one security question.\n"
        }
        
        if(securityAns.text == "") {
            errorMsg = errorMsg! + "Please enter security answer to selected question.\n"
        }
        
        if(agree == false) {
            errorMsg = errorMsg! + "Please accept terms & conditions to use the app.\n"
        }
        
        print("Error : \(errorMsg!)")
        
        if (errorMsg != "") {
            let regError = UIAlertController(title: "Invalid Regestration", message: errorMsg, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            regError.addAction(OKAction)
            regError.addAction(CancelAction)
            present(regError, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.state.dataSource = self
        self.state.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

    
