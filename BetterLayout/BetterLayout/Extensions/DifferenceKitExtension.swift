//
//  DifferenceKitExtension.swift
//  Trading
//
//  Created by Vlad Che on 1/23/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation
import DifferenceKit

extension StagedChangeset {
    func map<U>(_ transform: (Collection.Element) -> U) -> StagedChangeset<[U]> {
        var changesets: [Changeset<[U]>] = []
        for changeset in self {
            changesets.append(changeset.map(transform))
        }
        return StagedChangeset<[U]>(changesets)
    }
}

extension Changeset {
    func map<U>(_ transform: (Collection.Element) -> U) -> Changeset<[U]> {
        return Changeset<[U]>(data: self.data.map(transform),
                              sectionDeleted: self.sectionDeleted,
                              sectionInserted: self.sectionInserted,
                              sectionUpdated: self.sectionUpdated,
                              sectionMoved: self.sectionMoved,
                              elementDeleted: self.elementDeleted,
                              elementInserted: self.elementInserted,
                              elementUpdated: self.elementUpdated,
                              elementMoved: self.elementMoved)
        
    }
}
