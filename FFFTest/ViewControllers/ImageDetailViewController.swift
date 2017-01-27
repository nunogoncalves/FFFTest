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

    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var loadingContainer: UIView!
    @IBOutlet fileprivate weak var stateLabel: UILabel!
    @IBOutlet fileprivate weak var loadingIndicator: UIActivityIndicatorView!

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
                case .failure(_):
                    self?.loadingContainer.isHidden = false
                    self?.stateLabel.text = "Failed"
                }
            }
        }
    }
    
    private func got(photoDetails: FlickrPhotoDetails) {
        titleLabel.text = photoDetails.title
        descriptionLabel.text = photoDetails.description
    }

}
