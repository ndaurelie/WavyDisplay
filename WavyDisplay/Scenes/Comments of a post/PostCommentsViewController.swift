//
//  PostCommentsViewController.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 18/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import UIKit

class PostCommentsViewController: UIViewController {
    
    var currentPost: Post?

    // MARK: - Outlets
    
    @IBOutlet weak var postTitleLabel: UILabel!
    
    @IBOutlet weak var postBodyTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentPost != nil {
            print("Set the label to \(currentPost!.title)")
            print("Set the textView to \(currentPost!.body)")
            postTitleLabel.text = currentPost!.title
            postBodyTextView.text = currentPost!.body
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add a comment", style: .plain, target: self, action: #selector(addTapped))
        }
    }
    
    // Method used when tapping the button to add a comment
    @objc func addTapped() {
        print("I should propose to add a comment")
        
        performSegue(withIdentifier: "DisplayFormToEnterComment", sender: nil)
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayCommentsSegue" {
            if let onlyCommentsVC = segue.destination as? OnlyCommentsViewController {
                onlyCommentsVC.displayedPost = currentPost
            }
        }
        if segue.identifier == "DisplayFormToEnterComment" {
            print("Current post id is: ", currentPost?.id ?? "post is nil")
            if let formVC = segue.destination as? NewCommentFormViewController {
                formVC.commentedPost = currentPost
            }
        }
    }
    

}
