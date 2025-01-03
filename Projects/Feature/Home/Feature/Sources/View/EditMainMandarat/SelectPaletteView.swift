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
    private let titleLabel: UILabel = .init()
    private let scrollView: UIScrollView = .init()
    private var cellViews: [MandalartPalette: PaletteCellView] = [:]
    
    
    fileprivate let paletteTypePublisher: PublishRelay<MandalartPalette> = .init()
    
    private let disposeBag: DisposeBag = .init()
    
    init(titleText: String) {
        
        titleLabel.text = titleText
        
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setReactive()
    }
    required init?(coder: NSCoder) { nil }
    
    
    public func update(type: MandalartPalette) {
        
        cellViews.forEach { palette, view in
            view.update(isFocused: palette == type)
        }
    }
    
    
    private func setUI() {
        
        // self
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        self.layer.cornerRadius = 15
        
        // titleLabel
        titleLabel.font = .preferredFont(forTextStyle: .caption1)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        
        // scrollView
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    
    private func setLayout() {
        
        var tapObservables: [Observable<MandalartPalette>] = []
        var cellViews: [UIView] = []
        
        MandalartPalette.orderedList.forEach { palette in
            
            let view = PaletteCellView(
                color1: palette.colors.backgroundColor.primaryColor,
                color2: palette.colors.textColor.primaryColor,
                color3: palette.colors.gageColor.primaryColor
            )
            
            self.cellViews[palette] = view
            
            cellViews.append(view)
            tapObservables.append(view.tap.map { _ in palette })
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
        
        
        let mainStack: UIStackView = .init(arrangedSubviews: [titleLabel, scrollView])
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.distribution = .fill
        mainStack.alignment = .fill
        
        
        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        scrollView.snp.makeConstraints { make in
            make.height.equalTo(45).priority(.required)
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
    
    var selectedType: Observable<MandalartPalette> {
        
        base.paletteTypePublisher.asObservable()
    }
}


#Preview {
    
    SelectPaletteView(titleText: "만다라트 컬러 선택")
}
