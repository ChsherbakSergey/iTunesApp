//
//  SettingsTableViewCell.swift
//  iTunesApp
//
//  Created by Sergey on 12/12/20.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let identifier = "SettingsTableViewCell"
    
    //MARK: - Views that will be displayed on this cell
    
    private let iconContainer : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setInitialUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Frame of the iconContainer
        let containerSize: CGFloat = contentView.height - 12
        iconContainer.frame = CGRect(x: 20, y: 6, width: containerSize, height: containerSize)
        iconContainer.layer.cornerRadius = 8
        //Frame of the iconImageView
        let iconSize: CGFloat = containerSize / 1.5
        iconImageView.frame = CGRect(x: (containerSize - iconSize) / 2, y: (containerSize - iconSize) / 2, width: iconSize, height: iconSize)
        //Frame of the title label
        titleLabel.frame = CGRect(x: iconContainer.right + 15, y: 0, width: contentView.width - 45 - iconContainer.width, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
        iconContainer.backgroundColor = nil
    }
    
    //MARK: - Configure the view
    
    ///Configures Initial UI
    private func setInitialUI() {
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    ///Configures the content of the cell
    public func configureCell(with model: Settings) {
        iconContainer.backgroundColor = model.iconBackgroundColor
        iconImageView.image = model.iconImage
        titleLabel.text = model.title
    }
}
