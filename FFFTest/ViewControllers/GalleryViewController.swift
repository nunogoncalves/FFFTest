//
//  GalleryViewController.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Nuke

final class GalleryViewController: UIViewController {
    
    @IBOutlet private weak var photosCollectionView: UICollectionView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadingLabel: UILabel!
    @IBOutlet private weak var noNetworkTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var refreshButton: UIButton!
    
    @IBAction private func refreshTapped() {
        searchUser(named: lastNameSearched)
    }
    
    private let userSearcher = Users.Searcher()
    fileprivate var lastNameSearched = ""
    fileprivate var user: User?
    fileprivate var photoSet = PhotoSet.empty
    fileprivate var searchingPhotos = false
    
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
        let hSizeClass = traitCollection.horizontalSizeClass
        let itemsPerRow = itemsPerHorizontalSizeClass[hSizeClass] ?? defaultItemsPerRow
        return itemsPerRow * rowsMissingToLoadAnotherPage
    }
    
    private lazy var itemsPerHorizontalSizeClass: [UIUserInterfaceSizeClass : Int] = {
        return [
            .compact : self.defaultItemsPerRow,
            .regular: 7
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.hidesWhenStopped = true
        collectionViewLayout.minimumInteritemSpacing = 1
        collectionViewLayout.minimumLineSpacing = 1
        applyCollectionViewLayoutItemSize(basedOn: traitCollection)
        photosCollectionView.collectionViewLayout = collectionViewLayout
        
//        searchUser(named: "almsaeed")
    }
    
    private func applyCollectionViewLayoutItemSize(basedOn newTraitCollection: UITraitCollection) {
        let itemsPerRow = CGFloat(itemsPerHorizontalSizeClass[newTraitCollection.horizontalSizeClass] ?? defaultItemsPerRow)
        let itemWitdh: CGFloat
        if newTraitCollection == traitCollection {
            itemWitdh = (view.frame.width / itemsPerRow) - (itemsPerRow - 1)
        } else {
            itemWitdh = (view.frame.height / itemsPerRow) - (itemsPerRow - 1)
        }
        collectionViewLayout.itemSize = CGSize(width: itemWitdh, height: itemWitdh)
    }
    
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        applyCollectionViewLayoutItemSize(basedOn: newCollection)
        photosCollectionView.reloadData()
    }
    
    fileprivate func searchUser(named name: String) {
        lastNameSearched = name
        putUIInNewSearchState()
        
        userSearcher.search(by: name) { [weak self] result in
            switch result {
            case .success(let user): self?.got(user)
            case .failure(let error): self?.failedToGetUser(with: error)
            }
        }
    }
    
    private func putUIInNewSearchState() {
        photoSet = PhotoSet.empty
        refreshButton.isHidden = true
        photosCollectionView.reloadData()
        loadingIndicator.startAnimating()
        loadingLabel.text = "Loading..."
        loadingLabel.isHidden = false
    }
    
    private func got(_ user: User) {
        self.user = user
        loadPhotos(for: user)
    }

    private let userErrorMessages: [FFError : String] = [
        .notFound : "User not found",
        .noNetwork : "You are not connected to the internet",
    ]

    private func failedToGetUser(with error: FFError) {
        loadingIndicator.stopAnimating()
        refreshButton.isHidden = false
        let errorMessage = userErrorMessages[error] ?? "An error occurred and it was not possible to load the user"
        loadingLabel.text = errorMessage
    }
    
    fileprivate func loadPhotos(for user: User, in page: Int = 0) {
        hideNoNetworkView()
        refreshButton.isHidden = true
        
        searchingPhotos = true
        Users.PublicPhotosGetter(user: user).getPublicPhotos(in: page) { [weak self] result in
            self?.hideLoadingViews()
            switch result {
            case .success(let photoSet): self?.got(photoSet)
            case .failure(let error): self?.failedToGetPhotoSet(with: error, in: page)
            }
        }
    }
    
    private func hideLoadingViews() {
        loadingIndicator.stopAnimating()
        loadingLabel.isHidden = true
    }
    
    private func got(_ photoSet: PhotoSet) {
        searchingPhotos = false
        if photoSet.isEmpty {
            loadingLabel.isHidden = false
            loadingLabel.text = "This user has no photos"
            self.photoSet = photoSet
            photosCollectionView.reloadData()
            return
        }
        
        if photoSet.isFirstPage {
            self.photoSet = photoSet
        } else {
            var currentPhotosList = self.photoSet.photos
            currentPhotosList.append(contentsOf: photoSet.photos)
            self.photoSet = PhotoSet(currentPage: photoSet.currentPage,
                                  totalPages: photoSet.totalPages,
                                  photos: currentPhotosList)
        }
        photosCollectionView.reloadData()
    }
    
    private func failedToGetPhotoSet(with error: FFError, in page: Int) {
        if error == .noNetwork {
            if page != 0 {
                showNoNetworkView()
            } else {
                loadingLabel.text = "You are not conected to the internet."
            }
        } else {
            loadingLabel.text = "There was an error loading this user's photos."
        }
    }

    private let noNetworkHiddenTopContrant: CGFloat = -30
    private let noNetworkAnimationDuration: TimeInterval = 0.2
    private func hideNoNetworkView() {
        noNetworkTopConstraint.constant = noNetworkHiddenTopContrant
        UIView.animate(withDuration: noNetworkAnimationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func showNoNetworkView() {
        noNetworkTopConstraint.constant = 0
        UIView.animate(withDuration: noNetworkAnimationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
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

extension GalleryViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text,
            !searchText.characters.isEmpty,
            lastNameSearched != searchText {
            searchUser(named: searchText)
            searchBar.resignFirstResponder()
        }
    }
    
}

extension GalleryViewController : UICollectionViewDataSource {
    
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

extension GalleryViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isItTimeToLoadMorePhotos(at: indexPath) {
            loadPhotos(for: user!, in: photoSet.currentPage + 1)
        }
    }
    
    private func isItTimeToLoadMorePhotos(at indexPath: IndexPath) -> Bool {
        return user != nil &&
            indexPath.item == photoSet.photos.count - itemsMissingToLoadAnotherPage &&
            !searchingPhotos &&
            photoSet.hasMorePages
    }
}
