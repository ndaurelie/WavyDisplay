//
//  PostCommentsViewController.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 18/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import UIKit
import Alamofire

class PostCommentsViewController: UIViewController {
    
    struct Constant {
        static let baseUrlString = "https://jsonplaceholder.typicode.com"
        static let pathForPostHavingPostId = "/posts/"
    }
    
    var currentPost: Post?
    
    var commentsForThisPost: [Comment]?

    // MARK: - Outlets
    
    @IBOutlet weak var postTitleLabel: UILabel!
    
    @IBOutlet weak var postBodyTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentPost != nil {
            print("Set the label to \(currentPost!.title)")
            postTitleLabel.text = currentPost!.title
            postBodyTextView.text = currentPost!.body
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayCommentsSegue" {
            if let onlyCommentsVC = segue.destination as? OnlyCommentsViewController {
                onlyCommentsVC.displayedPost = currentPost
            }
        }
    }
    

}
