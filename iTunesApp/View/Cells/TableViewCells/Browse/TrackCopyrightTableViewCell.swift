//
//  TrackCopyrightTableViewCell.swift
//  iTunesApp
//
//  Created by Sergey on 12/10/20.
//

import UIKit

final class TrackCopyrightTableViewCell: UITableViewCell {

    //Identifier to use when register a cell
    static let identifier = "TrackCopyrightTableViewCell"
    
    //MARK: Views that will be displayed on this cell
    private let numberOfSongsLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let copyrightLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = .systemFont(ofSize: 14, weight: .regular)
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
    
    //Setting frames of the views
    override func layoutSubviews() {
        super.layoutSubviews()
        numberOfSongsLabel.frame = CGRect(x: 20, y: 5, width: contentView.width - 40, height: 20)
        copyrightLabel.frame = CGRect(x: 20, y: numberOfSongsLabel.bottom + 5, width: contentView.width - 40, height: 15)
        lineView.frame = CGRect(x: 20, y: contentView.bottom - 0.25, width: contentView.width - 10, height: 0.5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        numberOfSongsLabel.text = nil
        copyrightLabel.text = nil
        lineView.backgroundColor = nil
    }
    
    //MARK: - Configure View
    private func setInitialUI() {
        //When user tap on the cell it won't show the selectable animation
        selectionStyle = .none
        //Adding subviews
        contentView.addSubview(numberOfSongsLabel)
        contentView.addSubview(copyrightLabel)
        contentView.addSubview(lineView)
    }
    
    //Configures the view of the cell
    public func configureCell(with copyright: String, numberOfTracks: Int) {
        numberOfSongsLabel.text = String(numberOfTracks) + " songs"
        copyrightLabel.text = copyright
        lineView.backgroundColor = .systemGray
    }
    
}
