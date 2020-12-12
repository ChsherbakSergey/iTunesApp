//
//  Settings.swift
//  iTunesApp
//
//  Created by Sergey on 12/12/20.
//

import UIKit

struct Settings {
    let title: String
    let iconImage: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

struct Section {
    let title: String
    let options: [Settings]
}
