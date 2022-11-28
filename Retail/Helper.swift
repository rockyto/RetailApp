//
//  Helper.swift
//  Retail
//
//  Created by Rodrigo Sánchez on 08/11/22.
//

import Foundation
import UIKit

//MARK: Clase para alojar funciones auxiliares.
class Helper{
    
    //MARK: Constante para la definición del host para despues hacer el cambio para el despligue a production.
    let host: String = "http://retail.test/api/"
    
    func bodyDateDay(dateDay: String) -> String{
        var body: String = ""
        
        struct theDateDay: Codable{
            var dateDay: String
        }
        
        let date = theDateDay(dateDay: dateDay)
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do{
            let encodeDate = try jsonEncoder.encode(date)
            let encodeStringDate = String(data: encodeDate, encoding: .utf8)!
            body = encodeStringDate
        }catch{
            print(error.localizedDescription)
        }
        return body
    }
    
    //MARK: Consutrcción del body que el backend requiere
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
    
    //MARK: Construcción del body para las fechas
    func bodyDates(dateStart: String, dateEnd:String) -> String{
        
        let dateStartString: String = dateStart
        let dateEndString: String = dateEnd
        var body: String = ""
        struct paramsDates: Codable{
            
            var dateStart: String
            var dateEnd: String
            
        }
        
        let query = paramsDates(dateStart: dateStartString, dateEnd: dateEndString)
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do{
            let encodeQuery = try jsonEncoder.encode(query)
            let encodeStringQuery = String(data: encodeQuery, encoding: .utf8)!
            body = encodeStringQuery
        }catch{
            print(error.localizedDescription)
        }
        return body
    }
    
    //MARK: Crea una alerta como componente
    func UIShowAlert(title: String, message: String, in vc: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Para la apertura de una vista
    func instantiateViewController(identifier: String, animated: Bool, by vc: UIViewController, completion: (() -> Void)?){
        let nuevoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        nuevoViewController.modalPresentationStyle = .custom
        vc.present(nuevoViewController, animated: animated, completion: completion)
    }
    
    //MARK: Conversión de formatos de fecha
    func convierteStringEnFechaString(laFecha: String) -> String{
        
        let fecha = laFecha
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fechaString = dateFormatter.date(from: fecha)
        let formatterShow = DateFormatter()
        formatterShow.dateFormat = "yyyy-MM-dd"
        let fechaFinal = formatterShow.string(from: fechaString!)
        let fechaCita = fechaFinal
        return fechaCita
        
    }
    
    func fechaFormatoQuery()-> String?{
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.string(from: date)
        let laFecha:String = dateFormatter.string(from: date)
        return laFecha
        
    }
    
    func dateSubstractDayFormatQuery()-> String?{
        
        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.string(from: date!)
        let laFecha:String = dateFormatter.string(from: date!)
        return laFecha
        
    }
    
    //MARK: Establece el formato de una fecha
    func formatoFecha(fecha : String) -> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT-5")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: fecha)
        return date
        
    }
    
    //MARK: Detecta la fecha y establece el formato
    func DetectaYConvierteFecha()-> String?{
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        dateFormatter.string(from: date)
        let laFecha:String = dateFormatter.string(from: date)
        return laFecha
        
    }
    
    //MARK: Conversor de fecha
    func ConvierteDateAString(Fecha: Date) -> String?{
        let date = Fecha
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.string(from:Fecha)
        let laFecha:String = dateFormatter.string(from: date)
        return laFecha
    }
    
    //MARK: Resta un año a la fecha
    func SubstractOneYear()-> String?{
        
        let date = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        dateFormatter.string(from: date!)
        let SubsYear: String = dateFormatter.string(from: date!)
        return SubsYear
        
    }
    
    //MARK: Resta un año a la fecha
    func SubstractFormatOneYear()-> String?{
        
        let date = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.string(from: date!)
        let SubsYear: String = dateFormatter.string(from: date!)
        return SubsYear
        
    }
    
    //MARK: Resta una año a una fecha selectiva
    func SubstractSelectiveOneYear(Year:Date)-> String?{
        
        let date = Calendar.current.date(byAdding: .year, value: -1, to: Year)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.string(from: date!)
        let SubsYear: String = dateFormatter.string(from: date!)
        return SubsYear
       
    }
    
    //MARK: Formateador de cantidades
    func prettyK(_ pzas: Double) -> String{
        
        let n:Int = Int(pzas)
        
        let num = abs(Double(n))
        let sign = (n < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)M"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)K"

        case 0...:
            return "\(n)"

        default:
            return "\(sign)\(n)"
        }
    }
    
    //MARK: Conversor a moneda
    func currencyFormatting(total: String) -> String {
          if let value = Double(total) {
              let formatter = NumberFormatter()
              formatter.numberStyle = .currency
              formatter.maximumFractionDigits = 2
              formatter.minimumFractionDigits = 2
              if let str = formatter.string(for: value) {
                  return str
              }
          }
          return ""
      }
    
    func convertDateToLocalTime(_ date: Date) -> Date {
            let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: date))
            return Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: date)!
    }
    
}

//MARK: Extensión para el calculo de fechas
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let startDay = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: startDay)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let startDay = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: startDay)
       }
    
    func getMonthStart(of component: Calendar.Component, calendar: Calendar = Calendar.current) -> Date? {
          return calendar.dateInterval(of: component, for: self)?.start
      }

      func getMonthEnd(of component: Calendar.Component, calendar: Calendar = Calendar.current) -> Date? {
          return calendar.dateInterval(of: component, for: self)?.end
      }
    
}

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self
        let truncated = Double(Int(newDecimal))
        let originalDecimal = truncated / multiplier
        return originalDecimal
    }
}
