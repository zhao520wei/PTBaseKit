//
//  ViewFactory.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 01/01/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit


public struct ViewFactory {
    public static func createTextField(font: UIFont = 17.customFont, tintColor: UIColor = UIColor.tk.main, keyboardType: UIKeyboardType = .default, isSecureTextEntry: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = UIColor.white
        textField.font = font
        textField.tintColor = tintColor
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecureTextEntry
        return textField
    }
    
    public static func createLabel(font: UIFont = 15.customFont, color: UIColor = UIColor.tk.black) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        return label
    }
    
    public static func createEmptyButton(tintColor: UIColor = UIColor.tk.gray) -> UIButton {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn += tintColor.textColorCss
        btn += 1.borderCss
        btn += tintColor.borderCss
        btn += 5.cornerRadiusCss
        return btn
    }
    
    public static func createGradientButton(cornerRadius: Int? = nil) -> UIButton {
        let button = UIButton(type: UIButton.ButtonType.system)
        button += buttonCss
        if let _cornerRadius = cornerRadius {
            button += _cornerRadius.cornerRadiusCss
        }
        return button
    }
    
    public static func createRoundButton(tintColor: UIColor = UIColor.tk.white, radius: CGFloat = 5) -> UIButton {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn += radius.cornerRadiusCss
        btn += buttonImgCss
        btn += tintColor.textColorCss
        return btn
    }
    
    public static func createBarButton(with normalImage: UIImage, hightlightedImage: UIImage? = nil) -> UIButton {
        var button: UIButton!
        if #available(iOS 11, *) {
            button = UIButton(type: UIButton.ButtonType.custom)
        }else {
            button = UIButton(frame: CGRect(x: 0, y: 0, width: normalImage.size.width, height: normalImage.size.height))
        }
        button.setImage(normalImage, for: UIControl.State.normal)
        button.setImage(hightlightedImage, for: UIControl.State.highlighted)
        return button
    }
    
    public static func createBarButton(title: NSAttributedString?, disabledTitle: NSAttributedString? = nil) -> UIButton {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        if #available(iOS 11, *) {
            
            
        }else {
            if let size = title?.size() {
                button.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: size.height)
            }
        }
        button.setAttributedTitle(title, for: UIControl.State.normal)
        if let _disabledTitle = disabledTitle {
            button.setAttributedTitle(_disabledTitle, for: UIControl.State.disabled)
        }
        return button
    }
    
    public static func createBarButtonItem(_ image: UIImage?) -> UIBarButtonItem {
        return UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    
    public static func createBarButtonItem(_ title: String?) -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
}
