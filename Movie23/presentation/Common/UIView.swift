//
//  UIView.swift
//  Movie23
//
//  Created by BS00880 on 26/6/24.
//

import Foundation
import UIKit

extension UIView {
    
    func pin(to superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
    
    func pinButtonToBottomTrailing(to superview: UIView) {
//        DispatchQueue.main.async {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -5).isActive = true
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -10).isActive = true
            self.heightAnchor.constraint(equalToConstant: 30).isActive = true
            self.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.4).isActive = true
//        }
        
    }
    
    func pinButtonToBottomOfSomethingTrailing(to superview: UIView, to levelWithYAxis: UIView? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -0.05).isActive = true
        centerYAnchor.constraint(equalTo: levelWithYAxis?.centerYAnchor ?? superview.centerYAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: 30).isActive = true
        widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.25).isActive = true
    }
    
    func pinToTheRightAndBottomOfSomething(height: Float, to superview: UIView, to rightOf: UIView? = nil, to bottomOf: UIView? = nil, topPlace: Bool? = nil){
        
//        DispatchQueue.main.async {
            self.translatesAutoresizingMaskIntoConstraints = false
            if let topPlace = topPlace {
                if topPlace {
                    self.topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor).isActive = true
                }
            } else {
                self.topAnchor.constraint(equalTo: bottomOf?.bottomAnchor ?? superview.topAnchor, constant: 10).isActive = true
            }
            self.leadingAnchor.constraint(equalTo: rightOf?.trailingAnchor ?? superview.leadingAnchor, constant: 10).isActive = true
    //        heightAnchor.constraint(equalToConstant: 25).isActive = true
            self.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: CGFloat(height)).isActive = true
//        }
        
    }
    
    func pinToRightAndBottomOfSomething(height: Float? = nil, to superview: UIView, to rightOf: UIView? = nil, to bottomOf: UIView? = nil, topPlace: Bool? = nil){
        
        translatesAutoresizingMaskIntoConstraints = false
        if let topPlace = topPlace {
            if topPlace {
                topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor).isActive = true
            }
        } else {
            topAnchor.constraint(equalTo: bottomOf?.bottomAnchor ?? superview.topAnchor, constant: 10).isActive = true
        }
        leadingAnchor.constraint(equalTo: rightOf?.trailingAnchor ?? superview.leadingAnchor, constant: 10).isActive = true
        if let height = height {
            heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        }
    }
    
    func pinToBottomOfSomethingCenter(height: Float? = nil, to superview: UIView, to bottomOf: UIView? = nil, width: Float? = nil, topPlace: Bool? = nil){
        translatesAutoresizingMaskIntoConstraints = false
        if let topPlace = topPlace {
            if topPlace {
                topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor).isActive = true
            }
        } else {
            topAnchor.constraint(equalTo: bottomOf?.bottomAnchor ?? superview.topAnchor, constant: 10).isActive = true
        }
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
//        heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: CGFloat(height)).isActive = true
        if let height = height {
            heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: CGFloat(width)).isActive = true
        } else {
            widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.8).isActive = true
        }
    }
    
//    func pinToTheRightAndBottomOfSomethingForHeader(to superview: UIView, to leftview: UIView? = nil, to upview: UIView? = nil, topPlace: Bool? = nil){
//        translatesAutoresizingMaskIntoConstraints = false
//        if let topPlace = topPlace {
//            if topPlace {
//                topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor).isActive = true
//            }
//        } else {
//            topAnchor.constraint(equalTo: upview?.bottomAnchor ?? superview.topAnchor, constant: 5).isActive = true
//        }
//        leadingAnchor.constraint(equalTo: leftview?.trailingAnchor ?? superview.leadingAnchor, constant: 10).isActive = true
//        heightAnchor.constraint(equalToConstant: 50).isActive = true
//    }
    
    func setupRoundedCorners(for label: PaddedLabel) {
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor(named: "primaryColor")?.cgColor
        label.layer.borderWidth = 1.0
        label.textInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
}
