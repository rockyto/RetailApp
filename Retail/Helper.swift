//
//  Helper.swift
//  Retail
//
//  Created by Rodrigo Sánchez on 08/11/22.
//

import Foundation
import UIKit

class Helper{
    
    let host: String = "http://retail.test/api/"
    
    func BodyLogin(usr: String, psswd: String) -> String{
        
        var body: String = ""
        
        struct UserLogin: Codable{
            
            var email: String
            var password: String
            
        }
        
        let user = UserLogin(email: usr, password: psswd)
        
        let jsonEncoder = JSONEncoder()
        
        jsonEncoder.outputFormatting = .prettyPrinted
        
        do{
            
            let encodeLogin = try jsonEncoder.encode(user)
            let encodeStringUser = String(data: encodeLogin, encoding: .utf8)!
            body = encodeStringUser
            
        }catch{
            
            print(error.localizedDescription)
            
        }
        
        return body
        
    }
    
    func showAlert(title: String, message: String, in vc: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
        
    }
    
}


