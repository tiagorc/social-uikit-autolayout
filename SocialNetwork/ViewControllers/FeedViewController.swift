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
            tableView.reloadData()
        }
    }
    
    private var users: [User] = [] {
        didSet {
            loadPosts()
        }
    }
    
    private let kBaseURL = "https://jsonplaceholder.typicode.com/"

    @IBOutlet weak var tableView: UITableView!
    
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
        guard let url = URL(string: kBaseURL + "users") else {
            return
        }
        
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
               response.statusCode >= 200,
               response.statusCode < 300 {
                guard let data = data, let posts = try? JSONDecoder().decode([User].self, from: data) else {
                    return
                }
                
                self.users = posts
            }
        }.resume()
    }
    
    fileprivate func loadPosts() {
        guard let url = URL(string: kBaseURL + "posts") else {
            return
        }
        
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
               response.statusCode >= 200,
               response.statusCode < 300 {
                guard let data = data, let posts = try? JSONDecoder().decode([Post].self, from: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.posts = posts
                }
            }
        }.resume()
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
