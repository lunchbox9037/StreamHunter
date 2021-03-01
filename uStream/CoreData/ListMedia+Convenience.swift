//
//  ListMedia.swift
//  uStream
//
//  Created by stanley phillips on 2/18/21.
//

import CoreData

extension ListMedia {
    @discardableResult convenience init(title: String, voteAverage: Double, overview: String, posterPath: String?, backdropPath: String?, id: Int, mediaType: String, popularity: Double, releaseDate: String, isInList: Bool = true, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.title = title
        self.voteAverage = voteAverage
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.id = Int64(id)
        self.mediaType = mediaType
        self.popularity = popularity
        self.releaseDate = releaseDate
        self.isInList = isInList
    }
}
