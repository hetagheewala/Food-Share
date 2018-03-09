//
//  Food.swift
//  FinalFoodShare
//
//  Created by Heta Gheewala on 5/6/17.
//  Copyright © 2017 Heta Gheewala. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit


class Food:NSObject,MKAnnotation{
    
    var username = ""
    var contactPerson = ""
    var contactNo = ""
    var food:String = ""
    var foodDescription:String = ""
    var alergyAdvise:String = ""
    var pickupTime:String = ""
    var street:String = ""
    var city:String=""
    var state:String=""
    var zipcode:String=""
    var location:CLLocation? = nil
    var image:String=""
    var locDistance:Double=0.0
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return location!.coordinate
        }
    }
    
    var title : String? {
        get {
            return food
        }
    }
    
    var subtitle : String? {
        get {
            let pSubTitle = "Contact Person Name: " + contactPerson
            return pSubTitle
        }
    }
    
    override var description:String {
        return "{ \n \t username:\(username) \n \t contactPerson:\(contactPerson) \n \t contactNo:\(contactNo) \n \t food:\(food) \n \t foodDescription:\(foodDescription)  \n \t alergyAdvise:\(alergyAdvise) \n \t pickupTime:\(pickupTime) \n \t location: \(String(describing: location)) \n \t image: \(image) \n \t street:\(street) \n \t city:\(city) \n \t state:\(state) \n \t zipcode: \(zipcode) \n \t locDistance: \(locDistance)  \n \t } \n"
    }
    
    init(username:String, contactPerson:String, contactNo:String, food:String, foodDescription:String, alergyAdvise:String, pickupTime:String, location:CLLocation?, image:String, street:String, city:String, state:String, zipcode:String, locDistance:Double){
        
        super.init()
        
        set(username:username)
        set(contactPerson:contactPerson)
        set(contactNo:contactNo)
        set(food:food)
        set(foodDescription:foodDescription)
        set(alergyAdvise:alergyAdvise)
        set(pickupTime:pickupTime)
        set(location:location)
        set(image:image)
        set(street:street)
        set(city:city)
        set(state:state)
        set(zipcode:zipcode)
        set(locDistance:locDistance)
    }
    
    convenience override init () {
        
        self.init(username:"Unknown", contactPerson:"Unknown", contactNo:"Unknown", food:"Unknown", foodDescription:"Unknown", alergyAdvise:"Unknown", pickupTime:"Unknown",location:nil, image:"Unknown", street: "Unknown", city: "Unknown", state: "Unknown", zipcode:"Unknown", locDistance:0.0)
    }
    
    func getUsername() -> String {
        return username
    }
    
    func set(username:String) {
        self.username = username
    }
    
    func getContactPerson() -> String {
            return contactPerson
    }
    
    func set(contactPerson:String){
        self.contactPerson = contactPerson
    }
    
    func getContactNo() -> String {
        return contactNo
    }
    
    func set(contactNo:String){
        self.contactNo = contactNo
    }
    
    func getFood() -> String {
        return food
    }
    
    func set(food:String) {
        self.food = food
    }
    
    func getfoodDescription() -> String {
        return foodDescription
    }
    
    func set(foodDescription:String) {
        self.foodDescription = foodDescription
    }
    
    func getAlergyAdvise() -> String {
        return alergyAdvise
    }
    
    func set(alergyAdvise:String) {
        self.alergyAdvise = alergyAdvise
    }
    
    func getPickupTime() -> String {
        return pickupTime
    }
    
    func set(pickupTime:String) {
        self.pickupTime = pickupTime
    }
    
    func getLocation() -> CLLocation? {
        return location
    }
    
    func set(location:CLLocation?) {
        self.location = location
    }
    
    func getImage() -> String {
        return image
    }
    
    func set(image:String) {
        self.image = image
    }
    
    func getStreet() -> String {
        return street
    }
    
    func set(street:String) {
        self.street = street
    }
    
    func getCity() -> String {
        return city
    }
    
    func set(city:String) {
        self.city = city
    }
    
    func getState() -> String {
        return state
    }
    
    func set(state:String) {
        self.state = state
    }
    
    func getZipcode() -> String {
        return zipcode
    }
    
    func set(zipcode:String) {
        self.zipcode = zipcode
    }

    func getLocDistance() -> Double {
        return locDistance
    }
    
    func set(locDistance:Double) {
        self.locDistance = locDistance
    }
}
