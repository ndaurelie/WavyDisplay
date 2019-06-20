//
//  AlbumsViewController.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 18/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class AlbumsViewController: UIViewController {
    
    // We display photos by a user - each section represents an album
    
    struct Constant {
        static let baseUrlString = "https://jsonplaceholder.typicode.com"
        static let pathForAlbumsHavingUserId = "/albums?userId="
        static let pathForPhotosHavingAlbumId = "/photos?albumId="
        static let pathForAllPhotos = "/photos"
    }
    
    struct PhotoAlbum: Codable {
        let album: Album
        let photos: [Photo]
    }
    
    var currentUser: User?
    
    var albumsForThisUser: [Album]?
    
    // This var is used for the data source of the collection view :
    var photosByAlbum = [PhotoAlbum]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var albumsCollectionView: UICollectionView! {
        didSet {
            albumsCollectionView.delegate = self
            albumsCollectionView.dataSource = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photosRequestString = Constant.baseUrlString + Constant.pathForAllPhotos
        
        Alamofire.request(photosRequestString).responseJSON { responseP in
            
            if let dataP = responseP.data {
                
                do {
                    let allPhotos = try JSONDecoder().decode(Array<Photo>.self, from: dataP)
                    
                    if self.currentUser != nil {
                        print("I should get albums of user with userId \(self.currentUser!.id)")
                        let requestString = Constant.baseUrlString + Constant.pathForAlbumsHavingUserId + String(self.currentUser!.id)
                        print("My request string is: ", requestString)
                        
                        Alamofire.request(requestString).responseJSON { response in
                            
                            if let data = response.data {
                                
                                do {
                                    let result = try JSONDecoder().decode(Array<Album>.self, from: data)
                                    self.albumsForThisUser = result
                                    
                                    // For each album of this user, we gather all photos of this album
                                    for thisAlbum in result {
                                        
                                        var photosForThisAlbum = [Photo]()
                                        
                                        for photo in allPhotos {
                                            if photo.albumId == thisAlbum.id {
                                                photosForThisAlbum.append(photo)
                                            }
                                        }
                                        let photoAlbum = PhotoAlbum(album: thisAlbum, photos: photosForThisAlbum)
                                        self.photosByAlbum.append(photoAlbum)
                                        
                                        
                                        DispatchQueue.main.async {
                                            self.albumsCollectionView.reloadData()
                                        }
                                        
                                    }

                                    
                                } catch {
                                    print("Error serializing Album JSON: ", error)
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                } catch {
                    print("Error serializing photos JSON: ", error)
                }
                
            }
        }
        
        
        
        
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayThisPhoto" {
            if let chosenPhoto = sender as? Photo {
                if let onePhotoVC = segue.destination as? OnePhotoViewController {
                    onePhotoVC.thisPhoto = chosenPhoto
                }
            }
        }
    }
    

}

extension AlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photosByAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosByAlbum[section].photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath)
        
        // Customize cells and display a photo in each cell.
        if let albumCell = cell as? PhotoCollectionViewCell {
            let urlString = photosByAlbum[indexPath.section].photos[indexPath.item].url
            albumCell.photoUrl = URL(string: urlString)
            return albumCell
        } else {
            return cell
        }
    }
    
    // MARK: - Collection View Headers
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "albumsHeaderview", for: indexPath) as? AlbumsHeaderView else {
                fatalError("Invalid view type")
            }
            
            let albumTitle = photosByAlbum[indexPath.section].album.title
            headerView.albumsHeaderLabel.text = albumTitle
            return headerView
            
        } else {
            assert(false, "Invalid element type")
        }
    }
    
    // MARK: - Selection of a photo
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if photosByAlbum != nil {
            let selectedPhoto = photosByAlbum[indexPath.section].photos[indexPath.item]
            
            performSegue(withIdentifier: "DisplayThisPhoto", sender: selectedPhoto)
        }
    }
    
}
