//
//  ListUserViewController.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 24/05/21.
//

import UIKit

protocol AddNewUserDelegate: AnyObject {
    func addUser(name: String, email: String)
}

class ListUserViewController: UITableViewController {
    
    private let kBaseURL = "https://jsonplaceholder.typicode.com"

    private var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let userService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        loadUsers()
    }
    
    fileprivate func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewUser(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    fileprivate func loadUsers() {
        userService.loadUsers { (users, error) in
            guard error == nil, let users = users as? [User] else {
                return
            }
            
            self.users = users
        }
    }
    
    @objc func addNewUser(_ sender: Any) {
        performSegue(withIdentifier: "addNewUser", sender: sender)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        let user = users[index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as! UserTableViewCell
        
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "onUserSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "addNewUser":
            segue.destination.title = "Adicionar usuário"
            guard let destination = segue.destination as? AddUserTableViewController else {
                return
            }
            
            destination.delegate = self
        case "onUserSegue":
            if let userCell = sender as? UserTableViewCell, let user = userCell.user {
                segue.destination.title = user.name
                guard let destination = segue.destination as? UserPostsTableViewController else { return }
                destination.user = userCell.user
            }
        default:
            break
        }
    }
    
}

extension ListUserViewController: AddNewUserDelegate {
    func addUser(name: String, email: String) {
        let user = User(
            id: self.users.count + 1,
            name: name,
            username: name,
            email: email,
            address: nil, phone: nil, website: nil, company: nil)
        self.users.insert(user, at: 0)
    }
}
