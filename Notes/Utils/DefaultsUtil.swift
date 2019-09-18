//
//  DefaultsUtil.swift
//  Notes
//
//  Created by Андрей Олесов on 9/18/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation

class DefaultsUtil{
    static func getNewId() -> Int{        
        if UserDefaults.standard.integer(forKey: "id") == 0 {
            UserDefaults.standard.set(1, forKey: "id")
            return 1
        } else {
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "id") + 1, forKey: "id")
            return UserDefaults.standard.integer(forKey: "id")
        }
    }
}
