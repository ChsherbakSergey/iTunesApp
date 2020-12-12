//
//  LibraryTableViewCell.swift
//  iTunesApp
//
//  Created by Sergey on 12/11/20.
//

import UIKit
import SDWebImage

class LibraryTableViewCell: UITableViewCell {

    //Identifier to use when register a cell
    static let identifier = "LibraryTableViewCell"
    
    //MARK: - Views that will be displayed on this cell
    private let coverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let trackNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
//    private let lineView : UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemGray
//        return view
//    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setInitialUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Setting frames of the views
    override func layoutSubviews() {
        super.layoutSubviews()
        //Frame of the cover imageView
        coverImageView.frame = CGRect(x: 20, y: 4, width: 46, height: 46)
        coverImageView.layer.cornerRadius = 2
        //Frame of the trackName Label
        trackNameLabel.frame = CGRect(x: coverImageView.right + 5, y: 0, width: contentView.width - 71, height: contentView.height / 2)
        //Frame of the artistName Label
        artistNameLabel.frame = CGRect(x: coverImageView.right + 5, y: contentView.height / 2, width: contentView.width - 71, height: contentView.height / 2)
        //Frame of the line
//        lineView.frame = CGRect(x: 0, y: contentView.bottom - 0.25, width: contentView.width, height: 0.25)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        trackNameLabel.text = nil
        artistNameLabel.text = nil
//        lineView.backgroundColor = nil
    }
    
    //MARK: - Configure the view
    
    ///Configures initial UI
    private func setInitialUI() {
        //Adding subviews
        contentView.addSubview(coverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
//        contentView.addSubview(lineView)
    }
    
    public func configureCell(with model: Track) {
        coverImageView.sd_setImage(with: URL(string: model.artworkUrl100), completed: nil)
        trackNameLabel.text = model.trackName
        artistNameLabel.text = model.artistName
//        lineView.backgroundColor = .systemGray
    }
    
}
