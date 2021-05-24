//
//  PostTableViewController.swift
//  SocialKit
//
//  Created by Euler Carvalho on 19/04/21.
//

import UIKit

class UserPostsTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let kBaseURL = "https://jsonplaceholder.typicode.com"
    
    var user: User?
    private var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
        guard let id = user?.id,
              let url = URL(string: "\(kBaseURL)/posts/\(id)/posts") else {
            return
        }
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
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
        }
        
        task.resume()
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
        return self.posts.count + 1
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
