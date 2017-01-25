//
//  ViewController.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

//K: b79de7c934de465563915f4cba45636f
//s: 3bb75acbc67eb558

class ViewController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var photos: [FlickrPhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Users.Searcher().search(by: "ryanlsmith") { result in
            print(result)
        }
        
        let user = User(id: "62060901@N06", userName: "ryanlsmith")
        Users.PublicPhotosGetter(user: user).getPublicPhotos() { [weak self] result in
            switch result {
            case .success(let photos):
                print("success yay")
                self?.photos = photos
                self?.photosCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension ViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.item]
        
        DispatchQueue.global().async {
            let image = UIImage(data: try! Data(contentsOf: photo.url(for: .minuatureLongerSide100)))
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        }
        
        return cell
    }
    
}
