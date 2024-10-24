//
//  ViewController.swift
//  lesson8FB
//
//  Created by Dmitrii Nazarov on 15.10.2024.
//

import UIKit

class RegView: UIViewController{
    
    private var viewBuilder = ViewBuilder()
    private var fbManager = FBManager()
    
    lazy var titleLable = viewBuilder.createLabel(frame: CGRect(x: 30, y: 100, width: view.frame.width - 60, height: 40),
                                                  text: "Регистрация",
                                                  size: 22)
    
    lazy var emailTextField = viewBuilder.createTextField(frame: CGRect(x: 30, y: titleLable.frame.maxY + 60, width: view.frame.width - 60, height: 50),
                                                          placeholder: "Email")
    
    lazy var passwordTextField = viewBuilder.createTextField(frame: CGRect(x: 30, y: emailTextField.frame.maxY + 20, width: view.frame.width - 60, height: 50), placeholder: "Password", isPassword: true)
    
    lazy var nameTextField = viewBuilder.createTextField(frame: CGRect(x: 30, y: passwordTextField.frame.maxY + 20, width: view.frame.width - 60, height: 50), placeholder: "Name")
    
    lazy var regAction: UIAction = UIAction{ [weak self] _ in
        guard let self = self else { return }
        
        let email = emailTextField.text
        let paswd = passwordTextField.text
        let name = nameTextField.text
        
        let user = UserData(email: email ?? "", password: paswd ?? "", name: name)
        
        fbManager.regUser(user: user) { isLogin in
            if isLogin{
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "routeVC"), object: nil, userInfo: ["vc": WindowCase.home])
            } else {
                print("error")
            }
        }
    }
    
    lazy var loginAction: UIAction = UIAction{ _ in
        NotificationCenter.default.post(name: Notification.Name(rawValue: "routeVC"), object: nil, userInfo: ["vc": WindowCase.login])
    }
    
    lazy var regBtn = viewBuilder.ctreateButton(frame: CGRect(x: 30, y: view.frame.height - 150, width: view.frame.width - 60, height: 50), action: regAction, title: "Регистрация", isMainBtn: true)
    
    lazy var logBtn = viewBuilder.ctreateButton(frame: CGRect(x: 30, y: regBtn.frame.maxY + 10, width: view.frame.width - 60, height: 50), action: loginAction, title: "Есть акк")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(titleLable)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nameTextField)
        view.addSubview(regBtn)
        view.addSubview(logBtn)
    }
    
}
