//
//  JSONHandler.swift
//  iTunesApp
//
//  Created by Sergey on 12/9/20.
//

import Foundation

final class JSONHandler {
    
    //MARK: - Singleton
    static let shared = JSONHandler()
    
    //MARK: - Constants And Variables
    let searchAlbumURL = "https://itunes.apple.com/search?entity=album&attribute=albumTerm&term="
    let getSongsFromTheAlbumURL = "https://itunes.apple.com/lookup?entity=song&id="
    
    //MARK: - Public functions
    
    /// Gets all albums for provided query
    /// - Parameters:
    ///   - query: String
    ///   - completion: ( [Album] ) -> ( )
    /// - Returns: Retruns an array of Album objects
    public func getAlbums (query: String, completion: @escaping ([Album]) -> ()) {
        var albums : [Album] = []
        let searchText = query.replacingOccurrences(of: " ", with: "+")
        let urlString = URL(string: "\(searchAlbumURL)\(searchText)")
        guard let url = urlString else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(ProjectError.networkingError(message: "Data is nil or error has occured while trying to get albums for url: \(url)"))
                return
            }
            do {
                guard let result = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
                    return
                }
                if let albumsResults = result["results"] as? NSArray {
                    for album in albumsResults {
                        if let albumInfo = album as? [String: AnyObject] {
                            guard let artistName = albumInfo["artistName"] as? String else {return}
                            guard let artworkUrl100 = albumInfo["artworkUrl100"] as? String else {return}
                            guard let artworkUrl60 = albumInfo["artworkUrl60"] as? String else {return}
                            guard let collectionId = albumInfo["collectionId"] as? Int else {return}
                            guard let collectionName = albumInfo["collectionName"] as? String else {return}
                            guard let country = albumInfo["country"] as? String else {return}
                            guard let primaryGenreName = albumInfo["primaryGenreName"] as? String else {return}
                            guard let releaseDate = albumInfo["releaseDate"] as? String else {return}
                            guard let copyright = albumInfo["copyright"] as? String else {return}
                            guard let trackCount = albumInfo["trackCount"] as? Int else {return}
                            guard let artistViewUrl = albumInfo["artistViewUrl"] as? String else {return}
                            let releaseDateFormatted = releaseDate.prefix(4)
                            let albumInstance = Album(artistName: artistName, artworkUrl100: artworkUrl100, artworkUrl60: artworkUrl60, collectionId: collectionId, collectionName: collectionName, country: country, primaryGenreName: primaryGenreName, releaseDate: String(releaseDateFormatted), copyright: copyright, trackCount: trackCount, artistViewUrl: artistViewUrl)
                            albums.append(albumInstance)
                        }
                    }
                    completion(albums)
                }
            } catch {
                print(ProjectError.networkingError(message: "Networking error while triyng to get albums for url: \(url)"))
            }
        }.resume()
    }
    
    /// Gets all songs for album with specified collectionId
    /// - Parameters:
    ///   - collectionId: Int
    ///   - completion: ( [Track] )  -> ( )
    /// - Returns: Retruns an array of Track objects
    public func getAlbumTracks (collectionId: Int, completion: @escaping ([Track]) -> ()) {
        var tracks = [Track]()
        let urlString = URL(string: "\(getSongsFromTheAlbumURL)\(collectionId)")
        guard let url = urlString else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(ProjectError.networkingError(message: "Data is nil or error has occured while trying to get songs for url: \(url)"))
                return
            }
            do {
                guard let result = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
                    return
                }
                if let trackResults = result["results"] as? NSArray {
                    for song in trackResults {
                        // 0 element is album info
                        if trackResults.index(of: song) != 0 {
                            if let songInfo = song as? [String: AnyObject] {
                                guard let trackName = songInfo["trackName"] as? String else {return}
                                guard let trackNumber = songInfo["trackNumber"] as? Int else {return}
                                guard let collectionName = songInfo["collectionName"] as? String else {return}
                                guard let artistName = songInfo["artistName"] as? String else {return}
                                guard let primaryGenreName = songInfo["primaryGenreName"] as? String else {return}
                                guard let previewUrl = songInfo["previewUrl"] as? String else {return}
                                guard let artworkUrl100 = songInfo["artworkUrl100"] as? String else {return}
                                guard let releaseDate = songInfo["releaseDate"] as? String else {return}
                                let releaseDateFormatted = releaseDate.prefix(4)
                                let track = Track(trackName: trackName, trackNumber: trackNumber, collectionName: collectionName, artistName: artistName, primaryGenreName: primaryGenreName, releaseDate: String(releaseDateFormatted), previewUrl: previewUrl, artworkUrl100: artworkUrl100)
                                tracks.append(track)
                            }
                        }
                    }
                    completion(tracks)
                }
            } catch {
                print(ProjectError.networkingError(message: "Networking error while triyng to get songs for url: \(url)"))
            }
        }.resume()
    }
    
}
