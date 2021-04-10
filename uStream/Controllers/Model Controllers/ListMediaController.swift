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
    var upcoming: [ListMedia] = []
    
    private lazy var fetchRequest: NSFetchRequest<ListMedia> = {
        let request = NSFetchRequest<ListMedia>(entityName: "ListMedia")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // MARK: - CRUD
    func addToList(media: Media) {
        let mediaType = media.getMediaTypeFor(media)
        let releaseDate = media.convertToDate(media)
        print(mediaType)
        ListMedia(title: (media.title ?? media.name) ?? "The Matrix", voteAverage: media.voteAverage ?? 0.0, overview: media.overview ?? "Synopsis Unavailable", posterPath: media.posterPath, backdropPath: media.backdropPath, id: media.id ?? 0, mediaType: mediaType, popularity: media.popularity ?? 0.0, releaseDate: releaseDate)
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
        upcoming = listMedia.filter({ (media) -> Bool in
            if let releaseDate = media.releaseDate {
                return releaseDate > Date()
            } else {
                return false
            }
        })
    }
    
    func delete(media: ListMedia) {
        NotificationScheduler.shared.cancelNotification(media: media)
        CoreDataStack.context.delete(media)
        CoreDataStack.saveContext()
    }
}//end class
