//
//  AlbumsCollectionViewCell.swift
//  iTunesApp
//
//  Created by Sergey on 12/9/20.
//

import UIKit
import SDWebImage

class AlbumsCollectionViewCell: UICollectionViewCell {
    
    //Identifier to use when register cell
    static let identifier = "AlbumsCollectionViewCell"
    
    //MARK: - Views that will be displayed on this cell
    private let albumNamelabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let artistNamelabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .systemGray
        return label
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitialUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 10, y: 10, width: contentView.width - 20, height: contentView.width - 20)
        imageView.layer.cornerRadius = 5
        albumNamelabel.frame = CGRect(x: 10, y: imageView.bottom + 4, width: contentView.width - 20, height: 20)
        artistNamelabel.frame = CGRect(x: 10, y: albumNamelabel.bottom + 1, width: contentView.width - 20, height: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNamelabel.text = nil
        artistNamelabel.text = nil
        imageView.image = nil
    }
    
    //MARK: - Configure View
    
    private func setInitialUI() {
        backgroundColor = .systemBackground
        contentView.clipsToBounds = true
        accessibilityLabel = "Reminder"
        accessibilityHint = "Double-tap to open reminder"
        contentView.addSubview(imageView)
        contentView.addSubview(albumNamelabel)
        contentView.addSubview(artistNamelabel)
    }
    
    public func configureCell(with model: Album) {
        albumNamelabel.text = model.collectionName
        artistNamelabel.text = model.artistName
        imageView.sd_setImage(with: URL(string: "\(model.artworkUrl100)"), completed: nil)
    }
    
}
