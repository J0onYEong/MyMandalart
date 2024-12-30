//
//  DefaultCoreDataService.swift
//  CoreData
//
//  Created by choijunios on 12/5/24.
//

import Foundation
import CoreData

import DataCoreDataInterface

import RxSwift

public class DefaultCoreDataService: CoreDataService {
    
    private var container: NSPersistentContainer!
    
    public init() {
        
        prepareContainer()
    }
    
    public func fetch<Entity>(predicate: NSPredicate?) -> Single<[Entity]> where Entity : NSManagedObject {
        
        Single.create { [weak self] promise in
            
            guard let self else { return Disposables.create() }
        
            let fetchRequest = Entity.fetchRequest() as! NSFetchRequest<Entity>
            fetchRequest.predicate = predicate
            
            let context = container.newBackgroundContext()
            
            do {
                
                let entities = try context.fetch(fetchRequest)
                promise(.success(entities))
                
            } catch {
                promise(.failure(error))
            }
            
            return Disposables.create {
                
                context.reset()
            }
        }
    }
    
    public func save(closure: @escaping (NSManagedObjectContext, (Result<Void, Error>) -> Void) -> Void) -> Single<Void> {
        
        Single.create { [weak self] promise in
            
            guard let self else { return Disposables.create() }
            
            let context = container.newBackgroundContext()
            
            closure(context) { result in
                
                switch result {
                case .success:
                    
                    promise(.success(()))
                    
                case .failure(let error):
                    
                    promise(.failure(error))
                }
            }
            
            return Disposables.create {
                
                context.reset()
            }
        }
    }
}

private extension DefaultCoreDataService {
    
    func prepareContainer() {
        
        let bundle = DataCoreDataInterfaceResources.bundle
        let modelURL = bundle.url(forResource: "Default", withExtension: ".momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(name: "DefaultStorage", managedObjectModel: model)
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataBasePath = storeURL.appending(path: "DefaultStorage.sqlite")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: dataBasePath)]
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
            print("✅ NSPersistentContainer loaded")
        }
        self.container = container
    }
}
