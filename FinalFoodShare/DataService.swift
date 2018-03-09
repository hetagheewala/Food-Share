//
//  DataService.swift
//  FireAuthorize
//
//  Created by Abhishek Kempanna on 5/6/17.
//  Copyright © 2017 AbhiKemp. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase // we have the user data to use to present event
import KeychainSwift   // Firebase key to store user session

let DB_BASE = FIRDatabase.database().reference()  //database reference

class DataService {
    private var _keyChain = KeychainSwift()
    private var _refDatabase = DB_BASE
    
    var keyChain : KeychainSwift{
        get{
            return _keyChain
        }
        set{
            _keyChain = newValue
        }
    }
}
