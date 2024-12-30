//
//  ViewLessRouter.swift
//  SharedPresentationExt
//
//  Created by choijunios on 12/30/24.
//

open class ViewLessRouter<Interactor>: Routable {
    
    public let interactor: Interactor
    
    public var children: [any Routable] = []
    
    public init(interactor: Interactor) {
        self.interactor = interactor
    }
}
