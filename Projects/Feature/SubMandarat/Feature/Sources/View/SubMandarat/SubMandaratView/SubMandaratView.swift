//
//  SubMandaratView.swift
//  Home
//
//  Created by choijunios on 12/11/24.
//

import UIKit

import SharedPresentationExt
import SharedDesignSystem

import ReactorKit
import SnapKit
import RxSwift
import RxCocoa

class SubMandaratView: UIView, View {
    
    // Sub view
    private let addSubMandaratView: AddSubMandaratView = .init()
    private let subMandaratDisplayView: SubMandaratDisplayView = .init()
    
    var reactor: SubMandaratViewModel?
    var disposeBag: DisposeBag = .init()
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setUI() {
        
        self.layer.cornerRadius = SubMandaratConfig.cornerRadius
        self.backgroundColor = UIColor.black
    }
    
    private func setLayout() {
        
        // addSubMandaratView
        addSubview(addSubMandaratView)
        addSubMandaratView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        
        // subMandaratDisplayView
        addSubview(subMandaratDisplayView)
        subMandaratDisplayView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: SubMandaratViewModel) {
        
        self.reactor = reactor
        
        // Bind, AddSubMandaratView
        reactor.state
            .distinctDriver(\.isAvailable, addSubMandaratView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .distinctDriver(\.palette)
            .drive(onNext: { [weak self] palette in
                
                self?.addSubMandaratView.update(
                    backgroundColor: palette.colors.backgroundColor.primaryColor,
                    imageColor: palette.colors.backgroundColor.secondColor
                )
            })
            .disposed(by: disposeBag)
        
        addSubMandaratView.rx.tap
            .map { _ in Reactor.Action.editSubMandaratButtonClicked }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // Bind, subMandaratDisplayView
        reactor.state
            .distinctDriver(\.isAvailable)
            .map({ !$0 })
            .drive(subMandaratDisplayView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter(\.isAvailable)
            .subscribe(onNext: { [weak self] state in
                
                self?.subMandaratDisplayView.update(
                    title: state.titleText,
                    percent: state.acheivementRate,
                    palette: state.palette
                )
            })
            .disposed(by: disposeBag)
        
        subMandaratDisplayView.rx.longPressEvent
            .map { _ in Reactor.Action.longPress }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: Public interface
extension SubMandaratView {
    
    func moveCenter(point: CGPoint) {
        
        let layersize = layer.bounds
        let xInset = layersize.width/2
        let yInset = layersize.height/2
        let move = self.transform.translatedBy(x: point.x-xInset, y: point.y-yInset)
        self.transform = move
    }
    
    enum MoveDirection: CaseIterable {
        case top, left, down, right
        
        static var random: MoveDirection {
            
            MoveDirection.allCases.randomElement()!
        }
    }
    
    func moveOneInch(direction: MoveDirection) {
        
        var destination: CGPoint = .zero
        
        let size = layer.bounds
        
        switch direction {
        case .top:
            destination = .init(
                x: 0,
                y: -size.height
            )
        case .left:
            destination = .init(
                x: -size.width,
                y: 0
            )
        case .down:
            destination = .init(
                x: 0,
                y: size.height
            )
        case .right:
            destination = .init(
                x: size.width,
                y: 0
            )
        }
        
        let desTransform = self.transform.translatedBy(x: destination.x, y: destination.y)
        self.transform = desTransform
    }
    
    func moveToIdentity() {
        
        self.transform = .identity
    }
}
