//
//  ImageDetailsViewController.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 28/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Nuke

class ImageDetailsViewController : UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var loadingContainer: UIView!
    @IBOutlet private weak var stateLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    //I'm in the process of rethinking my ideas against Storyboards because of this.
    //I don't like to have optionals around because of this. I'm pretty sure it could
    //be an IUO, but... that makes me hitchy...
    var flickrPhoto: FlickrPhoto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        
        if let flickrPhoto = flickrPhoto {
            getInfo(for: flickrPhoto)
        } else {
            killMe()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        for v in (collectionView.visibleCells as? [ScrollingImageCell])! {
            v.topInset = topLayoutGuide.length + UIApplication.shared.statusBarFrame.height
        }
    }
    
    private func getInfo(for flickrPhoto: FlickrPhoto) {
        Photos.InfoGetter(photo: flickrPhoto).getPhotoInfo { [weak self] result in
            switch result {
            case .success(let photoDetails):
                self?.got(photoDetails)
                self?.loadingContainer.isHidden = true
            case .failure(_):
                self?.loadingContainer.isHidden = false
                self?.stateLabel.text = "Failed"
            }
        }
    }
    
    private func got(_ photoDetails: FlickrPhotoDetails) {
        titleLabel.text = photoDetails.title
        descriptionLabel.text = photoDetails.description
        view.setNeedsLayout()
    }
    
}

extension ImageDetailsViewController : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ScrollingImageCell = collectionView.dequeueReusableCell(for: indexPath)
        if let flickrPhoto = flickrPhoto {
            Nuke.loadImage(with: flickrPhoto.url(for: .largeLongerSide1024), into: self, handler: { response, success in
                if let image = response.value {
                    cell.image = image
                }
            })
        }
        return cell
    }
}

extension ImageDetailsViewController : UICollectionViewDelegate {
    
}

extension ImageDetailsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
}
