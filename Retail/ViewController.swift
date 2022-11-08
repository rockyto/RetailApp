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
    
  


}

