//
//  SelectPaletteView.swift
//  Home
//
//  Created by choijunios on 1/1/25.
//

import UIKit

import SharedDesignSystem

import SnapKit
import RxSwift
import RxRelay

class SelectPaletteView: UIView {
    
    // Sub views
    private let scrollView: UIScrollView = .init()
    private var cellViews: [MandalartPaletteBundle: PaletteCellView] = [:]
    
    
    fileprivate let paletteTypePublisher: BehaviorRelay<MandalartPaletteBundle> = .init(value: .type1)
    
    private let disposeBag: DisposeBag = .init()
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setReactive()
    }
    required init?(coder: NSCoder) { nil }
    
    
    private func setUI() {
        
        scrollView.backgroundColor = .clear
    }
    
    
    private func setLayout() {
        
        var tapObservables: [Observable<MandalartPaletteBundle>] = []
        var cellViews: [UIView] = []
        
        MandalartPaletteBundle.orderedList.forEach { paletteType in
            
            let view = PaletteCellView(
                color1: paletteType.palette.backgroundColor.primaryColor,
                color2: paletteType.palette.textColor.primaryColor,
                color3: paletteType.palette.gageColor.primaryColor
            )
            
            self.cellViews[paletteType] = view
            
            cellViews.append(view)
            tapObservables.append(view.tap.map { _ in paletteType })
        }
        
        
        // Bind to paletteTypePublisher
        Observable
            .merge(tapObservables)
            .bind(to: self.paletteTypePublisher)
            .disposed(by: disposeBag)
        
        
        let cellStack: UIStackView = .init(arrangedSubviews: cellViews)
        cellStack.axis = .horizontal
        cellStack.spacing = 5
        cellStack.distribution = .fillEqually
        cellStack.alignment = .fill
        
        
        scrollView.addSubview(cellStack)
        let contentGuide = scrollView.contentLayoutGuide
        let frameGuide = scrollView.frameLayoutGuide
        
        cellStack.snp.makeConstraints { make in
            make.edges.equalTo(contentGuide.snp.edges)
            make.height.equalTo(frameGuide.snp.height)
        }
        
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    private func setReactive() {
        
        paletteTypePublisher
            .subscribe(onNext: { [weak self] paletteType in
                
                guard let self else { return }
                
                cellViews.forEach { type, cellView in
                    
                    cellView.update(isFocused: type == paletteType)
                }
                
            })
            .disposed(by: disposeBag)
    }
}


extension Reactive where Base == SelectPaletteView {
    
    var selectedType: Observable<MandalartPaletteBundle> {
        
        base.paletteTypePublisher.asObservable()
    }
}


#Preview(traits: .fixedLayout(width: 300, height: 65)) {
    
    SelectPaletteView()
}
