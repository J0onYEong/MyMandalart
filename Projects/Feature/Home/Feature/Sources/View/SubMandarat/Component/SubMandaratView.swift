//
//  SubMandaratView.swift
//  Home
//
//  Created by choijunios on 12/11/24.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

class SubMandaratView: UIView {
    
    init() {
        super.init(frame: .zero)
        
        setUI()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setUI() {
        
        layer.cornerRadius = SubMandaratConfig.corenrRadius
        
        self.backgroundColor = UIColor.black
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
    
    func moveToIdentity() {
        
        self.transform = .identity
    }
}
