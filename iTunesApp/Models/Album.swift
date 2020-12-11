//
//  Album2.swift
//  iTunesApp
//
//  Created by Sergey on 12/9/20.
//

import Foundation

struct Album: Comparable {
    
    let artistName: String
    let artworkUrl100: String
    let artworkUrl60: String
    let collectionId: Int
    let collectionName: String
    let country: String
    let primaryGenreName: String
    let releaseDate: String
    let copyright: String
    let trackCount: Int
    let artistViewUrl: String
    
    static func ==(lhs: Album, rhs: Album) -> Bool {
        return lhs.collectionName == rhs.collectionName
    }
    
    static func <(lhs: Album, rhs: Album) -> Bool {
        return lhs.collectionName < rhs.collectionName
    }
    
}
