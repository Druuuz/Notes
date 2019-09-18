//
//  Note.swift
//  Notes
//
//  Created by Андрей Олесов on 9/8/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation
import UIKit

class BlackNote{
    var id:Int
    var text:String
    var date:Date
    var status:Status
    var image:UIImage?
    var remind:Date?
    
    init(id: Int, text:String, date:Date, status:Status, remind:Date?, image:UIImage?) {
        self.id = id
        self.date = date
        self.status = status
        self.text = text
        self.image = image
        self.remind = remind
    }
    
    func statusInInt()->Int16{
        switch self.status{
            
        case .normal:
            return 1
        case .specific:
            return 2
        case .important:
            return 3
        }
        
    }
    
    func statusInColor()->UIColor{
        switch self.status{
        case .important:
            return UIColor.red
        case .normal:
            return UIColor.green
        case .specific:
            return UIColor.yellow
        }
    }
}

enum Status{
    case normal
    case important
    case specific
}

extension Date{
    func toString(withTime flag:Bool)->String{
        if flag{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            return dateFormatter.string(from: self)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toLocalTimeZone()->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.date(from: self.toString(withTime: true))!
    }
    
}

extension String{
    func toDate()->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: self)
    }
    
    func toDateTime() -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.date(from: self)
    }
}

extension Int16{
    func toStatus()->Status?{
        switch self{
        case 3: return .important
        case 1: return .normal
        case 2: return .specific
        default:
            return nil
        }
    }
}
