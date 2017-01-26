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
    
    private let collectionViewLayout = UICollectionViewFlowLayout()
    
    private let defaultRowsCountPerLine = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewLayout.minimumInteritemSpacing = 1
        applyItemSize(basedOn: traitCollection)
        photosCollectionView.collectionViewLayout = collectionViewLayout
    }
    
    private func applyItemSize(basedOn newTraitCollection: UITraitCollection) {
        let numberOfItems = CGFloat(rowsPerHorizontalSizeClass[newTraitCollection.horizontalSizeClass] ?? defaultRowsCountPerLine)
        
        let itemWitdh = view.frame.width / numberOfItems - (numberOfItems - 1)
        collectionViewLayout.itemSize = CGSize(width: itemWitdh, height: itemWitdh)
    }
    
    private lazy var rowsPerHorizontalSizeClass: [UIUserInterfaceSizeClass : Int] = {
        return [
            .compact : self.defaultRowsCountPerLine,
            .regular: 7
        ]
    }()
    
    private func numberOfItemsPerRow(for horizontalSizeClass: UIUserInterfaceSizeClass) -> Int {
        if horizontalSizeClass == .compact {
            return 5
        } else {
            return 7
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        applyItemSize(basedOn: newCollection)
    }
    
    fileprivate func searchUser(named name: String) {
        //TODO: Wrap this on a DispatchGroup of two calls. User and photos.
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
        let cell: PhotoCell = collectionView.dequeueReusableCell(for: indexPath)
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
