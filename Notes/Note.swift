//
//  Note.swift
//  Notes
//
//  Created by Андрей Олесов on 9/7/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation
import UIKit
class Note{
    private var text:String
    private var date:String
    private var status:UIColor
    
    init(text:String, date:String, status:UIColor) {
        self.date = date
        self.status = status
        self.text = text
    }
}
