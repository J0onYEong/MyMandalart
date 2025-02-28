//
//  ObservableType+Ext.swift
//  SharedPresentationExt
//
//  Created by choijunios on 2/28/25.
//

import RxSwift

public extension ObservableType {
    func convert<T>(_ value: T) -> Observable<T> {
        self.map({ _ in value })
    }
}
