//
//  ListUsersViewController.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 18/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListUsersViewController: UIViewController {
    
    struct Constant {
        static let usersURL = "https://jsonplaceholder.typicode.com/users"
        static let titleOfUsersList = "Users"
    }
    
    var allUsers = [User]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var usersTableView: UITableView! {
        didSet {
            usersTableView.delegate = self
            usersTableView.dataSource = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load list of users
        Alamofire.request(Constant.usersURL).responseJSON { response in
            
            if let data = response.data {
                
                do {
                    
                    let result = try JSONDecoder().decode(Array<User>.self, from: data)
                    self.allUsers = result
                    
                    DispatchQueue.main.async {
                        self.usersTableView.reloadData()
                    }
                    
                } catch {
                    print("Error serializing JSON: ", error)
                }
                
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = Constant.titleOfUsersList
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

extension ListUsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = allUsers[indexPath.row].username
        cell.detailTextLabel?.text = allUsers[indexPath.row].name
        
        return cell
    }
    
    
}
