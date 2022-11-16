//
//  DetalleViewController.swift
//  Retail
//
//  Created by Rodrigo Sánchez on 10/11/22.
//

import UIKit

class DetalleViewController: UIViewController {
    
    @IBOutlet weak var lblSucursalNombre: UILabel!
    @IBOutlet weak var lblFechaSelec: UILabel!
    @IBOutlet weak var lblVentaTotal: UILabel!
    
    @IBOutlet weak var lblNFolios: UILabel!
    @IBOutlet weak var lblTckProm: UILabel!
    
    
    @IBOutlet weak var VentaTotalView: UIView!
    @IBOutlet weak var NoFoliosView: UIView!
    @IBOutlet weak var TicketPromView: UIView!
    
    var Fecha = ""
    var Sucursal = ""
    var Suc = ""
    var VentaTotal = ""
    var NoFolios = ""
    var Piezas = ""
    var PzaxTicket = ""
    var TicketPromedio = ""
    
    let helper = Helper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblSucursalNombre.text = Sucursal
        self.lblFechaSelec.text = Fecha
        self.lblVentaTotal.text = VentaTotal
        self.lblNFolios.text = NoFolios
        self.lblTckProm.text = TicketPromedio

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        conf_subviews()
    }
    
    func conf_subviews(){
        
        VentaTotalView.layer.cornerRadius = 5
        VentaTotalView.layer.masksToBounds = true
        
        NoFoliosView.layer.cornerRadius = 5
        NoFoliosView.layer.masksToBounds = true
        
        TicketPromView.layer.cornerRadius = 5
        TicketPromView.layer.masksToBounds = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
