//
//  UILabelExtension.swift
//  Trading
//
//  Created by Vlad Che on 2/24/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit

extension UILabel {
    /// - Parameters:
    ///   - text: The current styled text that is displayed by the label.
    ///   - font: The font used to display the text.
    ///   - color: The color of the text.
    ///   - align: The technique to use for aligning the text.
    ///   - lines: The maximum number of lines to use for rendering text.
    ///            The default value for this property is 1.
    ///            To remove any maximum limit, and use as many lines as needed,
    ///            set the value of this property to 0.
    ///   - space: The distance in points between the bottom of one line fragment and the top of the next.
    ///            This value is always nonnegative.
    ///   - kern:  This value specifies the number of points by which to adjust kern-pair characters.
    ///            Kerning prevents unwanted space from occurring between specific characters and depends on the font.
    ///            The value 0 means kerning is disabled. The default value for this attribute is 0.
    convenience init(text: String? = nil,
                     font: UIFont? = nil, color: UIColor? = nil,
                     align: NSTextAlignment? = nil, lines: Int? = nil,
                     space: CGFloat? = nil, kern: CGFloat? = nil) {
        self.init()
        params.set(text: text, font: font, color: color, align: align, lines: lines, space: space, kern: kern)
    }
    
    /// Returns label
    ///
    /// - Parameters:
    ///   - text:       The current styled text that is displayed by the label.
    ///   - attributes: Attibutes to style the text
    /// - Example:
    ///   ```
    ///     let label = UILabel("Text", attributes: .systemFont(ofSize: 14) + .white + .center + 3.lines)
    ///     let label = UILabel("Text", attributes: otherLabel.attributed.params + 1.5.space + 2.kern)
    ///   ```
    convenience init(_ text: String, attributes: AttributedParameters) {
        self.init()
        var attributes = attributes
        attributes.text = text
        attributes.font = UIFont.systemFont(ofSize: 14)
        update(with: attributes)
    }
    
    convenience init(attributes: AttributedParameters) {
        self.init()
        update(with: attributes)
    }
    
    var attributed: AttributedParameters {
        get { return params }
        set { update(with: newValue) }
    }
    
    /// Set text and attributed parameters to UILabel
    /// - Tag: UILabel.set
    /// - Parameters:
    ///   - text: The current styled text that is displayed by the label.
    ///   - font: The font used to display the text.
    ///   - color: The color of the text.
    ///   - align: The technique to use for aligning the text.
    ///   - lines: The maximum number of lines to use for rendering text.
    ///            The default value for this property is 1.
    ///            To remove any maximum limit, and use as many lines as needed,
    ///            set the value of this property to 0.
    ///   - space: The distance in points between the bottom of one line fragment and the top of the next.
    ///            This value is always nonnegative.
    ///   - kern:  This value specifies the number of points by which to adjust kern-pair characters.
    ///            Kerning prevents unwanted space from occurring between specific characters and depends on the font.
    ///            The value 0 means kerning is disabled. The default value for this attribute is 0.
    func set(text: String? = nil,
             font: UIFont? = nil, color: UIColor? = nil,
             align: NSTextAlignment? = nil, lines: Int? = nil,
             space: CGFloat? = nil, kern: CGFloat? = nil) {
        params.set(text: text, font: font, color: color, align: align, lines: lines, space: space, kern: kern)
    }
    
    func update(with params: AttributedParameters) {
        var params = params
        unowned let `self` = self
        params.update = self.update
        self.params = params
        
        let def = AttributedParameters.default
        let text = params.text ?? def.text ?? ""
        let font = params.font ?? def.font ?? UIFont.systemFont(ofSize: 14)
        let color = params.color ?? def.color ?? UIColor.black
        let align = params.align ?? def.align ?? NSTextAlignment.left
        let lines = params.lines ?? def.lines ?? 1
        let space = params.space ?? def.space ?? 0
        let kern = params.kern ?? def.kern ?? 0
        
        adjustsFontSizeToFitWidth = true
        textAlignment = align
        numberOfLines = lines
        textColor = color
        let paragraph = NSParagraphStyle.with {
            $0.lineSpacing = space
            $0.alignment = align
            $0.lineBreakMode = NSLineBreakMode.byTruncatingTail
        }
        let attributes: [NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraph,
            .kern: kern
        ]
        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}

extension UILabel {
    
    /// AttributedParameters for quick UILabel setup. It preserve all attributes set previously.
    fileprivate var params: AttributedParameters {
        get { return getOrCreateParams() }
        set { setAssociatedObject(newValue, for: self, key: &paramsKey) }
    }
    
    private func getOrCreateParams() -> AttributedParameters {
        if let params = getAssociatedObject(for: self, key: &paramsKey) as? AttributedParameters {
            return params
        } else {
            unowned let `self` = self
            let params = AttributedParameters(update: self.update, text: self.text,
                                                  font: font, color: textColor,
                                                  align: textAlignment, lines: numberOfLines)
            setAssociatedObject(params, for: self, key: &paramsKey)
            return params
        }
    }
    
}

extension Array where Element == UILabel {
    /// AttributedParameters for quick UILabel setup. It preserve all attributes set previously.
    var params: [AttributedParameters] {
        return map(\.params)
    }
}

fileprivate var paramsKey: Void?
