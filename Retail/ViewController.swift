//
//  ViewController.swift
//  Retail
//
//  Created by Rodrigo Sánchez on 08/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var txtUserLogin: UITextField!
    @IBOutlet weak var txtPsswdLogin: UITextField!
    
    @IBOutlet weak var textFieldsView: UIView!
    @IBOutlet weak var SubViewLogin: UIView!
    
    let helper = Helper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        confBtns()
        conf_textFieldsView()
        configure_loginSubView()
    }
    
    func configure_loginSubView(){
        
        SubViewLogin.layer.cornerRadius = 5
        SubViewLogin.layer.masksToBounds = true
        
    }
    
    func confBtns(){
        
        btnLogin.layer.cornerRadius = 5
        SubViewLogin.layer.masksToBounds = true
        
    }
    
    func conf_textFieldsView(){
        
        let width = CGFloat(2)
        let color = UIColor.groupTableViewBackground.cgColor

        let border = CALayer()
        border.borderWidth = width
        border.borderColor = color
        border.frame = CGRect(x: 0, y: 0, width: textFieldsView.frame.width, height: textFieldsView.frame.height)

        let line = CALayer()
        line.borderWidth = width
        line.borderColor = color
        line.frame = CGRect(x: 0, y: textFieldsView.frame.height / 2 - width, width: textFieldsView.frame.width, height: width)

        textFieldsView.layer.addSublayer(border)
        textFieldsView.layer.addSublayer(line)

        textFieldsView.layer.cornerRadius = 5
        textFieldsView.layer.masksToBounds = true
        
        
        textFieldsView.layer.shadowColor = UIColor.black.cgColor
        textFieldsView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        textFieldsView.layer.shadowOpacity = 0.2
        textFieldsView.layer.shadowRadius = 8.0
        
    }
    
    func LoginRetail(){
        
        let url = URL(string: helper.host+"login")!
        
        let body = helper.BodyLogin(usr: txtUserLogin.text!, psswd: txtPsswdLogin.text!)
        print(body)
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async { [self] in
                
                if error != nil{
                    
                    helper.showAlert(title: "Error de servidor", message: error!.localizedDescription, in: self)
                    return
                    
                }
                do{
                    guard let data = data else {

                        helper.showAlert(title: "Error de datos", message: error!.localizedDescription, in: self)
                        return

                    }
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    
                    guard let parsedJSON = json else{
                        
                        print("Error de parseo")
                        return
                        
                    }
                   
                    switch parsedJSON["status"] as! String {
                        
                    case "202" :
                        
                        UserDefaults.standard.set(parsedJSON["accessToken"], forKey: "token")
                        UserDefaults.standard.synchronize()
                        
                        helper.instantiateViewController(identifier: "vistaInicio", animated: true, by: self, completion: nil)
                        break
                        
                        
                        
                    default:
                        
                        helper.showAlert(title: "Error", message: parsedJSON["message"] as! String, in: self)
                        
                    }
                    
                    print(json!)
                    
                }catch{
                    
                    helper.showAlert(title: "Error", message: error.localizedDescription, in: self)
                    
                }
            }
        }.resume()
       
    }
    
    @IBAction func LoginRetail(sender: AnyObject){
        
        LoginRetail()
        
    }
    
  


}

