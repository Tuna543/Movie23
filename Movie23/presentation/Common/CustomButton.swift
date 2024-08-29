//
//  CustomButton.swift
//  Movie23
//
//  Created by BS00880 on 24/6/24.
//

import UIKit

class CustomButton: UIButton {
    enum FontSize {
        case big
        case medium
        case small
    }
    
    init(title: String, hasBackground: Bool = false, fontSize: FontSize, titleColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        self.backgroundColor = backgroundColor ?? (hasBackground ? .systemPurple : .clear)
        
        // Use provided title color if any, otherwise use default
        let finalTitleColor: UIColor = titleColor ?? (hasBackground ? .white : .systemPurple)
        self.setTitleColor(finalTitleColor, for: .normal)
        
        switch fontSize {
        case .big:
            self.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
            
        case .medium:
            self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            
        case .small:
            self.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
