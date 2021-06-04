//
//  ViewController.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 17/05/21.
//

import UIKit

class FeedViewController: UIViewController {
    
    private var posts: [Post] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.loadPosts()
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    var userService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        loadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        
        tableView.registerCell(type: InstagramTableViewCell.self)
    }
    
    fileprivate func loadUsers() {
        userService.loadUsers { (users, error) in
            guard error == nil, let users = users as? [User] else {
                return
            }
            
            self.users = users
        }
    }
    
    fileprivate func loadPosts() {
        userService.loadPosts { (posts, error) in
            guard error == nil, let posts = posts as? [Post] else {
                return
            }
            
            self.posts = posts
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCell(withType: InstagramTableViewCell.self, for: indexPath) as! InstagramTableViewCell
        
        let post = posts[indexPath.row]
        let user = self.users.filter { $0.id == post.userID }.first
        
        cell.bind(post: post, user: user, responder: self)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "presentUserPosts":
            if let user = sender as? User {
                segue.destination.title = user.name
                guard let destination = segue.destination as? UserPostsTableViewController else { return }
                destination.user = user
            }
        default:
            break
        }
    }
}

extension FeedViewController: InstagramTableViewCellResponder {
    func didSelectUser(post: Post?, user: User?) {
        self.performSegue(withIdentifier: "presentUserPosts", sender: user)
    }
}
