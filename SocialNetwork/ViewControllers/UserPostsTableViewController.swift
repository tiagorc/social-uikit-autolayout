//
//  PostTableViewController.swift
//  SocialKit
//
//  Created by Euler Carvalho on 19/04/21.
//

import UIKit

class UserPostsTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    private var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let userService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
        loadPostsForSpecificUser()
    }

    fileprivate func loadPostsForSpecificUser() {
        guard let id = user?.id else { return }
        userService.loadPostsForSpecificUser(userId: String(id)) { (posts, error) in
            guard error == nil, let posts = posts as? [Post] else {
                return
            }
            
            self.posts = posts
        }
        
        
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.registerCell(type: UserDetailsTableViewCell.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let identifier = segue.identifier,
           identifier == "showUserPhotos" {
            (segue.destination as? UserPhotoAlbunsViewController)?.user = user
        }
    }
}

extension UserPostsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == .zero {
            let cell = tableView.dequeueCell(withType: UserDetailsTableViewCell.self, for: indexPath) as UserDetailsTableViewCell
            cell.bind(user: user, responder: self)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        cell.bind(post: posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension UserPostsTableViewController: UserDetailsTableViewCellProtocol {
    func userDidClickInPhotos() {
        performSegue(withIdentifier: "showUserPhotos", sender: nil)
    }
}
