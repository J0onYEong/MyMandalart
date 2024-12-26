//
//  RxCocoa+Ext.swift
//  SharedPresentationExt
//
//  Created by choijunios on 12/26/24.
//

import RxCocoa
import RxSwift

public extension ObservableType {
    
    func distinctDriver<Result, Observer: ObserverType>(_ transform: @escaping (Element) throws -> Result, _ observers: Observer...) -> Disposable where Result: Equatable, Observer.Element == Result {
        
        let driver = self
            .map(transform)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .never())
        
        return CompositeDisposable(disposables: observers.map { observer in
            driver.drive(observer)
        })
    }
    
    func distinctDriver<Result>(_ transform: @escaping (Element) throws -> Result) -> Driver<Result> where Result: Equatable {
        
        return self
            .map(transform)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .never())
    }
}
