//
//  CoreDataService.swift
//  CoreData
//
//  Created by choijunios on 12/5/24.
//

import CoreData

import RxSwift

public protocol CoreDataService: AnyObject {
    
    func fetch<Entity: NSManagedObject>(predicate: NSPredicate?) -> Single<[Entity]>
    
    
    func save(closure: @escaping (NSManagedObjectContext, (Result<Void, Error>) -> Void) -> Void) -> Single<Void>
}

