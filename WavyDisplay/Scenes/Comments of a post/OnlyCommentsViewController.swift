//
//  OnlyCommentsViewController.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 19/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import UIKit
import Alamofire

class OnlyCommentsViewController: UIViewController {
    
    struct Constant {
        static let baseUrlString = "https://jsonplaceholder.typicode.com"
        static let pathForCommentsAboutPostHavingPostId = "/comments?postId="
    }
    
    var displayedPost: Post?
    
    var allCommentsForThisPost: [Comment]?
    
    // MARK: - Outlets
    
    @IBOutlet weak var commentsCollectionView: UICollectionView! {
        didSet {
            commentsCollectionView.delegate = self
            commentsCollectionView.dataSource = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if displayedPost != nil {
            let commentsRequestString = Constant.baseUrlString + Constant.pathForCommentsAboutPostHavingPostId + String(displayedPost!.id)
            
            Alamofire.request(commentsRequestString).responseJSON { response in
                
                if let data = response.data {
                    
                    do {
                        let postComments = try JSONDecoder().decode([Comment].self, from: data)
                        self.allCommentsForThisPost = postComments
                        
                        DispatchQueue.main.async {
                            self.commentsCollectionView.reloadData()
                        }
                        
                    } catch {
                        print("Error serializing post's comments JSON: ", error)
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

extension OnlyCommentsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if allCommentsForThisPost != nil {
            return allCommentsForThisPost!.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath)
        if let commentCell = cell as? CommentCollectionViewCell {
            if allCommentsForThisPost != nil {
                commentCell.commentTitleLabel.text = allCommentsForThisPost![indexPath.item].name
                commentCell.commentBodyTextView.text = allCommentsForThisPost![indexPath.item].body
                commentCell.commentEmailLabel.text = allCommentsForThisPost![indexPath.item].email
                return commentCell
            } else {
                return commentCell
            }
        } else {
            return cell
        }
    }
    
    // MARK: - Collection View Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let commentsCollectionViewWidth = collectionView.frame.width
        let cellWidth = commentsCollectionViewWidth - 10
        
        return CGSize(width: cellWidth, height: 200)
    }
    
}
