//
//  HomeViewController.swift
//  Retail
//
//  Created by Rodrigo Sánchez on 14/11/22.
//

import UIKit

struct Present: Codable{
    
    let Fecha: Int
    let Venta_Total: String
    let tickets: Int
    let piezas: String
    let PzaxTicket: String
    let TicketPromedio: String
    let utilidad: String
    
}

struct Past: Codable{
    
    let Fecha: Int
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
    
    let helper = Helper()
    
    var FechaStart: String = ""
    var FechaEnd: String = ""
    
    
    var pickerFechaStart: UIDatePicker!
    var pickerFechaEnd: UIDatePicker!
    
   // @IBOutlet weak var lblFechaSelect: UILabel!
    //@IBOutlet weak var txtFechaPasada: UILabel!
    
    @IBOutlet weak var txtFechaPresente: UITextField!
    @IBOutlet weak var txtFechaPasada: UITextField!
    
    @IBOutlet weak var SgtRangoFecha: UISegmentedControl!
    
    @IBOutlet weak var lblVentaTotal: UILabel!
    
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
            
        }else if txtFechaPasada.isEditing == true{
            
            txtFechaPasada.text = "vs. "+formatter.string(from: pickerFechaEnd.date)
            
            let FechaPasadaSelected = DateFormatter()
            FechaPasadaSelected.dateFormat = "EEEE dd MMMM yyyy"
            FechaEnd = FechaPasadaSelected.string(from: pickerFechaEnd.date)
            
        }
        
        
   
        print(FechaStart)
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
    
    func ConsultaServer(DateStart: String, DateEnd: String){
        

            
        
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
