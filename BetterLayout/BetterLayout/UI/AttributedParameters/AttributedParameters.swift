//
//  AttributedParameters.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

struct AttributedParameters {
    var update: (AttributedParameters) -> Void
    var text: String?               { didSet { update(self) }}
    var font: UIFont?               { didSet { update(self) }}
    var color: UIColor?             { didSet { update(self) }}
    var align: NSTextAlignment?     { didSet { update(self) }}
    var lines: Int?                 { didSet { update(self) }}
    var space: CGFloat?             { didSet { update(self) }}
    var kern: CGFloat?              { didSet { update(self) }}
    
    /// Attributed params for UILabel
    var params: AttributedParameters {
        get { return self }
        set { update(newValue) }
    }
    
    /// Returns AttributedParameters
    ///
    /// - Parameters:
    ///   - update: Closure that will be called for every property update.
    ///   - text:   The current styled text that is displayed by the label.
    ///   - font:   The font used to display the text.
    ///   - color:  The color of the text.
    ///   - align:  The technique to use for aligning the text.
    ///   - lines:  The maximum number of lines to use for rendering text.
    ///             The default value for this property is 1.
    ///             To remove any maximum limit, and use as many lines as needed,
    ///             set the value of this property to 0.
    ///   - space:  The distance in points between the bottom of one line fragment and the top of the next.
    ///             This value is always nonnegative.
    ///   - kern:   This value specifies the number of points by which to adjust kern-pair characters.
    ///             Kerning prevents unwanted space from occurring between specific characters and depends on the font.
    ///             The value 0 means kerning is disabled. The default value for this attribute is 0.
    init(update: @escaping (AttributedParameters) -> Void = { _ in }, text: String? = nil,
         font: UIFont? = nil, color: UIColor? = nil,
         align: NSTextAlignment? = nil, lines: Int? = nil,
         space: CGFloat? = nil, kern: CGFloat? = nil) {
        self.update = update
        self.text = text
        self.font = font
        self.color = color
        self.align = align
        self.lines = lines
        self.space = space
        self.kern = kern
    }
    
    /// Sets text and attributed parameters and calls update
    ///
    /// - Parameters:
    ///   - text:   The current styled text that is displayed by the label.
    ///   - font:   The font used to display the text.
    ///   - color:  The color of the text.
    ///   - align:  The technique to use for aligning the text.
    ///   - lines:  The maximum number of lines to use for rendering text.
    ///             The default value for this property is 1.
    ///             To remove any maximum limit, and use as many lines as needed,
    ///             set the value of this property to 0.
    ///   - space:  The distance in points between the bottom of one line fragment and the top of the next.
    ///             This value is always nonnegative.
    ///   - kern:   This value specifies the number of points by which to adjust kern-pair characters.
    ///             Kerning prevents unwanted space from occurring between specific characters and depends on the font.
    ///             The value 0 means kerning is disabled. The default value for this attribute is 0.
    mutating func set(text: String? = nil,
                      font: UIFont? = nil, color: UIColor? = nil,
                      align: NSTextAlignment? = nil, lines: Int? = nil,
                      space: CGFloat? = nil, kern: CGFloat? = nil) {
        if let text = text      { self.text = text }
        if let font = font      { self.font = font }
        if let color = color    { self.color = color }
        if let align = align    { self.align = align }
        if let lines = lines    { self.lines = lines }
        if let space = space    { self.space = space }
        if let kern = kern      { self.kern = kern }
        update(self)
    }
    
    static var `default` = AttributedParameters(
        text: "", font: .systemFont(ofSize: 14), color: .black, align: .left, lines: 1, space: 0, kern: 0
    )
    
    var `default`: AttributedParameters { return AttributedParameters.default }
}
