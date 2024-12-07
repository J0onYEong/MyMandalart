//
//  CoreDataServiceTests.swift
//
//

import XCTest
import CoreData

@testable import DataCoreData
@testable import DataCoreDataInterface

import RxTest
import RxSwift

class CoreDataServiceTests: XCTestCase {
    
    private var coreDataService: CoreDataService!
    private let disposeBag: DisposeBag = .init()
    
    override func setUp() {
        
        self.coreDataService = DefaultCoreDataService()
    }
    
    func testCreateAndRead() {
        
        let testEntityName = "MainMandarat"
        let testProperty = "TestValue"
        
        // When: 엔티티를 저장합니다.
        let saveExpectation = expectation(description: "Save Entity")
        coreDataService.save { context, completion in
            
            let entity = NSEntityDescription.insertNewObject(forEntityName: testEntityName, into: context) as! MainMandaratEntity
            
            entity.title = testProperty
            
            do {
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
        .subscribe(onSuccess: {
            saveExpectation.fulfill()
        }, onFailure: { error in
            XCTFail("저장실패: \(error)")
        })
        .disposed(by: disposeBag)
        
        wait(for: [saveExpectation], timeout: 5.0)
        
        // Then: 저장된 데이터를 fetch하고, 저장 전후의 데이터를 비교합니다.
        let fetchExpectation = expectation(description: "Fetch Entity")
        coreDataService.fetch(predicate: nil)
            .subscribe(onSuccess: { (entities: [MainMandaratEntity]) in
                guard let fetchedEntity = entities.first else {
                    XCTFail("No entities found")
                    return
                }
                
                XCTAssertEqual(fetchedEntity.title, testProperty, "테스트 프로퍼티가 일치하지 않습니다.")
                
                fetchExpectation.fulfill()
            }, onFailure: { error in
                XCTFail("Fetch실패: \(error)")
            })
            .disposed(by: disposeBag)
        
        wait(for: [fetchExpectation], timeout: 5.0)
    }
}
