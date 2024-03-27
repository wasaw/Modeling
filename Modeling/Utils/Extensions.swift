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

// MARK: - Color

extension UIColor {
    static let background = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            UIColor(red: 255/255, green: 238/255, blue: 219/255, alpha: 1)
        case .dark:
            UIColor(red: 255/255, green: 238/255, blue: 219/255, alpha: 1)
        @unknown default:
            UIColor(red: 255/255, green: 238/255, blue: 219/255, alpha: 1)
        }
    }
    static let logoBackground = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            UIColor(red: 47/255, green: 68/255, blue: 162/255, alpha: 1)
        case .dark:
            UIColor(red: 47/255, green: 68/255, blue: 162/255, alpha: 1)
        @unknown default:
            UIColor(red: 47/255, green: 68/255, blue: 162/255, alpha: 1)
        }
    }
    static let buttonBackground = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            UIColor(red: 225/255, green: 124/255, blue: 16/255, alpha: 1)
        case .dark:
            UIColor(red: 225/255, green: 124/255, blue: 16/255, alpha: 1)
        @unknown default:
            UIColor(red: 225/255, green: 124/255, blue: 16/255, alpha: 1)
        }
    }
    static let cellBackground = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
//            UIColor(red: 110/255, green: 118/255, blue: 172/255, alpha: 1)
            UIColor(red: 142/255, green: 195/255, blue: 255/255, alpha: 1)
        case .dark:
            UIColor(red: 110/255, green: 118/255, blue: 172/255, alpha: 1)
        @unknown default:
            UIColor(red: 110/255, green: 118/255, blue: 172/255, alpha: 1)
        }
    }
    static let cellInfectedBackground = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            UIColor(red: 145/255, green: 129/255, blue: 255/255, alpha: 1)
        case .dark:
            UIColor(red: 145/255, green: 129/255, blue: 255/255, alpha: 1)
        @unknown default:
            UIColor(red: 145/255, green: 129/255, blue: 255/255, alpha: 1)
        }
    }
}

// MARK: - UITextField

extension UITextField {
    class func modelingParamenter(placeholder: String) -> UITextField {
        lazy var groupSizeTextField: UITextField = {
            let tf = UITextField()
            tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            tf.leftView = paddingView
            tf.leftViewMode = .always
            tf.layer.borderWidth = 0.7
            tf.layer.borderColor = UIColor.logoBackground.cgColor
            tf.layer.cornerRadius = 8
            tf.keyboardType = .numberPad
            return tf
        }()
        return groupSizeTextField
    }
}
