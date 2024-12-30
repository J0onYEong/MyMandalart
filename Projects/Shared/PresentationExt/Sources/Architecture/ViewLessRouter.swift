//
//  ViewLessRouter.swift
//  SharedPresentationExt
//
//  Created by choijunios on 12/30/24.
//

open class ViewLessRouter<ViewModel>: Routable {
    
    public let viewModel: ViewModel
    
    public var children: [any Routable] = []
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}
