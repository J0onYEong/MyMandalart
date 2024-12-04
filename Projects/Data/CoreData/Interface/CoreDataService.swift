//
//  CoreDataService.swift
//  CoreData
//
//  Created by choijunios on 12/5/24.
//

import CoreData

import RxSwift

public protocol CoreDataService {
    
    func fetch<Entity: NSManagedObject>(predicate: NSPredicate?) -> Single<[Entity]>
}

