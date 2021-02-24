//
//  ListMedia.swift
//  uStream
//
//  Created by stanley phillips on 2/18/21.
//

import CoreData

extension ListMedia {
    @discardableResult convenience init(title: String, voteAverage: Double, overview: String, poster: String?, id: Int, mediaType: String, popularity: Double, releaseDate: String, isFavorite: Bool = true, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.title = title
        self.voteAverage = voteAverage
        self.overview = overview
        self.poster = poster
        self.id = Int64(id)
        self.mediaType = mediaType
        self.popularity = popularity
        self.releaseDate = releaseDate
        self.isFavorite = isFavorite
    }
}
