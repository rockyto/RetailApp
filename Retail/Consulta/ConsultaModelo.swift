//
//  ConsultaModelo.swift
//  Retail
//
//  Created by Rodrigo Sánchez on 09/11/22.
//

import UIKit
import Foundation


protocol ConsultaModeloProtocol: AnyObject {
    
    func itemConsulta (LaConsulta: [DetallesConsulta])
    
}

var dateDay: String = ""


let elToken : String = UserDefaults.standard.string(forKey: "token")!
let helper = Helper()

class ConsultaModelo: NSObject {
    
    weak var ElDelegado : ConsultaModeloProtocol!
    
    let url = URL(string: helper.host+"tiendas")!
    let body = helper.bodyDateDay(dateDay: dateDay)
    
    func downloadConsulta(){
        
        print("El body de la fecha:", body)
        
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(elToken)", forHTTPHeaderField: "Authorization")
        
        let SessionDefault = Foundation.URLSession(configuration: URLSessionConfiguration.ephemeral)
        URLCache.shared.removeAllCachedResponses()
        
        let task = SessionDefault.dataTask(with: request){
            (data, response, error)in
            if error != nil {
                print("Error al descargar la consulta")
            }else{
                print("Datos descargados")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data){
        
        var resultFromServer: Any?
        resultFromServer = try? JSONSerialization.jsonObject(with: data, options: [])
        if let respdict = resultFromServer as? [String: Any]{
            
            var jsonDi = NSDictionary()
            
            do{
                jsonDi = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                
                let parsedJSON = jsonDi
                
                print("ParsedJSON: ", parsedJSON)
            }catch{
                
            }
        }else if let respArr = resultFromServer as? [Any]{
            
            var jsonResult  = NSArray()
            do{
                jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            }catch let error as NSError {
                
                print(error)
                
            }
            
            var jsonElement = NSDictionary()
            print(jsonElement)
            
            let detalles = NSMutableArray()
            
            for i in 0 ..< jsonResult.count{
                jsonElement = jsonResult[i] as! NSDictionary
                
                let detalle = DetallesConsulta()
                
                let Fecha = jsonElement["Fecha"]
                let Sucursal = jsonElement["Sucursal"]
                let Suc = jsonElement["Suc"]
                let VentaTotal = jsonElement["Venta_Total"]
                let NoFolios = jsonElement["N_Folios"]
                let Piezas = jsonElement["Piezas"]
                let PzaxTicket = jsonElement["PzaxTicket"]
                let TicketPromedio = jsonElement["TicketProm"]
                
                let fechaJSON = helper.convertStringToDateString(laFecha: Fecha as! String)
                
                detalle.Fecha = fechaJSON
                detalle.Sucursal = Sucursal as? String
                detalle.Suc = Suc as? String
                //helper.currencyFormatting(total: VentaTotal as? String)as String?
                detalle.VentaTotal = helper.currencyFormatting(total: (VentaTotal as? String)!)as String?
                detalle.NoFolios = NoFolios as? Int
                detalle.Piezas = Piezas as? String
                detalle.PzaxTicket = PzaxTicket as? String
                detalle.TicketPromedio = TicketPromedio as? String
                
                detalles.add(detalle)
                
            }
            DispatchQueue.main.async(execute: { ()-> Void in
                
                self.ElDelegado.itemConsulta(LaConsulta: detalles as! [DetallesConsulta])
            })
            
        }
        
        else if let stringRespt = String(data: data, encoding: .utf8){
            
        }
    }
    
    
}
