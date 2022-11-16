//
//  InicioViewController.swift
//  Retail
//
//  Created by Rodrigo Sánchez on 09/11/22.
//

import UIKit

class InicioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ConsultaModeloProtocol {
    
    var feedItems = [DetallesConsulta]()
    
    var selectDato : DetallesConsulta = DetallesConsulta()
    
    @IBOutlet var ConsutaListas: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.ConsutaListas.reloadData()
        self.ConsutaListas.delegate = self
        self.ConsutaListas.dataSource = self
        
        let consultaModelo = ConsultaModelo()
        consultaModelo.ElDelegado = self
        consultaModelo.downloadConsulta()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.ConsutaListas.reloadData()
        self.ConsutaListas.delegate = self
        self.ConsutaListas.dataSource = self
        
        let consultaModelo = ConsultaModelo()
        consultaModelo.ElDelegado = self
        consultaModelo.downloadConsulta()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaDetalles", for: indexPath) as! ConsultaTableViewCell
        let item : DetallesConsulta = feedItems[indexPath.row]
        
        cell.lblVenta!.text = item.VentaTotal
        cell.lblSucursal!.text = item.Sucursal
        cell.lblTicketProm!.text = item.TicketPromedio
        return cell
        
    }
    
    func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath){
        
        let detalle: DetalleViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetalleViewController") as! DetalleViewController
        
        let item:DetallesConsulta = feedItems[indexPath.row]
        
        detalle.TicketPromedio = "$"+item.TicketPromedio!
        detalle.Fecha = item.Fecha!
        detalle.Sucursal = item.Sucursal!
        
        detalle.NoFolios = String(Int(item.NoFolios!))
        
        var laVenta:String = item.VentaTotal!
        detalle.VentaTotal = "$"+String(Float(laVenta)!)
        
    
        self.navigationController?.pushViewController(detalle, animated: true)
        
    }
    
    func itemConsulta(LaConsulta: [DetallesConsulta]) {
        feedItems = LaConsulta
        self.ConsutaListas.reloadData()
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
