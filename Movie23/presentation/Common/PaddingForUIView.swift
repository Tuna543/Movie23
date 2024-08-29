//
//  PaddingForUIView.swift
//  Movie23
//
//  Created by BS00880 on 3/7/24.
//

import Foundation
import UIKit


func createPaddedContainer(for view: UIView, padding: UIEdgeInsets, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor? = nil, backgroundColor: UIColor? = nil, darkModeOn: Bool? = nil) -> UIView {
    
    let containerView = UIView()
    if let backgroundColorSet = backgroundColor {
        containerView.backgroundColor = backgroundColorSet
    }
    containerView.translatesAutoresizingMaskIntoConstraints = false

    containerView.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
        view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding.top),
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding.bottom),
        view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding.left),
        view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding.right)
    ])
    
    containerView.layer.cornerRadius = cornerRadius
    containerView.layer.borderWidth = borderWidth
    containerView.layer.borderColor = getPrimaryColor().cgColor
    if let borderColor = borderColor {
        containerView.layer.borderColor = borderColor.cgColor
    } else {
        containerView.layer.borderColor = UIColor.systemGray2.cgColor
    }
    containerView.layer.masksToBounds = true

    return containerView
}

