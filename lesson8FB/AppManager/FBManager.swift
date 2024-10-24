//
//  Service.swift
//  lesson8FB
//
//  Created by Dmitrii Nazarov on 16.10.2024.
//

import Foundation
import Firebase
import FirebaseAuth

class FBManager {
    
    func regUser(user: UserData, completion: @escaping (Bool) -> Void){
        
        Auth.auth().createUser(withEmail: user.email, password: user.password) { [weak self] result, err in
            guard let self = self else { return }
            guard err == nil else {
                print(err!)
                completion(false)
                return
            }
            
            let uid = result?.user.uid
            setUserData(name: user.name, uid: uid!)
            completion(true)
        }
        
    }
    
    private func setUserData(name: String?, uid: String){
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .setData(["name": name ?? ""])
    }
    
    func authUser(user: UserData, completion: @escaping (Bool) -> Void){
        Auth.auth().signIn(withEmail: user.email, password: user.password) { response, err in
            guard err == nil else {
                print(err!)
                completion(false)
                return
            }
            
            guard let _ = response?.user.uid else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func signOut(){
        do
        {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func isLogin() -> Bool{
        if let _ = Auth.auth().currentUser {
            return true
        } else {
            return false
        }
    }
    
}
