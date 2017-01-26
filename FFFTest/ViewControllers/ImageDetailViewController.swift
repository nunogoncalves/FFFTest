//
//  ImageDetailViewController.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Nuke

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loadingContainer: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var flickrPhoto: FlickrPhoto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flickrPhoto = flickrPhoto {
            Nuke.loadImage(with: flickrPhoto.url(for: .largeLongerSide1024), into: imageView)
            
            Photos.InfoGetter(photo: flickrPhoto).getPhotoInfo { [weak self] result in
                switch result {
                case .success(let photoDetails):
                    self?.got(photoDetails: photoDetails)
                    self?.loadingContainer.isHidden = true
                case .failure(let _):
                    self?.loadingContainer.isHidden = false
                    self?.loadingLabel.text = "Failed"
                }
            }
        }
    }
    
    private func got(photoDetails: FlickrPhotoDetails) {
        titleLabel.text = photoDetails.title
        descriptionLabel.text = photoDetails.description
    }

}
