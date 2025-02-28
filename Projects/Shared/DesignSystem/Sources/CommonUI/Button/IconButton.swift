//
//  IconView.swift
//  SharedDesignSystem
//
//  Created by choijunios on 2/28/25.
//

import UIKit

import SnapKit

public final class IconButton: TappableView {
    // Sub views
    private let imageView: UIImageView = .init()
    
    
    // Style
    private var style: Style
    
    
    public override var intrinsicContentSize: CGSize {
        style.size.value ?? super.intrinsicContentSize
    }
    
    public init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    public required init?(coder: NSCoder) { nil }
    
    public override func onTouchIn() {
        self.alpha = 0.65
    }
    
    public override func onTouchOut(isInbound: Bool?) {
        self.alpha = 1
    }
}


// MARK: Public interface
public extension IconButton {
    
    @discardableResult
    func update(image: UIImage?) -> Self {
        imageView.image = image
        return self
    }
    
    @discardableResult
    func update(tintColor: UIColor) -> Self {
        imageView.tintColor = tintColor
        return self
    }
    
    struct Style {
        let size: Size
        let edgeInset: CGFloat
        
        public init(
            size: Size,
            edgeInset: CGFloat = 0
        ) {
            self.size = size
            self.edgeInset = edgeInset
        }
    }
    
    enum Size {
        case small
        case normal
        case flexible
        
        var value: CGSize? {
            switch self {
            case .small:
                .init(width: 28, height: 28)
            case .normal:
                .init(width: 32, height: 32)
            case .flexible:
                nil
            }
        }
    }
}


// MARK: Setup
private extension IconButton {
    func setupUI() {
        // self
        self.backgroundColor = .clear
        
        // imageView
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }
    
    func setupLayout() {
        // imageView
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().priority(.high)
        }
    }
}
