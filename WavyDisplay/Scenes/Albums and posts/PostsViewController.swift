//
//  PostsViewController.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 18/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import UIKit
import Alamofire

class PostsViewController: UIViewController {
    
    struct Constant {
        static let commonBaseUrl = "https://jsonplaceholder.typicode.com"
        static let pathForPostsByUserHavingUserId = "/posts?userId="
    }
    
    var currentUser: User?
    
    var postsOfThisUser: [Post]?
    
    // MARK: - Outlets
    
    @IBOutlet weak var postsCollectionView: UICollectionView! {
        didSet {
            postsCollectionView.delegate = self
            postsCollectionView.dataSource = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if currentUser != nil {
            
            let postsRequest = Constant.commonBaseUrl + Constant.pathForPostsByUserHavingUserId + String(currentUser!.id)
            Alamofire.request(postsRequest).responseJSON { response in
                
                if let postsData = response.data {
                    
                    do {
                        let postsResult = try JSONDecoder().decode(Array<Post>.self, from: postsData)
                        self.postsOfThisUser = postsResult
                        
                        DispatchQueue.main.async {
                            self.postsCollectionView.reloadData()
                        }
                        
                    } catch {
                        print("Error serializing posts JSON: ", error)
                    }
                }
            }
        }
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPostCommentsSegue" {
            if let commentsVC = segue.destination as? PostCommentsViewController {
                if let chosenPost = sender as? Post {
                    commentsVC.currentPost = chosenPost
                }
            }
        }
    }

}

extension PostsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if postsOfThisUser != nil {
            return postsOfThisUser!.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath)
        if let postCell = cell as? PostCollectionViewCell, postsOfThisUser != nil {
            postCell.titleLabel.text = postsOfThisUser![indexPath.item].title
            postCell.bodyTextView.text = postsOfThisUser![indexPath.item].body
            return postCell
        } else {
            return cell
        }
        
    }
    
    // MARK: - Collection View Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let postsCollectionViewWidth = collectionView.frame.width
        
        var width = (postsCollectionViewWidth / 2) - 10
        
        if postsCollectionViewWidth <= 600 {
            width = postsCollectionViewWidth - 10
        }
        
        return CGSize(width: width, height: 180)
    }
    
    // MARK: - Selection of a post
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if postsOfThisUser != nil {
            let selectedPost = postsOfThisUser![indexPath.item]
            
            performSegue(withIdentifier: "ShowPostCommentsSegue", sender: selectedPost)
        }
        
    }
    
}
