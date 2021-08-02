//
//  UILabel+LineSpacing.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/08/02.
//

import Foundation
import UIKit

extension UILabel {

    func addLineSpacing(spacingValue: CGFloat = 2) {
        guard let textString = text else { return }

        let attributedString = NSMutableAttributedString(string: textString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacingValue

        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))

        attributedText = attributedString
    }

}
