//
//  UserPhotoAlbunsViewController.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 24/05/21.
//

import UIKit

class UserPhotoAlbunsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User?
    var albums: [Album] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let kBaseURL = "https://jsonplaceholder.typicode.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        loadAlbums()
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = 10
                layout.minimumInteritemSpacing = 10
                layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
                let size = CGSize(width:(collectionView!.bounds.width-30)/2, height: 250)
                layout.itemSize = size
        }
    }
    
    fileprivate func loadAlbums() {
        guard let id = user?.id,
              let url = URL(string: "\(kBaseURL)/users/\(id)/albums") else {
            return
        }
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
               response.statusCode >= 200,
               response.statusCode < 300 {
                guard let data = data,
                      let albums = try? JSONDecoder().decode([Album].self, from: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.albums = albums
                }
            }
        }
        
        task.resume()
    }
}

extension UserPhotoAlbunsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return albums.count
    }
}
