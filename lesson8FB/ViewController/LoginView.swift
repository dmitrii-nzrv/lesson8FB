//
//  LogViewController.swift
//  lesson8FB
//
//  Created by Dmitrii Nazarov on 16.10.2024.
//

import UIKit

class LoginView: UIViewController{
    
    private var viewBuilder = ViewBuilder()
    private var fbManager = FBManager()
    
    lazy var titleLable = viewBuilder.createLabel(frame: CGRect(x: 30, y: 100, width: view.frame.width - 60, height: 40),
                                                  text: "Авторизация",
                                                  size: 22)
    
    lazy var emailTextField = viewBuilder.createTextField(frame: CGRect(x: 30, y: titleLable.frame.maxY + 60, width: view.frame.width - 60, height: 50),
                                                          placeholder: "Email")
    
    lazy var passwordTextField = viewBuilder.createTextField(frame: CGRect(x: 30, y: emailTextField.frame.maxY + 20, width: view.frame.width - 60, height: 50), placeholder: "Password", isPassword: true)
    
    
    lazy var regAction: UIAction = UIAction{ _ in
        NotificationCenter.default.post(name: Notification.Name(rawValue: "routeVC"), object: nil, userInfo: ["vc": WindowCase.reg])
    }
    
    lazy var loginAction: UIAction = UIAction{ [weak self]_ in
        guard let self = self else { return }
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let userData = UserData(email: email, password: password, name: nil)
        fbManager.authUser(user: userData) { isLogin in
            if isLogin{
                NotificationCenter.default.post(name: Notification.Name(rawValue: "routeVC"), object: nil, userInfo: ["vc": WindowCase.home])
            } else {
                print("error")
            }
        }

    }
    
    
    lazy var regBtn = viewBuilder.ctreateButton(frame: CGRect(x: 30, y: view.frame.height - 150, width: view.frame.width - 60, height: 50), action: loginAction, title: "Войти", isMainBtn: true)
    
    lazy var logBtn = viewBuilder.ctreateButton(frame: CGRect(x: 30, y: regBtn.frame.maxY + 10, width: view.frame.width - 60, height: 50), action: regAction, title: "Регистрация")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(titleLable)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(regBtn)
        view.addSubview(logBtn)
    }
    
}
