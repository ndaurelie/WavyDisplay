//
//  AlbumsViewController.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 18/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import UIKit
import Alamofire

class AlbumsViewController: UIViewController {
    
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
    
    var photosByAlbum = [PhotoAlbum]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentUser != nil {
            print("I should get albums of user with userId \(currentUser!.id)")
            let requestString = Constant.baseUrlString + Constant.pathForAlbumsHavingUserId + String(currentUser!.id)
            print("My request string is: ", requestString)
            
            Alamofire.request(requestString).responseJSON { response in
                
                if let data = response.data {
                    
                    do {
                        let result = try JSONDecoder().decode(Array<Album>.self, from: data)
                        self.albumsForThisUser = result
                        
                        if let albumsId = self.albumsForThisUser?.map({ $0.id }) {
                            
                            for albumId in albumsId {
                                
                                print("I should get photos having this album id: ", albumId)
                            }
                            
                        }
                        
                        
                        
                    } catch {
                        print("Error serializing Album JSON: ", error)
                    }
                    
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
