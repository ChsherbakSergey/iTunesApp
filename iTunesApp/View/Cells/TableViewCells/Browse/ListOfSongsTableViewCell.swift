//
//  ListOfSongsTableViewCell.swift
//  iTunesApp
//
//  Created by Sergey on 12/10/20.
//

import UIKit

protocol ListOfSongsTableViewCellDelegate: AnyObject {
    func didTapAddTrack(addedAlready: Bool, numberOfTrack: Int)
}

final class ListOfSongsTableViewCell: UITableViewCell {
    
    //Identifier to use when register a cell
    static let identifier = "ListOfSongsTableViewCell"
    
    //Degate
    weak var delegate: ListOfSongsTableViewCellDelegate?
    
    //MARK: - Constants and Variables
    var isAddedTrack = false
    var numberOfTrack = 0
    
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
    
    public let addButton : UIButton = {
        let button = UIButton()
        button.tintColor = .systemPink
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
    
    //Setting the frame of the views
    override func layoutSubviews() {
        super.layoutSubviews()
        songNumberLabel.frame = CGRect(x: 20, y: 0, width: 30, height: contentView.height - 1)
        songNameLabel.frame = CGRect(x: 50, y: 0, width: contentView.width - 100, height: contentView.height - 1)
        addButton.frame = CGRect(x: contentView.width - 40, y: contentView.height / 2 - 10, width: 20, height: 20)
        lineView.frame = CGRect(x: 50, y: songNameLabel.bottom, width: contentView.width - 20, height: 0.5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        songNameLabel.text = nil
        songNumberLabel.text = nil
        lineView.backgroundColor = nil
        addButton.setImage(nil, for: .normal)
    }
    
    //MARK: - Configure View
    
    ///Configures Initial UI
    private func setInitialUI() {
        contentView.addSubview(songNameLabel)
        contentView.addSubview(songNumberLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(addButton)
    }
    
    ///Configures the view of the cell
    public func configureCell(with model: Track, numberOfSong: Int) {
        songNameLabel.text = model.trackName
        songNumberLabel.text = String(numberOfSong)
        lineView.backgroundColor = .systemGray
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    ///Sets targets to buttons
    private func setTargetsToButtons() {
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    ///Changes the image of the addButton to checkmark or to initial state if the user deleted the track
    @objc private func didTapAddButton() {
        if let buttonImage = addButton.image(for: .normal),
           let image = UIImage(systemName: "checkmark"),
           buttonImage.pngData() == image.pngData()
        {
            NotificationCenter.default.addObserver(self, selector: #selector(deletedTrack), name: Notification.Name("DeletedTrack"), object: nil)
            isAddedTrack = false
        } else {
            addButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            isAddedTrack = true
        }
        delegate?.didTapAddTrack(addedAlready: isAddedTrack, numberOfTrack: numberOfTrack)
    }
    
    ///Fires when the notification has been recieved
    @objc private func deletedTrack() {
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
}
