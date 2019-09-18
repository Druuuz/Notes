//
//  FullScreenViewController.swift
//  Notes
//
//  Created by Андрей Олесов on 9/17/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController, UIScrollViewDelegate {
    
    var imageForDisplay:UIImage?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageForDisplay
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.5
        scrollView.minimumZoomScale = 1.0
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.zoomScale = 1.0
        })
    }
}
