//
//  NewCommentFormViewController.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 20/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import Foundation
import Eureka
import Alamofire

class NewCommentFormViewController: FormViewController {
    
    struct Constant {
        static let baseUrlString = "https://jsonplaceholder.typicode.com"
        static let pathForAllComments = "/comments"
    }
    
    var commentedPost: Post?
    
    var newCommentTitle: String?
    
    var newCommentEmail: String?
    
    var newCommentBody: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayForm()
    }
    
    func displayForm() {
        if commentedPost != nil {
            
            form +++ Section("Add a comment")
                <<< TextRow(){ row in
                    row.title = "Title"
                    row.placeholder = "Enter a title for the comment"
                    row.onChange { [unowned self] row in
                        self.newCommentTitle = row.value
                    }
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    row.cellUpdate { (cell, row) in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                    }
                }
                <<< EmailRow(){ row in
                    row.title = "Email"
                    row.placeholder = "Enter your email"
                    row.onChange { [unowned self] row in
                        self.newCommentEmail = row.value
                    }
                    row.add(rule: RuleEmail())
                    row.validationOptions = .validatesOnChange
                    row.cellUpdate { (cell, row) in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                    }
                }
                <<< TextAreaRow(){ row in
                    row.title = "Comment"
                    row.placeholder = "Enter your comment"
                    row.onChange { [unowned self] row in
                        self.newCommentBody = row.value
                    }
                }
                <<< ButtonRow(){ row in
                    row.title = "Add this comment"
                    row.onCellSelection { (cell, row) in
                        if self.form.validate().isEmpty {
                            if self.newCommentTitle == nil {
                                self.newCommentTitle = ""
                            }
                            if self.newCommentEmail == nil {
                                self.newCommentEmail = ""
                            }
                            if self.newCommentTitle == nil {
                                self.newCommentTitle = ""
                            }
                            
                            print("The new comment has these 3 components: ", self.newCommentTitle!, self.newCommentEmail!, self.newCommentBody!)
                            self.postNewComment(commentName: self.newCommentTitle!, commentEmail: self.newCommentEmail!, commentBody: self.newCommentBody!)
                            
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            
        } else {
            print("Don't display form because commentedPost is nil")
        }
    }
    
    func postNewComment(commentName: String, commentEmail: String, commentBody: String) {
        if commentedPost != nil {
            let allCommentsString = Constant.baseUrlString + Constant.pathForAllComments
            let parameters: Parameters = [
                "postId": commentedPost!.id,
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
    
    
}
