//
//  Router.swift
//  SharedPresentationExt
//
//  Created by choijunios on 12/27/24.
//

public protocol Routable: AnyObject {
    
    associatedtype ViewModel
    associatedtype ViewController
    
    func attach(_ child: any Routable)
    
    func dettach(_ child: any Routable)
}

open class Router<ViewModel, ViewController>: Routable {
    
    public let viewModel: ViewModel
    public let viewController: ViewController
    
    public private(set) var children: [any Routable] = []
    
    public init(viewModel: ViewModel, viewController: ViewController) {
        self.viewModel = viewModel
        self.viewController = viewController
    }
    
    public func attach(_ child: any Routable) {
        children.append(child)
    }
    
    public func dettach(_ child: any Routable) {
        guard let index = children.firstIndex(where: { $0 === child }) else { return }
        children.remove(at: index)
    }
}
