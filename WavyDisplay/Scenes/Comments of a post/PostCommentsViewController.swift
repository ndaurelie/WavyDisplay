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
        static let pathForAllComments = "/comments"
    }
    
    var currentPost: Post?
    
    var commentsForThisPost: [Comment]?

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
        
        let messageString = "Add a comment"
        let titlePlaceholderString = "Title of the comment"
        let emailPlaceholderString = "Your email"
        let bodyPlaceholderString = "Your comment"
        
        let addCommentController = UIAlertController(title: nil, message: messageString, preferredStyle: .alert)
        
        addCommentController.addTextField(configurationHandler: { (titleTextField: UITextField!) in
            titleTextField.borderStyle = .roundedRect
            titleTextField.text = titlePlaceholderString
            titleTextField.clearButtonMode = .always
            titleTextField.autocapitalizationType = .sentences
        })
        addCommentController.addTextField(configurationHandler: { (emailTextField: UITextField!) in
            emailTextField.borderStyle = .roundedRect
            emailTextField.text = emailPlaceholderString
            emailTextField.clearButtonMode = .always
            emailTextField.autocapitalizationType = .sentences
        })
        addCommentController.addTextField(configurationHandler: { (bodyTextField: UITextField!) in
            bodyTextField.borderStyle = .roundedRect
            bodyTextField.text = bodyPlaceholderString
            bodyTextField.clearButtonMode = .always
            bodyTextField.autocapitalizationType = .sentences
        })
        
        let postCommentAction = UIAlertAction(title: "Add", style: .default, handler: { [unowned self] action in
            
            var titleForComment = ""
            var emailForComment = ""
            var bodyForComment = ""
            if let newTitle = addCommentController.textFields![0].text {
                titleForComment = newTitle
            }
            if let newEmail = addCommentController.textFields![1].text {
                emailForComment = newEmail
            }
            if let newBody = addCommentController.textFields![2].text {
                bodyForComment = newBody
            }
            print("I should post this comment with title \(titleForComment), email \(emailForComment) and body: ", bodyForComment)
            self.postNewComment(commentName: titleForComment, commentEmail: emailForComment, commentBody: bodyForComment)
        })
        
        let cancelCommentAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("User cancelled posting a comment")
        })
        
        addCommentController.addAction(postCommentAction)
        addCommentController.addAction(cancelCommentAction)
        
        self.present(addCommentController, animated: true)
    }
    
    func postNewComment(commentName: String, commentEmail: String, commentBody: String) {
        if currentPost != nil {
            let allCommentsString = Constant.baseUrlString + Constant.pathForAllComments
            let parameters: Parameters = [
                "postId": currentPost!.id,
                "name": commentName,
                "email": commentEmail,
                "body": commentBody
                ]
            Alamofire.request(allCommentsString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Success for post request: ", value)
                case .failure(let error):
                    print("Failure for post request: ", error)
                }
            }
            
        } else {
            print("Current post was nil: comment was not added.")
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
