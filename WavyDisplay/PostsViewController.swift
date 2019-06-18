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
        static let pathForCommentsAboutPostHavingPostId = "/comments?postId="
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PostsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let postsCollectionViewWidth = collectionView.frame.width
        
        var width = (postsCollectionViewWidth / 2) - 10
        
        if postsCollectionViewWidth <= 600 {
            width = postsCollectionViewWidth - 10
        }
        
        return CGSize(width: width, height: 150)
    }
    
}
