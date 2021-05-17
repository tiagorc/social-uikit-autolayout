//
//  ViewController.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 17/05/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let kBaseURL = "https://jsonplaceholder.typicode.com/posts"

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        loadData()
    }
    
    fileprivate func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        
        tableView.registerCell(type: InstagramTableViewCell.self)
    }
    
    fileprivate func loadData() {
        guard let url = URL(string: kBaseURL) else {
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCell(withType: InstagramTableViewCell.self, for: indexPath) as! InstagramTableViewCell
        
        cell.bind(post: posts[indexPath.row])
        
        return cell
    }
}

