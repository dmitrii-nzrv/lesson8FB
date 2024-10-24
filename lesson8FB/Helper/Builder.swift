//
//  Helper.swift
//  lesson8FB
//
//  Created by Dmitrii Nazarov on 16.10.2024.
//


import UIKit

class ViewBuilder{
    
    func createLabel(frame: CGRect, text: String, size: CGFloat = 16) -> UILabel{
        {
            $0.frame = frame
            $0.text = text
            $0.textColor = .black
            $0.font = .systemFont(ofSize: size, weight: .bold)
            return $0
        }(UILabel())
    }
    
    func createTextField(frame: CGRect, placeholder: String, isPassword: Bool = false) -> UITextField{
        {
            $0.frame = frame
            $0.backgroundColor = .gray
            $0.placeholder = placeholder
            $0.leftViewMode = .always
            $0.isSecureTextEntry = isPassword
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            $0.layer.cornerRadius = 10
            return $0
        }(UITextField())
    }
    
    func ctreateButton(frame: CGRect, action: UIAction, title: String, isMainBtn: Bool = false) -> UIButton{
        {
            $0.frame = frame
            $0.setTitle(title, for: .normal)
            $0.backgroundColor = isMainBtn ? .black : .clear
            $0.setTitleColor(isMainBtn ? .white : .black, for: .normal)
            $0.layer.cornerRadius = 10
            return $0
        }(UIButton(primaryAction: action))
    }
    
}
