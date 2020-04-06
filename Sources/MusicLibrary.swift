//
//  MusicLibrary.swift
//  AUHost
//
//  Created by Vlad Gorlov on 06.04.20.
//  Copyright © 2020 WaveLabs. All rights reserved.
//

import Foundation
import iTunesLibrary

struct MusicLibraryItem {
   let title: String
   let artist: String
   let url: URL
   
   var fullName: String {
      return "\(artist): \(title)"
   }
}

class MusicLibrary {
   
   private var tunesLibrary: ITLibrary?
   
   private (set) var items: [MusicLibraryItem] = []
   
   init() {
      do {
         let tunesLibrary = try ITLibrary(apiVersion: "1.0")
         var songs = tunesLibrary.allMediaItems.filter { $0.location != nil }
         songs = songs.filter { $0.mediaKind == .kindSong && $0.locationType == .file }
         items = songs.map { MusicLibraryItem(title: $0.title, artist: $0.artist?.name ?? "Unknown", url: $0.location!) }
         items = items.sorted(by: { $0.artist < $1.artist })
         self.tunesLibrary = tunesLibrary
      } catch {
         log.error(.media, error)
      }
   }
}
