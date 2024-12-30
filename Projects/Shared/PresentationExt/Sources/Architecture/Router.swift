//
//  Router.swift
//  SharedPresentationExt
//
//  Created by choijunios on 12/27/24.
//

public protocol Routable: AnyObject {
    
    var children: [any Routable] { get set }
    
    func attach(_ child: any Routable)
    
    func dettach(_ child: any Routable)
}

public extension Routable {
    
    func attach(_ child: any Routable) {
        children.append(child)
    }
    
    func dettach(_ child: any Routable) {
        guard let index = children.firstIndex(where: { $0 === child }) else { return }
        children.remove(at: index)
    }
}

open class Router<ViewModel, ViewController>: Routable {
    
    public let viewModel: ViewModel
    public let viewController: ViewController
    
    public var children: [any Routable] = []
    
    public init(viewModel: ViewModel, viewController: ViewController) {
        self.viewModel = viewModel
        self.viewController = viewController
    }
}
