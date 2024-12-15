//
//  EditSubMandaratViewController.swift
//  Home
//
//  Created by choijunios on 12/15/24.
//

import UIKit

import SharedDesignSystem

import ReactorKit
import RxSwift
import RxCocoa

class EditSubMandaratViewController: UIViewController {
    
    // Sub view
    private let backgroundView: TappableView = .init()
    private let inputContainerBackView: UIView = .init()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundView()
        setLayout()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setInputContainerViewShape()
    }
    
    
    private func setBackgroundView() {
        
        view.backgroundColor = .clear
        
        backgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        let tapGesture: UITapGestureRecognizer = .init()
        backgroundView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(onBackgroundViewTapped))
    }
    
    
    @objc private func onBackgroundViewTapped() {
        
        
    }
    
    
    private func setLayout() {
        
        // MARK: backgroundView
        view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // MARK: inputContainerBackView
        view.addSubview(inputContainerBackView)
        
        inputContainerBackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: InputContainerView drawing
private extension EditSubMandaratViewController {
    
    func setInputContainerViewShape() {
        
        inputContainerBackView.backgroundColor = .white
        
        let shapeLayer: CAShapeLayer = .init()
        shapeLayer.frame = inputContainerBackView.bounds
        
        let rect = shapeLayer.bounds
        let minRadius: CGFloat = 30
        let maxRadius: CGFloat = 90
        let path = CGMutablePath()
        path.move(to: .init(x: rect.minX, y: rect.maxY))
        
        path.addLine(to: .init(x: rect.minX, y: minRadius))
        
        path.addCurve(
            to: .init(x: maxRadius, y: rect.minY),
            control1: .init(x: rect.minX, y: rect.minY),
            control2: .init(x: rect.minX, y: rect.minY)
        )
        
        path.addLine(to: .init(x: rect.maxX-maxRadius, y: rect.minY))
        
        path.addCurve(
            to: .init(x: rect.maxX, y: minRadius),
            control1: .init(x: rect.maxX, y: rect.minY),
            control2: .init(x: rect.maxX, y: rect.minY)
        )
        
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        path.addLine(to: .init(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        shapeLayer.path = path
        shapeLayer.strokeEnd = 1
        shapeLayer.fillColor = UIColor.white.cgColor
        
        inputContainerBackView.layer.mask = shapeLayer
    }
    
}
