//
//  MainMandaratView.swift
//  Home
//
//  Created by choijunios on 12/7/24.
//

import UIKit

import SharedDesignSystem

import ReactorKit

final class MainMandaratView: UIView, View {
    
    // Sub view
    private let addMandaratView: AddMandaratView = .init()
    private let mainMandaratDisplayView: MainMandaratDisplayView = .init()
    
    var disposeBag: DisposeBag = .init()
    
    var reactor: MainMandaratViewModel?
    
    init() {
        
        super.init(frame: .zero)
        
        setLayer()
        setLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    func bind(reactor: MainMandaratViewModel) {
        
        self.reactor = reactor
        
        // Add MainMandarat button clicked
        addMandaratView.tap
            .map { _ in
                return Reactor.Action.addMandaratButtonClicked
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // Display button clicked
        mainMandaratDisplayView.tap
            .map { _ in
                return Reactor.Action.mainMandaratDisplayViewClicked
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        
        // Presentation for add mandarat
        reactor.state
            .map(\.isAvailable)
            .bind(to: addMandaratView.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        // Render mainMandaratDisplayView
        reactor.state
            .map(\.isAvailable)
            .map({ !$0 })
            .bind(to: mainMandaratDisplayView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.mandarat)
            .distinctUntilChanged()
            .bind(to: mainMandaratDisplayView.rx.renderObject)
            .disposed(by: disposeBag)
    }
    
    private func setLayer() {
        
        
    }
    
    private func setLayout() {
        
        // MARK: addMandaratView
        addSubview(addMandaratView)
        
        addMandaratView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        // MARK: mainMandaratDisplayView
        addSubview(mainMandaratDisplayView)
        
        mainMandaratDisplayView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
    }
}


// MARK: Public interface
extension MainMandaratView {
    
    func moveCenter(point: CGPoint) {
        
        let layersize = layer.bounds
        let xInset = layersize.width/2
        let yInset = layersize.height/2
        let move = self.transform.translatedBy(x: point.x-xInset, y: point.y-yInset)
        self.transform = move
    }
    
    func moveToIdentity() {
        
        self.transform = .identity
    }
}
