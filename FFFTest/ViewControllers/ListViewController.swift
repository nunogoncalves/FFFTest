//
//  ViewController.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    fileprivate let userSearcher = Users.Searcher()
    fileprivate var photos: [FlickrPhoto] = []
    fileprivate var lastNameSearched = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func searchUser(named name: String) {
        //"ryanlsmith"
        userSearcher.search(by: name) { result in
            switch result {
            case .success(let user):
                self.loadPhotos(for: user)
            case .failure(let error):
                print(error) //TODO handle error
            }
        }
    }
    
    private func loadPhotos(for user: User) {
//        let user = User(id: "62060901@N06", userName: "ryanlsmith")
        Users.PublicPhotosGetter(user: user).getPublicPhotos() { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                self?.photosCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImageDetailsSegue",
            let detailsViewController = segue.destination as? ImageDetailViewController,
            let selectedIndexPath = photosCollectionView.indexPathsForSelectedItems?.first{
            detailsViewController.flickrPhoto = photos[selectedIndexPath.item]
        }
    }

    
}

extension ListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text,
            !searchText.characters.isEmpty,
            lastNameSearched != searchText {
            lastNameSearched = searchText
            searchUser(named: searchText)
            searchBar.resignFirstResponder()
        }
    }
    
}

extension ListViewController : UICollectionViewDataSource {
    
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
