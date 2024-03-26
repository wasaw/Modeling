//
//  Extensions.swift
//  Modeling
//
//  Created by Александр Меренков on 24.03.2024.
//

import UIKit

// MARK: - UIView

extension UIView {
    func anchor (leading: NSLayoutXAxisAnchor? = nil,
                 top: NSLayoutYAxisAnchor? = nil,
                 trailing: NSLayoutXAxisAnchor? = nil,
                 bottom: NSLayoutYAxisAnchor? = nil,
                 paddingLeading: CGFloat = 0,
                 paddingTop: CGFloat = 0,
                 paddingTrailing: CGFloat = 0,
                 paddingBottom: CGFloat = 0,
                 width: CGFloat? = nil,
                 height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: paddingTrailing).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
