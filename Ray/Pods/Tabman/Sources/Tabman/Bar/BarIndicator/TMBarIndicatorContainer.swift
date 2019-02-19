//
//  TMBarIndicatorContainer.swift
//  Tabman
//
//  Created by Merrick Sapsford on 02/09/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import Foundation

/// Container view that embeds a `TMBarIndicator`.
///
/// Used for providing AutoLayout properties to `TMBarIndicatorLayoutHandler`.
internal final class TMBarIndicatorContainer<Indicator: TMBarIndicator>: UIView {
    
    // MARK: Properties
    
    private(set) var layoutHandler: TMBarIndicatorLayoutHandler!
    
    // MARK: Init
    
    init(for indicator: Indicator) {
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        layout(indicator: indicator)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: Layout
    
    private func layout(indicator: Indicator) {
        guard indicator.superview == nil else {
            fatalError("Indicator already has a superview.")
        }
        
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = indicator.leadingAnchor.constraint(equalTo: leadingAnchor)
        let top = indicator.topAnchor.constraint(equalTo: topAnchor)
        let bottom = indicator.bottomAnchor.constraint(equalTo: bottomAnchor)
        let width = indicator.widthAnchor.constraint(equalToConstant: 0.0)
        
        NSLayoutConstraint.activate([leading, top, bottom, width])
        self.layoutHandler = TMBarIndicatorLayoutHandler(leading: leading,
                                                       width: width)
    }
}
