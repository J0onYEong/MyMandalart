//
//  ControlEvent+Ext.swift
//  SharedPresentationExt
//
//  Created by choijunios on 2/28/25.
//

import RxCocoa
import RxSwift

public extension ControlEventType {
    func convert<T>(_ value: T) -> Observable<T> {
        self.map { _ in value }
    }
}
