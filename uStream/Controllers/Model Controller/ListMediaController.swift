//
//  ListMediaController.swift
//  uStream
//
//  Created by stanley phillips on 2/28/21.
//

import CoreData

class ListMediaController {
    // MARK: - Properties
    static let shared = ListMediaController()
    var listMedia: [ListMedia] = []
    var listMediaTV: [ListMedia] = []
    var listMediaMovie: [ListMedia] = []
    
    private lazy var fetchRequest: NSFetchRequest<ListMedia> = {
        let request = NSFetchRequest<ListMedia>(entityName: "ListMedia")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // MARK: - CRUD
    func addToList(media: Media) {
        var mediaType: String = "movie"
        if media.title == nil {
            mediaType = "tv"
        }
        ListMedia(title: (media.title ?? media.name) ?? "The Matrix", voteAverage: media.voteAverage ?? 0.0, overview: media.overview ?? "Synopsis Unavailable", posterPath: media.posterPath, backdropPath: media.backdropPath, id: media.id ?? 0, mediaType: mediaType, popularity: media.popularity ?? 0.0, releaseDate: (media.releaseDate ?? media.firstAirDate) ?? "Unknown")
        CoreDataStack.saveContext()
    }
    
    func fetchListMedia() {
        listMedia = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        listMediaTV = listMedia.filter({ (media) -> Bool in
            return media.mediaType == "tv"
        })
        listMediaMovie = listMedia.filter({ (media) -> Bool in
            return media.mediaType == "movie"
        })
    }
    
    func delete(item: ListMedia) {
        CoreDataStack.context.delete(item)
        CoreDataStack.saveContext()
    }
    
    func toggleIsInList(listMedia: ListMedia) {
        listMedia.isInList.toggle()
    }    
}//end class
