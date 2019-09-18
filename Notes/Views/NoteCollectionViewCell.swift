//
//  NoteCollectionViewCell.swift
//  Notes
//
//  Created by Андрей Олесов on 9/7/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UIView!
    @IBOutlet weak var underLine: UIView!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var clock: UIImageView!
    
    func setColor(color: UIColor){
        status.backgroundColor = color
        underLine.backgroundColor = color
        leftLine.backgroundColor = color
        rightLine.backgroundColor = color
    }
}
