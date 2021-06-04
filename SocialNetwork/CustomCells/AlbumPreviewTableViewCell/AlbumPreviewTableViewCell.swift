//
//  AlbumPreviewTableViewCell.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 02/06/21.
//

import UIKit

class AlbumPreviewTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var album: Album? {
        didSet {
            loadPhotos()
        }
    }
    
    var images: [UserImage]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(cellType: AlbumsCollectionViewCell.self)
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
            let size = CGSize(width: 100, height: 100)
            layout.itemSize = size
        }
    }
    
    func bind(with album: Album) {
        self.album = album
    }
    
    private func loadPhotos() {
        UserService().loadPhotosFromAlbum(albumId: String(album?.id ?? 0)) { (photos, error) in
            self.images = photos
        }
    }
}

extension AlbumPreviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: AlbumsCollectionViewCell.self, for: indexPath)
        if let image = images?[safe: indexPath.row] {
            cell.bind(with: image)
        } else {
            cell.backgroundColor = indexPath.row % 2 == 0 ? .red : .green
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
