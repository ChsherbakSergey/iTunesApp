//
//  TrackTableViewHeader.swift
//  iTunesApp
//
//  Created by Sergey on 12/9/20.
//


import Foundation
import UIKit

final class TrackTableHeaderView : UIView {
    
    //MARK: - Views that will be displayed on this tableView Header
    
    public let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //MARK: - INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitialUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x:  width / 6, y: 20, width: width / 1.5, height: width / 1.5)
        imageView.layer.cornerRadius = 5
    }
    
    //MARK: - Functions
    
    ///Sets Initial UI
    private func setInitialUI() {
        addSubview(imageView)
    }
    
}

