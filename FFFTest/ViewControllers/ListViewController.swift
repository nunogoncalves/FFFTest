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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    fileprivate let userSearcher = Users.Searcher()
    fileprivate var photoSet = PhotoSet.empty
    fileprivate var lastNameSearched = ""
    fileprivate var user: User?
    
    private let collectionViewLayout = UICollectionViewFlowLayout()
    
    private let defaultItemsPerRow = 5

    fileprivate var flickrImageSize: FlickrImageSize {
        switch traitCollection.horizontalSizeClass {
        case .regular: return .largeLongerSide320
        default: return .smallLongerSide240
        }
    }

    private let rowsMissingToLoadAnotherPage = 4
    fileprivate var itemsMissingToLoadAnotherPage: Int {
        let itemsPerRow = itemsPerHorizontalSizeClass[traitCollection.horizontalSizeClass] ?? defaultItemsPerRow
        return itemsPerRow * rowsMissingToLoadAnotherPage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        collectionViewLayout.minimumInteritemSpacing = 1
        applyItemSize(basedOn: traitCollection)
        photosCollectionView.collectionViewLayout = collectionViewLayout
        searchUser(named: "almsaeed22333")
    }
    
    private func applyItemSize(basedOn newTraitCollection: UITraitCollection) {
        let itemsPerRow = CGFloat(itemsPerHorizontalSizeClass[newTraitCollection.horizontalSizeClass] ?? defaultItemsPerRow)
        let itemWitdh: CGFloat
        if newTraitCollection == traitCollection {
            itemWitdh = view.frame.width / itemsPerRow - (itemsPerRow - 1)
        } else {
            itemWitdh = view.frame.height / itemsPerRow - (itemsPerRow - 1)
        }
        collectionViewLayout.itemSize = CGSize(width: itemWitdh, height: itemWitdh)
    }
    
    private lazy var itemsPerHorizontalSizeClass: [UIUserInterfaceSizeClass : Int] = {
        return [
            .compact : self.defaultItemsPerRow,
            .regular: 7
        ]
    }()
    
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        applyItemSize(basedOn: newCollection)
        photosCollectionView.reloadData()
    }
    
    fileprivate func searchUser(named name: String) {
        photoSet = PhotoSet.empty
        photosCollectionView.reloadData()
        loadingIndicator.startAnimating()
        loadingLabel.text = "Loading..."
        loadingLabel.isHidden = false
        
        //TODO: Wrap this on a DispatchGroup of two calls. User and photos.
        userSearcher.search(by: name) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                self?.loadPhotos(for: user)
            case .failure(let error):
                self?.loadingIndicator.stopAnimating()
                if error is UserError {
                    switch error as! UserError {
                    case .notFound:
                        self?.loadingLabel.text = "User not found"
                    default:
                        self?.loadingLabel.text = "An error occurred and it was not possible to load the user"
                    }
                } else {
                    self?.loadingLabel.text = "An error occurred and it was not possible to load the user"
                }
            }
        }
    }
    
    fileprivate func loadPhotos(for user: User, in page: Int = 0) {
        Users.PublicPhotosGetter(user: user).getPublicPhotos(in: page) { [weak self] result in
            guard let s = self else { return }
            s.loadingIndicator.stopAnimating()
            s.loadingLabel.isHidden = true
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
        Nuke.loadImage(with: photo.url(for: flickrImageSize), into: cell.photoImageView)
        return cell
    }
    
}

extension ListViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let user = user, indexPath.item == photoSet.photos.count - itemsMissingToLoadAnotherPage {
            loadPhotos(for: user, in: photoSet.currentPage + 1)
        }
    }
}
