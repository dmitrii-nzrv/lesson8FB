//
//  SceneDelegate.swift
//  lesson8FB
//
//  Created by Dmitrii Nazarov on 15.10.2024.
//
import UIKit


enum WindowCase{
    case login, reg, home
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private let fbManager = FBManager()
    
    var window: UIWindow?
    private let userDefault: UserDefaults = .standard

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        //1 create notification
        NotificationCenter.default.addObserver(self, selector: #selector(routeVC(notification: )), name: Notification.Name(rawValue: "routeVC"), object: nil)
        
        
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        
        if fbManager.isLogin(){
            self.window?.rootViewController = windowManager(vc: .home)
        } else {
            self.window?.rootViewController = windowManager(vc: .reg)
        }
    
        self.window?.makeKeyAndVisible()
    }

    private func windowManager(vc: WindowCase) -> UIViewController{
        switch vc {
        case .login:
            return LoginView()
        case .reg:
            return RegView()
        case .home:
            return UINavigationController(rootViewController: AppController())
      
        }
    }
    
    //2 not func
    @objc func routeVC(notification: Notification){
        guard let userInfo = notification.userInfo, let vc = userInfo["vc"] as? WindowCase else { return }
        self.window?.rootViewController = windowManager(vc: vc)
    }
    
   
}

