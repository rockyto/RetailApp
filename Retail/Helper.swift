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
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        let fechaString = dateFormatter.date(from: fecha)
        
        let formatterShow = DateFormatter()
        formatterShow.dateFormat = "yyyy/MM/dd"
        let fechaFinal = formatterShow.string(from: fechaString!)
        let fechaCita = fechaFinal
        return fechaCita
    }
    
    func formatoFecha(fecha : String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT-5")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: fecha)
        return date
    }
    
    func DetectaYConvierteFecha()-> String?{
        
        let date = Date()
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        // Convert Date to String
        dateFormatter.string(from: date)
        let laFecha:String = dateFormatter.string(from: date)
        return laFecha
        
    }
    
    func ConvierteDateAString(Fecha: Date) -> String?{
        let date = Fecha
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.string(from:Fecha)
        let laFecha:String = dateFormatter.string(from: date)
        return laFecha
    }
    
    func SubstractOneYear()-> String?{
        
        /**
         let date = Date()
         let dateFormatter = DateFormatter()
         // Set Date Format
         dateFormatter.dateFormat = "yyyy"
         dateFormatter.string(from: date)
         let SubsYear: String = dateFormatter.string(from: date)
         return SubsYear
         */
        
        let date = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        dateFormatter.string(from: date!)
        let SubsYear: String = dateFormatter.string(from: date!)
        return SubsYear
       
        
    }
    
    func SubstractSelectiveOneYear(Year:Date)-> String?{
        
        let date = Calendar.current.date(byAdding: .year, value: -1, to: Year)
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.string(from: date!)
        let SubsYear: String = dateFormatter.string(from: date!)
        return SubsYear
       
    }
    
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

    
/**
 func addOrSubtractYear(year:Int)->Date{
   return Calendar.current.date(byAdding: .year, value: year, to: Date())!
 }
 */
    
    func convertDateToLocalTime(_ date: Date) -> Date {
            let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: date))
            return Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: date)!
    }
    
}


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
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}
