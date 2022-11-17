//
//  HomeViewController.swift
//  Retail
//
//  Created by Rodrigo Sánchez on 14/11/22.
//

import UIKit

struct Present: Codable{
    
    let Fecha: String
    let Venta_Total: String
    let tickets: Int
    let piezas: String
    let PzaxTicket: String
    let TicketPromedio: String
    let utilidad: String
    
}

struct Past: Codable{
    
    let Fecha: String
    let Venta_Total: String
    let tickets: Int
    let piezas: String
    let PzaxTicket: String
    let TicketPromedio: String
    let utilidad: String
    
}
struct Consulta: Codable{
    let present: Present
    let past: Past
}

class HomeViewController: UIViewController {
    //2022/11/14
    let helper = Helper()
    
    var FechaStart: String = ""
    var FechaEnd: String = ""
    
    var pickerFechaStart: UIDatePicker!
    var pickerFechaEnd: UIDatePicker!
    
    //@IBOutlet weak var lblFechaSelect: UILabel!
    //@IBOutlet weak var txtFechaPasada: UILabel!
    
    @IBOutlet weak var txtFechaPresente: UITextField!
    @IBOutlet weak var txtFechaPasada: UITextField!
    
    @IBOutlet weak var SgtRangoFecha: UISegmentedControl!
    
    @IBOutlet weak var lblPresentVentaTotal: UILabel!
    @IBOutlet weak var lblPresentPiezas: UILabel!
    @IBOutlet weak var lblPresentTickets: UILabel!
    @IBOutlet weak var lblPresentPzasTicket: UILabel!
    @IBOutlet weak var lblPresentTicketProm: UILabel!
    @IBOutlet weak var lblPresentUtilidad: UILabel!
    
    @IBOutlet weak var lblPastVentaTotal: UILabel!
    @IBOutlet weak var lblPastPiezas: UILabel!
    @IBOutlet weak var lblPastTickets: UILabel!
    @IBOutlet weak var lblPastPzasTicket: UILabel!
    @IBOutlet weak var lblPastTicketProm: UILabel!
    @IBOutlet weak var lblPastUtilidad: UILabel!
    
    
    
    
    @IBOutlet weak var viewVentaTotal: UIView!
    
    @IBOutlet weak var viewNoTickets: UIView!
    @IBOutlet weak var viewTicketProm: UIView!
    @IBOutlet weak var viewPiezas: UIView!
    @IBOutlet weak var viewPiezasPorTicket: UIView!
    @IBOutlet weak var viewUtiliadad: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        SgtRangoFecha.backgroundColor = .systemGroupedBackground
        SgtRangoFecha.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        self.txtFechaPresente.text = helper.DetectaYConvierteFecha()
        self.txtFechaPasada.text = "vs. "+helper.SubstractOneYear()!
        
        pickerFechaStart = UIDatePicker()
        pickerFechaStart.datePickerMode = .date
        pickerFechaStart.maximumDate = Calendar.current.date(bySetting: .day, value: 0, of: Date())
        pickerFechaStart.maximumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        pickerFechaStart.addTarget(self, action: #selector(self.datePickerDidChange(_:)), for: .valueChanged)
        
        pickerFechaEnd = UIDatePicker()
        pickerFechaEnd.datePickerMode = .date
        pickerFechaEnd.maximumDate = Calendar.current.date(bySetting: .day, value: 0, of: Date())
        pickerFechaEnd.maximumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        pickerFechaEnd.addTarget(self, action: #selector(self.datePickerDidChange(_:)), for: .valueChanged)
        
        if #available(iOS 13.4, *) {
            
            pickerFechaStart.preferredDatePickerStyle = .wheels
            pickerFechaEnd.preferredDatePickerStyle = .wheels
            
        }else{
            
        }
        
        
        txtFechaPasada.inputView = pickerFechaEnd
        txtFechaPresente.inputView = pickerFechaStart
        
        
        ConsultaServer(fechaStart: txtFechaPresente.text! , fechaEnd: txtFechaPasada.text!)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        conf_subviews()


    }
    @objc func datePickerDidChange(_ pickerFechaStart: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        
        if txtFechaPresente.isEditing == true{
            
            txtFechaPresente.text = formatter.string(from: pickerFechaStart.date)
            let FechaPresentSelected = DateFormatter()
            FechaPresentSelected.dateFormat = "EEEE dd MMMM yyyy"
            FechaStart = FechaPresentSelected.string(from: pickerFechaStart.date)
            print(FechaStart)
        }else if txtFechaPasada.isEditing == true{
            
            txtFechaPasada.text = "vs. "+formatter.string(from: pickerFechaEnd.date)
            
            let FechaPasadaSelected = DateFormatter()
            FechaPasadaSelected.dateFormat = "EEEE dd MMMM yyyy"
            FechaEnd = FechaPasadaSelected.string(from: pickerFechaEnd.date)
            print(FechaEnd)
        }
        
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(false)
        txtFechaPresente.resignFirstResponder()
        
    }
    
    func conf_subviews(){
        
        viewVentaTotal.layer.cornerRadius = 10
        
        viewPiezas.layer.cornerRadius = 10
        viewNoTickets.layer.cornerRadius = 10
        viewPiezasPorTicket.layer.cornerRadius = 10
        viewTicketProm.layer.cornerRadius = 10
        viewUtiliadad.layer.cornerRadius = 10
        
        viewVentaTotal.layer.shadowColor = UIColor.black.cgColor
        viewVentaTotal.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        viewVentaTotal.layer.shadowOpacity = 0.2
        viewVentaTotal.layer.shadowRadius = 2.0
        
        viewNoTickets.layer.shadowColor = UIColor.black.cgColor
        viewNoTickets.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        viewNoTickets.layer.shadowOpacity = 0.2
        viewNoTickets.layer.shadowRadius = 2.0
        
        viewTicketProm.layer.shadowColor = UIColor.black.cgColor
        viewTicketProm.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        viewTicketProm.layer.shadowOpacity = 0.2
        viewTicketProm.layer.shadowRadius = 2.0
        
        viewPiezasPorTicket.layer.shadowColor = UIColor.black.cgColor
        viewPiezasPorTicket.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        viewPiezasPorTicket.layer.shadowOpacity = 0.2
        viewPiezasPorTicket.layer.shadowRadius = 2.0
        
        viewPiezas.layer.shadowColor = UIColor.black.cgColor
        viewPiezas.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        viewPiezas.layer.shadowOpacity = 0.2
        viewPiezas.layer.shadowRadius = 2.0
        
        viewUtiliadad.layer.shadowColor = UIColor.black.cgColor
        viewUtiliadad.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        viewUtiliadad.layer.shadowOpacity = 0.2
        viewUtiliadad.layer.shadowRadius = 2.0
        
    }
    
    @IBAction func ctrlButton(_ sender: Any){
        
        
        
        if SgtRangoFecha.selectedSegmentIndex == 0{
            
            txtFechaPresente.isEnabled = true
            txtFechaPasada.isEnabled = true
            
            self.txtFechaPresente.text = helper.DetectaYConvierteFecha()
            self.txtFechaPasada.text = "vs. "+helper.SubstractOneYear()!
            //ConvierteDateAString(Fecha: Date)
            
            
        }else if SgtRangoFecha.selectedSegmentIndex == 1 {
            
            txtFechaPresente.isEnabled = false
            txtFechaPasada.isEnabled = false
            
            let dateStart: Date = Date().startOfWeek!
            let dateEnd: Date = Date().endOfWeek!
            
            let pastYear: Date = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
            let pastYearDateStart: Date = pastYear.startOfWeek!
            let pastYearDateEnd: Date = pastYear.endOfWeek!
            
           // let pastYearDateStart: String = helper.SubstractSelectiveOneYear(Year: Date().startOfWeek!)!
            
            txtFechaPresente.text = helper.ConvierteDateAString(Fecha: dateStart)! + " - " + helper.ConvierteDateAString(Fecha: dateEnd)!
            txtFechaPasada.text = "vs. " + helper.ConvierteDateAString(Fecha: pastYearDateStart)! + " - " + helper.ConvierteDateAString(Fecha: pastYearDateEnd)!
            
            print("Semana seleccionado")
            
        }else if SgtRangoFecha.selectedSegmentIndex == 2 {
            
            txtFechaPresente.isEnabled = false
            txtFechaPasada.isEnabled = false
            
            let dateFormatter = DateFormatter()
            let date:Date = Date()
            dateFormatter.dateFormat = "dd-MM-yyyy"

            let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
            let startOfMonth:Date = Calendar.current.date(from: comp)!
          //  print(dateFormatter.string(from: startOfMonth))
                                    
            var comps2 = DateComponents()
            comps2.month = 1
            comps2.day = -1
            let endOfMonth:Date = Calendar.current.date(byAdding: comps2, to: startOfMonth)!
          // print(dateFormatter.string(from: endOfMonth))
            
            let pastStartMonthYear: Date = Calendar.current.date(byAdding: .year, value: -1, to: startOfMonth)!
            let pastEndMonthYear: Date = Calendar.current.date(byAdding: .year, value: -1, to: endOfMonth)!
           // var pastYearMonthStart: Date = pastMonthYear.startOfMonth!
            
            txtFechaPresente.text = helper.ConvierteDateAString(Fecha:startOfMonth)! + " - " + helper.ConvierteDateAString(Fecha:endOfMonth)!
            txtFechaPasada.text = "vs. " + helper.ConvierteDateAString(Fecha:pastStartMonthYear)! + " - " + helper.ConvierteDateAString(Fecha:pastEndMonthYear)!
            
        }else if SgtRangoFecha.selectedSegmentIndex == 3 {
            
            if txtFechaPresente.isEnabled && txtFechaPasada.isEnabled == false{
                txtFechaPresente.isEnabled = true
                txtFechaPasada.isEnabled = true
            }
        }
        
    }
    
  
    func ConsultaServer(fechaStart: String, fechaEnd: String){
        
        let url = URL(string:helper.host+"consultar")!
        let body = "{\n\n    \"dateStart\" :  \"2022/11/16\",\n    \"dateEnd\" :  \"2021/11/16\"\n\n}"
        print(body)
        var request = URLRequest(url: url)
        
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(elToken)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async { [self] in
                
                if error != nil{
                    helper.showAlert(title: "Error de servidor", message: error!.localizedDescription, in: self)
                    return
                }
                do{
                    guard let data = data else{
                        helper.showAlert(title: "Error de datos", message: error!.localizedDescription, in: self)
                        return
                    }
                    
                    let jsonQuery = try? JSONDecoder().decode(Consulta.self, from: data)
                    print(jsonQuery)
                    guard let parsedJSON = jsonQuery else{
                        print("Error de parseo")
                        return
                    }
                    
                    lblPresentVentaTotal.text = helper.currencyFormatting(total: parsedJSON.present.Venta_Total)as String?
                    lblPresentPiezas.text = helper.prettyK(Double(parsedJSON.present.piezas)!)
                    lblPresentTickets.text = String(parsedJSON.present.tickets)
                    lblPresentPzasTicket.text = parsedJSON.present.PzaxTicket as String?
                    lblPresentTicketProm.text =  "$" + parsedJSON.present.TicketPromedio as String?
                    lblPresentUtilidad.text = (parsedJSON.present.utilidad as String?)! + "%"
                    
                    lblPastVentaTotal.text = helper.currencyFormatting(total: parsedJSON.past.Venta_Total)as String?
                    lblPastPiezas.text = helper.prettyK(Double(parsedJSON.past.piezas)!)
                    lblPastTickets.text = String(parsedJSON.past.tickets)
                    lblPastPzasTicket.text = parsedJSON.past.PzaxTicket as String?
                    lblPastTicketProm.text =  "$" + parsedJSON.past.TicketPromedio as String?
                    lblPastUtilidad.text = (parsedJSON.past.utilidad as String?)! + "%"
                
                }catch{
                    
                    helper.showAlert(title: "Error", message: error.localizedDescription, in: self)
                    
                }
            }
        }.resume()
        
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
