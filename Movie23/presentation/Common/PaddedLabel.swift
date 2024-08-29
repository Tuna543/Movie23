//
//  PaddedLabel.swift
//  Movie23
//
//  Created by BS00880 on 27/6/24.
//

import UIKit

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { setNeedsDisplay() }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }

}
