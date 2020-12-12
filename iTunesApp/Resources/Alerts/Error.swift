//
//  Error.swift
//  iTunesApp
//
//  Created by Sergey on 12/12/20.
//

import Foundation

enum ProjectError : Error {
    case networkingError(message: String)
    case guardElse(message: String)
}
