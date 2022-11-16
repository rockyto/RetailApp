//
//  DetallesConsulta.swift
//  Retail
//
//  Created by Rodrigo Sánchez on 09/11/22.
//

import UIKit

class DetallesConsulta: NSObject {
    
    var Fecha: String?
    var Sucursal: String?
    var Suc: String?
    var VentaTotal: String?
    var NoFolios: Int?
    var Piezas: String?
    var PzaxTicket: String?
    var TicketPromedio: String?
    
    override init(){
        
    }
    
    init(Fecha: String, Sucursal: String, Suc: String, VentaTotal: String, NoFolios: Int, Piezas: String, PzaxTicket: String, TicketPromedio: String){
        self.Fecha = Fecha
        self.Sucursal = Sucursal
        self.Suc = Suc
        self.VentaTotal = VentaTotal
        self.NoFolios = Int(NoFolios)
        self.Piezas = Piezas
        self.PzaxTicket = PzaxTicket
        self.TicketPromedio = TicketPromedio
        
    }
    override var description: String{
        
        return "Fecha: \(Fecha), Sucursal: \(Sucursal), Suc: \(Suc), VentaTotal: \(VentaTotal), NoFolios: \(NoFolios), Piezas: \(Piezas), PzaxTicket: \(PzaxTicket), TicketPromedio: \(TicketPromedio)"
        
    }
    
}
