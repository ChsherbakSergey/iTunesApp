//
//  ListOfSongsTableViewCell.swift
//  iTunesApp
//
//  Created by Sergey on 12/10/20.
//

import UIKit

class ListOfSongsTableViewCell: UITableViewCell {
    
    //Identifier to use when register a cell
    static let identifier = "ListOfSongsTableViewCell"
    
    //MARK: - Views that will be displayed on this cell
    private let songNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let songNumberLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        songNumberLabel.frame = CGRect(x: 20, y: 0, width: 30, height: contentView.height - 1)
        songNameLabel.frame = CGRect(x: 50, y: 0, width: contentView.width - 100, height: contentView.height - 1)
        lineView.frame = CGRect(x: 50, y: songNameLabel.bottom, width: contentView.width - 20, height: 0.25)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        songNameLabel.text = nil
        songNumberLabel.text = nil
        lineView.backgroundColor = nil
    }
    
    //MARK: - Configure View
    
    private func setInitialUI() {
        contentView.addSubview(songNameLabel)
        contentView.addSubview(songNumberLabel)
        contentView.addSubview(lineView)
    }
    
    public func configureCell(with model: Track, numberOfSong: Int) {
        songNameLabel.text = model.trackName
        songNumberLabel.text = String(numberOfSong)
        lineView.backgroundColor = .systemGray
    }
}
