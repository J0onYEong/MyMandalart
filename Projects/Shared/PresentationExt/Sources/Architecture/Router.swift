//
//  Router.swift
//  SharedPresentationExt
//
//  Created by choijunios on 12/27/24.
//

open class Router<ViewModel, ViewController> {
    
    public let viewModel: ViewModel
    public let viewController: ViewController
    
    public private(set) var children: [Router] = []
    
    public init(viewModel: ViewModel, viewController: ViewController) {
        self.viewModel = viewModel
        self.viewController = viewController
    }
    
    @MainActor
    public func attach(_ child: Router) {
        children.append(child)
    }
    
    @MainActor
    public func dettach(_ child: Router) {
        guard let index = children.firstIndex(where: { $0 === child }) else { return }
        children.remove(at: index)
    }
}
