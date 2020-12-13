//
//  Track.swift
//  iTunesApp
//
//  Created by Sergey on 12/9/20.
//

import Foundation

//Presents Track objects
struct Track : Codable {
    
    let trackName: String
    let trackNumber: Int
    let collectionName: String
    let artistName: String
    let primaryGenreName: String
    let releaseDate: String
    let previewUrl: String
    let artworkUrl100: String

}
