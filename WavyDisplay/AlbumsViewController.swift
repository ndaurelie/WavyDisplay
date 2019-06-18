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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photosByAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosByAlbum[section].photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath)
        
        // TODO: Customize cells and display a photo in each cell.
        cell.backgroundColor = UIColor.blue
        
        
        return cell
    }
    
    
}
