//
//  UserContentViewController.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 18/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserContentViewController: UIViewController {
    
    var chosenUser: User?
    var users: [User]?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if chosenUser != nil {
            navigationItem.title = chosenUser!.username
        }
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayAlbumsSegue" {
            if let destinationVC = segue.destination as? AlbumsViewController {
                if chosenUser != nil {
                    destinationVC.currentUser = chosenUser
                }
            }
        }
        
        if segue.identifier == "DisplayPostsSegue" {
            if let postsVC = segue.destination as? PostsViewController {
                if chosenUser != nil {
                    postsVC.currentUser = chosenUser
                }
            }
        }
        
    }
    

}
