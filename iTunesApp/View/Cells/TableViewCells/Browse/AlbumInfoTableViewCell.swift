//
//  AlbumInfoTableViewCell.swift
//  iTunesApp
//
//  Created by Sergey on 12/9/20.
//

import UIKit

protocol AlbumInfoTableViewCellDelegate: AnyObject {
    func didTapPlayMusicButton()
    func didTapShuffleButton()
    func didTapArtistNameButton()
}

final class AlbumInfoTableViewCell: UITableViewCell {
    
    //Identifier to use when register a cell
    static let identifier = "AlbumInfoTableViewCell"
    
    //Delegate
    weak var delegate: AlbumInfoTableViewCellDelegate?
    
    //MARK: - Views that will be displayed on this cell
    private let albumNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()
    
    private let artistNameButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemPink, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        return button
    }()
    
    private let genreAndYearLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let playButton : UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .secondarySystemFill
        return button
    }()
    
    private let shuffleButton : UIButton = {
        let button = UIButton()
        button.setTitle("Shuffle", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .secondarySystemFill
        return button
    }()
    
    private let lineView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()

    //MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setInitialUI()
        setTargetsToButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Setting frames of the views
    override func layoutSubviews() {
        super.layoutSubviews()
        //Frame of the albumNameLabel
        albumNameLabel.frame = CGRect(x: 20, y: 15, width: contentView.width - 40, height: 20)
        //Frame of the artistNameLabel
        artistNameButton.frame = CGRect(x: contentView.width / 2 - 100, y: albumNameLabel.bottom + 10, width: 200, height: 20)
        //Frame of the genreAndYearLabel
        genreAndYearLabel.frame = CGRect(x: 20, y: artistNameButton.bottom + 10, width: contentView.width - 40, height: 15)
        //Frame of the play and shuffle buttons
        playButton.frame = CGRect(x: 20, y: genreAndYearLabel.bottom + 15, width: contentView.width / 2 - 30, height: 50)
        playButton.layer.cornerRadius = 10
        shuffleButton.frame = CGRect(x: playButton.right + 20, y: genreAndYearLabel.bottom + 15, width: contentView.width / 2 - 30, height: 50)
        shuffleButton.layer.cornerRadius = 10
        //Frame of the line view
        lineView.frame = CGRect(x: 20, y: contentView.bottom - 0.25, width: contentView.width - 10, height: 0.5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameButton.setTitle(nil, for: .normal)
        genreAndYearLabel.text = nil
        lineView.backgroundColor = nil
    }
    
    //MARK: - Configure View
    ///Sets initial UI
    private func setInitialUI() {
        //When user tap on the cell it won't show the selectable animation
        selectionStyle = .none
        //Adding subviews
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameButton)
        contentView.addSubview(genreAndYearLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(shuffleButton)
        contentView.addSubview(lineView)
    }
    
    ///Configures the view of the cell
    public func configureCell(collectionName: String, artistName: String, genreAndYear: String) {
        albumNameLabel.text = collectionName
        artistNameButton.setTitle(artistName, for: .normal)
        genreAndYearLabel.text = genreAndYear
        lineView.backgroundColor = .systemGray
    }
    
    ///Sets targets to buttons
    private func setTargetsToButtons() {
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        shuffleButton.addTarget(self, action: #selector(didTapShuffleButton), for: .touchUpInside)
        artistNameButton.addTarget(self, action: #selector(didTapArtistNameButton), for: .touchUpInside)
    }
    
    ///Delegates when the Play Button is Tapped
    @objc private func didTapPlayButton() {
        delegate?.didTapPlayMusicButton()
    }
    
    ///Delegates when the Shuffle Button  is Tapped
    @objc private func didTapShuffleButton() {
        delegate?.didTapShuffleButton()
    }
    
    ///Delegates when the Artist Name Label is Tapped
    @objc private func didTapArtistNameButton() {
        delegate?.didTapArtistNameButton()
    }
    
}
