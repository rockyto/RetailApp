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
    
    func instantiateViewController(identifier: String, animated: Bool, by vc: UIViewController, completion: (() -> Void)?){
        
        let nuevoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        
        nuevoViewController.modalPresentationStyle = .custom
        vc.present(nuevoViewController, animated: animated, completion: completion)
    }
    
    func convierteStringEnFechaString(laFecha: String) -> String{
        let fecha = laFecha
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fechaString = dateFormatter.date(from: fecha)
        
        let formatterShow = DateFormatter()
        formatterShow.dateFormat = "EEEE dd MMMM yyyy"
        let fechaFinal = formatterShow.string(from: fechaString!)
        let fechaCita = fechaFinal
        return fechaCita
    }
    
}


