//
//  UITextField+Extension.swift
//  SuperSales
//
//  Created by Apple on 03/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@IBDesignable
public class KTextField: UITextField, UITextFieldDelegate {

    // MARK: - IBInspectable properties

    /// Applies underline to the text view with the specified width
    @IBInspectable public var underLineWidth: CGFloat = 0.0 {
        didSet {
            updateUnderLineFrame()
        }
    }

    /// Sets the underline color
    @IBInspectable public var underLineColor: UIColor = .groupTableViewBackground {
        didSet {
            updateUnderLineUI()
        }
    }

    /// Sets the placeholder color
    @IBInspectable public var placeholderColor: UIColor = .lightGray {
        didSet {
            let placeholderStr = placeholder ?? ""
            attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }

    public override var placeholder: String? {
        didSet {
            let placeholderStr = placeholder ?? ""
            attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }

    /// Sets left margin
    @IBInspectable public var leftMargin: CGFloat = 10.0 {
        didSet {
            setMargins()
        }
    }

    /// Sets right margin
    @IBInspectable public var rightMargin: CGFloat = 10.0 {
        didSet {
            setMargins()
        }
    }

    // MARK: - init methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        applyStyles()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyles()
    }

    // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateUnderLineFrame()
        updateAccessoryViewFrame()
    }

    // MARK: - Styles
    private func applyStyles() {
        self.delegate = self
        applyUnderLine()
        setMargins()
    }

    // MARK: - Underline
    private var underLineLayer = CALayer()
    private func applyUnderLine() {
        // Apply underline only if the text view's has no borders
        if borderStyle == UITextField.BorderStyle.none {
            underLineLayer.removeFromSuperlayer()
            updateUnderLineFrame()
            updateUnderLineUI()
            layer.addSublayer(underLineLayer)
            layer.masksToBounds = true
        }
    }

    private func updateUnderLineFrame() {
        var rect = bounds
        rect.origin.y = bounds.height - underLineWidth
        rect.size.height = underLineWidth
        underLineLayer.frame = rect
    }

    private func updateUnderLineUI() {
        underLineLayer.backgroundColor = underLineColor.cgColor
    }

    // MARK: - Margins
    private var leftAcessoryView = UIView()
    private var rightAcessoryView = UIView()
    private func setMargins() {
        // Left Margin
        leftView = nil
        leftViewMode = .never
        if leftMargin > 0 {
            if nil == leftView {
                leftAcessoryView.backgroundColor = .clear
                leftView = leftAcessoryView
                leftViewMode = .always
            }
        }
        updateAccessoryViewFrame()

        // Right Margin
        rightView = nil
        rightViewMode = .never
        if rightMargin > 0 {
            if nil == rightView {
                rightAcessoryView.backgroundColor = .clear
                rightView = rightAcessoryView
                rightViewMode = .always
            }
            updateAccessoryViewFrame()
        }
    }

    private func updateAccessoryViewFrame() {
        // Left View Frame
        var leftRect = bounds
        leftRect.size.width = leftMargin
        leftAcessoryView.frame = leftRect
        // Right View Frame
        var rightRect = bounds
        rightRect.size.width = rightMargin
        rightAcessoryView.frame = rightRect
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        underLineLayer.backgroundColor = UIColor.Appskybluecolor.cgColor
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        underLineLayer.backgroundColor = underLineColor.cgColor
    }
}

@IBDesignable
public class KTextView: IQTextView, UITextViewDelegate {

    // MARK: - IBInspectable properties

    /// Applies underline to the text view with the specified width
    @IBInspectable public var underLineWidth: CGFloat = 0.0 {
        didSet {
            updateUnderLineFrame()
        }
    }

    /// Sets the underline color
    @IBInspectable public var underLineColor: UIColor = .groupTableViewBackground {
        didSet {
            updateUnderLineUI()
        }
    }

    // MARK: - init methods
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: .none)
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        applyStyles()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyles()
    }

    // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateUnderLineFrame()
    }

    // MARK: - Styles
    private func applyStyles() {
        self.delegate = self
        applyUnderLine()
    }

    // MARK: - Underline
    private var underLineLayer = CALayer()
    private func applyUnderLine() {
        // Apply underline only if the text view's has no borders
        underLineLayer.removeFromSuperlayer()
        updateUnderLineFrame()
        updateUnderLineUI()
        layer.addSublayer(underLineLayer)
        layer.masksToBounds = true
    }

    private func updateUnderLineFrame() {
        var rect = bounds
        rect.origin.y = bounds.height - underLineWidth
        rect.size.height = underLineWidth
        underLineLayer.frame = rect
    }

    private func updateUnderLineUI() {
        underLineLayer.backgroundColor = underLineColor.cgColor
    }

    public override func textViewDidBeginEditing(_ textView: UITextView) {
        underLineLayer.backgroundColor = UIColor.Appskybluecolor.cgColor
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        underLineLayer.backgroundColor = underLineColor.cgColor
    }
        
}
