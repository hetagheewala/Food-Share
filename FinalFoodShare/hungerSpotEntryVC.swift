//
//  hungerSpotEntryVC.swift
//  FoodShare
//
//  Created by Heta Gheewala on 5/4/17.
//  Copyright © 2017 Heta Gheewala. All rights reserved.
//

import UIKit

class hungerSpotEntryVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var hungerSpotPicker: UIPickerView!
    
    @IBOutlet weak var hungerSpot: UITextField!
    
    @IBAction func viewSpot(_ sender: UIButton) {
    }
    
    @IBAction func addSpot(_ sender: Any) {
    }
    
    var hungerspotList = 	["Rag picker communities","Slums","Orphanages and shelter for aged without any support","Road side dwellers and underprivileged workers"]
    
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
       
        data = hungerspotList[row]
        
        
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightRegular)])
        label?.attributedText = title
        label?.textAlignment = .center
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hungerspotList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return hungerspotList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.hungerSpot.text = self.hungerspotList[row]
        self.hungerSpotPicker.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.hungerSpot! {
            self.hungerSpotPicker.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hungerSpotPicker.dataSource = self
        self.hungerSpotPicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
