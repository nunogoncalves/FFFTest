//
//  ViewController.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Nuke

class ListViewController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    fileprivate let userSearcher = Users.Searcher()
    fileprivate var photoSet = PhotoSet.empty
    fileprivate var lastNameSearched = ""
    fileprivate var user: User?
    
    fileprivate func searchUser(named name: String) {
        userSearcher.search(by: name) { result in
            switch result {
            case .success(let user):
                self.user = user
                self.loadPhotos(for: user)
            case .failure(let error):
                print(error) //TODO handle error
            }
        }
    }
    
    fileprivate func loadPhotos(for user: User, in page: Int = 0) {
        Users.PublicPhotosGetter(user: user).getPublicPhotos(in: page) { [weak self] result in
            guard let s = self else { return }
            switch result {
            case .success(let photoSet):
                if photoSet.isFirstPage {
                    s.photoSet = photoSet
                } else {
                    var currentPhotosList = s.photoSet.photos
                    currentPhotosList.append(contentsOf: photoSet.photos)
                    s.photoSet = PhotoSet(currentPage: photoSet.currentPage,
                                          totalPages: photoSet.totalPages,
                                          photos: currentPhotosList)
                }
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
            detailsViewController.flickrPhoto = photoSet.photos[selectedIndexPath.item]
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
        return photoSet.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as PhotoCell
        let photo = photoSet.photos[indexPath.item]
        
        Nuke.loadImage(with: photo.url(for: .minuatureLongerSide100), into: cell.photoImageView)
        return cell
    }
    
}

extension ListViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let user = user, indexPath.item == photoSet.photos.count - 20 { //TODO make this a more generic value
            loadPhotos(for: user, in: photoSet.currentPage + 1)
        }
    }
}
