//
//  ImageDetailViewController.swift
//  SocialKit
//
//  Created by Euler Carvalho on 19/04/21.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    var user: User?

    @IBOutlet weak var tableView: UITableView!
    
    private let userService = UserService()
    
    var arrImages = [UserImage]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPhotos()
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate func loadPhotos() {
        guard let userId = user?.id else { return }
        userService.loadPhotosFromUser(userId: String(userId)) { (photos, error) in
            guard error == nil, let photos = photos as? [UserImage] else {
                return
            }
            
            self.arrImages = photos
        }
    }
}

extension ImageDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailImageTableViewCell", for: indexPath) as! DetailImageTableViewCell
        
        let side = Int((UIScreen.main.nativeBounds.size.width) * 0.9)
        
        let placeholder = UIImage(named: "placeholder")
        cell.imageView?.imageFromServerURL("http://lorempixel.com.br/\(side)/\(side)", placeHolder: placeholder)

        return cell
    }
}



