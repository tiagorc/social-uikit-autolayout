//
//  UserPhotoAlbunsViewController.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 24/05/21.
//

import UIKit

class UserPhotoAlbunsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    var albums: [Album] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let userService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        loadAlbums()
    }
    
    fileprivate func setupCollectionView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.registerCell(type: AlbumPreviewTableViewCell.self)
    }
    
    fileprivate func loadAlbums() {
        guard let id = user?.id else { return }
        userService.loadAlbums(userId: String(id)) { (albums, error) in
            guard error == nil, let albums = albums as? [Album] else {
                return
            }
            
            self.albums = albums
        }
    }
}

extension UserPhotoAlbunsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: AlbumPreviewTableViewCell.self, for: indexPath) as! AlbumPreviewTableViewCell
        
        cell.bind(with: albums[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return albums[section].title
    }
}
