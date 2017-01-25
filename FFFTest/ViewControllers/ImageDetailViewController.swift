//
//  ImageDetailViewController.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var flickrPhoto: FlickrPhoto? {
        didSet {
            if let flickrPhoto = flickrPhoto {//,
//                let imageView = imageView { //if for some reason this would be set before the outlet was set...
                
                DispatchQueue.global().async {
                    let image = UIImage(data: try! Data(contentsOf: flickrPhoto.url(for: .largeLongerSide1024)))
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
