//
//  HomeViewController.swift
//  Retail
//
//  Created by Rodrigo Sánchez on 14/11/22.
//

import UIKit
import Charts

//MARK: Estructura para el parseo de datos en fecha presente o inicio
struct Present: Codable{
    
    let Fecha: String
    let Venta_Total: String
    let tickets: Int
    let piezas: String
    let PzaxTicket: String
    let TicketPromedio: String
    let utilidad: String
    
}

//MARK: Estructura para el parseo de datos en fecha pasadae o final
struct Past: Codable{
    
    let Fecha: String
    let Venta_Total: String
    let tickets: Int
    let piezas: String
    let PzaxTicket: String
    let TicketPromedio: String
    let utilidad: String
    
}

//MARK: Estructura para la serialización del JSON nested
struct Consulta: Codable{
    let present: Present
    let past: Past
}

class HomeViewController: UIViewController, UITextFieldDelegate, ChartViewDelegate {
    let helper = Helper()
    
    @IBOutlet weak var lblLastDownload: UILabel!
    
    @IBOutlet weak var barChartView:BarChartView!
    
    
    //MARK: Variables para la referencia de las fechas
    var dateStartString: String = ""
    var dateEndString: String = ""
    
    //MARK: Variable para la declaración del picker
    var pickerFechaStart: UIDatePicker!
    var pickerFechaEnd: UIDatePicker!
    
    //MARK: Declaración de los textfields que reciben la fecha
    @IBOutlet weak var txtFechaPresente: UITextField!
    @IBOutlet weak var txtFechaPasada: UITextField!
    
    //MARK: Declaración del segmented control
    @IBOutlet weak var SgtRangoFecha: UISegmentedControl!
    
    //MARK: Declaración de las etiquetas
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
    
    @IBOutlet weak var lblTitlePerTime: UILabel!
    
    //MARK: Declaración de subviews
    @IBOutlet weak var viewVentaTotal: UIView!
    @IBOutlet weak var viewNoTickets: UIView!
    @IBOutlet weak var viewTicketProm: UIView!
    @IBOutlet weak var viewPiezas: UIView!
    @IBOutlet weak var viewPiezasPorTicket: UIView!
    @IBOutlet weak var viewUtiliadad: UIView!
    @IBOutlet weak var viewChartBar: UIView!
    
    //MARK: Inicializador parte del ciclo de vida de la app
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFechaPresente.isEnabled = false
        txtFechaPasada.isEnabled = false
        
        
        txtFechaPresente.delegate = self
        txtFechaPasada.delegate = self
        
        SgtRangoFecha.backgroundColor = .systemGroupedBackground
        SgtRangoFecha.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        self.txtFechaPresente.text = helper.detectAndConvertDate()
        self.txtFechaPasada.text = "vs. "+helper.substractOneYear()!
        
        let toolStartBar = toolBars()
        let toolEndBar = toolBars()
        
        let doneStartButton = UIBarButtonItem(title: "ListoStart", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneStartPicker))
        toolStartBar.setItems([doneStartButton], animated: false)
        txtFechaPresente.inputAccessoryView = toolStartBar
        
        //MARK: Picker: FechaStart
        pickerFechaStart = UIDatePicker()
        pickerFechaStart.datePickerMode = .date
        pickerFechaStart.maximumDate = Calendar.current.date(bySetting: .day, value: 0, of: Date())
        pickerFechaStart.maximumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        pickerFechaStart.addTarget(self, action: #selector(self.datePickerDidChange(_:)), for: .valueChanged)
        
        //MARK: Picker: FechaEnd
        pickerFechaEnd = UIDatePicker()
        pickerFechaEnd.datePickerMode = .date
        pickerFechaEnd.maximumDate = Calendar.current.date(bySetting: .day, value: 0, of: Date())
        pickerFechaEnd.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        pickerFechaEnd.addTarget(self, action: #selector(self.datePickerDidChange(_:)), for: .valueChanged)
        
        if #available(iOS 13.4, *) {
            
            pickerFechaStart.preferredDatePickerStyle = .wheels
            pickerFechaEnd.preferredDatePickerStyle = .wheels
            
        }else{
            
        }
        
        txtFechaPresente.inputView = pickerFechaStart
        txtFechaPasada.inputView = pickerFechaEnd
        ConsultaServer(fechaStart: helper.formatDateQuery()! , fechaEnd: helper.substractFormatOneYear()!)
        
        let doneEndButton = UIBarButtonItem(title: "ListoEnd", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneEndPicker))
        toolEndBar.setItems([doneEndButton], animated: false)
        txtFechaPasada.inputAccessoryView = toolEndBar
        
        
    }
    
    private func chartValueSelected(_ chartView: ChartViewBase, entry: BarChartDataEntry, highlight: Highlight) {
        
        print("The entries: ", entry)
        
    }
    
    var yValues : [BarChartDataEntry] = [
        BarChartDataEntry(x:Double(8), y: Double(200)),
        BarChartDataEntry(x:Double(9), y: Double(50)),
        BarChartDataEntry(x:Double(10), y: Double(30)),
        BarChartDataEntry(x:Double(11), y: Double(60)),
        BarChartDataEntry(x:Double(12), y: Double(80)),
        BarChartDataEntry(x:Double(13), y: Double(140)),
        BarChartDataEntry(x:Double(14), y: Double(100)),
        BarChartDataEntry(x:Double(15), y: Double(80)),
        BarChartDataEntry(x:Double(16), y: Double(20)),
        BarChartDataEntry(x:Double(17), y: Double(70)),
        BarChartDataEntry(x:Double(18), y: Double(90)),
        BarChartDataEntry(x:Double(19), y: Double(110)),
        BarChartDataEntry(x:Double(20), y: Double(180)),
        BarChartDataEntry(x:Double(21), y: Double(20)),
        BarChartDataEntry(x:Double(22), y: Double(140)),
        BarChartDataEntry(x:Double(23), y: Double(190))
        
    ]
    
    var xValues : [BarChartDataEntry] = [
        
        BarChartDataEntry(x:Double(8), y: Double(100)),
        BarChartDataEntry(x:Double(9), y: Double(150)),
        BarChartDataEntry(x:Double(10), y: Double(130)),
        BarChartDataEntry(x:Double(11), y: Double(200)),
        BarChartDataEntry(x:Double(12), y: Double(70)),
        BarChartDataEntry(x:Double(13), y: Double(40)),
        BarChartDataEntry(x:Double(14), y: Double(150)),
        BarChartDataEntry(x:Double(15), y: Double(180)),
        BarChartDataEntry(x:Double(16), y: Double(200)),
        BarChartDataEntry(x:Double(17), y: Double(170)),
        BarChartDataEntry(x:Double(18), y: Double(60)),
        BarChartDataEntry(x:Double(19), y: Double(30)),
        BarChartDataEntry(x:Double(20), y: Double(80)),
        BarChartDataEntry(x:Double(21), y: Double(120)),
        BarChartDataEntry(x:Double(22), y: Double(40)),
        BarChartDataEntry(x:Double(23), y: Double(90))
        
    ]
    
    let Presente = UIColor(named: "BarChartsPresent")?.withAlphaComponent(0.5)
    let Pasado = UIColor(named: "BarChartsPast")
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setData()
        
    }
    
    func setData(){
        
        let set1 = BarChartDataSet(entries: yValues, label: "2022")
        let set2 = BarChartDataSet(entries: xValues, label: "2021")
        
        set1.colors =  [NSUIColor(cgColor: Presente!.cgColor)]
        set2.colors =  [NSUIColor(cgColor: Pasado!.cgColor)]
        
        let data = BarChartData(dataSets: [set2, set1])
        barChartView.data = data
        data.setDrawValues(false)
        
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.enabled = false
        //barChartView.bot
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.pinchZoomEnabled = false
        
       // barChartView.xAxis.
        
       // barChartView.isPinchZoomEnabled
        
       // barChartView.animate(xAxisDuration: 2.5)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func toolBars()->UIToolbar{
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .tintColor
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true
        return toolBar
        
    }
    
    //MARK: Llamada para notificar al controlador que la vista acaba de presentar sus subvistas configuradas
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        conf_subviews()
        
    }
    
    @objc func doneStartPicker(){
        
        print("dateStartString: ", dateStartString)
        
        //Si la fecha está vacia y se asigna el dato nos vamos al txtFechaPasada
        if dateStartString == "" {
            
            dateStartString = helper.formatDateQuery()!
            print("dateStartString desde condición: ", dateStartString)
            self.txtFechaPasada.becomeFirstResponder()
            
        }else{
            
            print("dateEndString no está vacia \n")
            
            //Condición para revisar si la variable NO dateEndString está vacia
            
            if dateEndString != "" {
                
                //Condición para revisar si ambas variables tienen el mismo dato
                
                if dateStartString != dateEndString {
                    print("/*************************/")
                    print("Las fechas no son iguales")
                    print("Fecha Start: ", dateStartString)
                    print("Fecha End: ", dateEndString)
                    print("Ejecutar acción")
                    print("/*************************/")
                    ConsultaServer(fechaStart: dateStartString, fechaEnd: dateEndString)
                    txtFechaPresente.resignFirstResponder()
                }else{
                    print("Ambas fechas son iguales")
                    self.txtFechaPasada.becomeFirstResponder()
                }
                
                //En caso de que la variable dateEndString esté vacia
            }else{
                print("dateEndString está vacia")
                self.txtFechaPasada.becomeFirstResponder()
                
            }
            
        }
        
        //txtFechaPresente.resignFirstResponder()
        //txtFechaPasada.becomeFirstResponder()
        
    }
    
    @objc func doneEndPicker(){
       
        print("dateEndString: ", dateEndString)
        
        if dateEndString == "" {
            
            dateEndString = helper.dateSubstractDayFormatQuery()!
            
            print("dateEndString desde condición: ", dateEndString)
            ConsultaServer(fechaStart: dateStartString, fechaEnd: dateEndString)
            
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.full
            
            txtFechaPasada.text = "vs. "+formatter.string(from: pickerFechaEnd.date)
            self.txtFechaPasada.resignFirstResponder()
            
        }else{
            
            print("dateEndString no está vacia /n")
            
            //Condición para revisar si la variable dateEndString NO está vacia
            if dateStartString != "" {
                
                //Condición para revisar si ambas variables tienen el mismo dato
                if dateStartString != dateEndString {
                    print("/*************************/")
                    print("Las fechas no son iguales")
                    print("Fecha Start: ", dateStartString)
                    print("Fecha End: ", dateEndString)
                    print("Ejecutar acción")
                    print("/*************************/")
                    ConsultaServer(fechaStart: dateStartString, fechaEnd: dateEndString)
                    txtFechaPasada.resignFirstResponder()
                }else{
                    print("Ambas fechas son iguales")
                    //self.txtFechaPasada.becomeFirstResponder()
                }
                
                //En caso de que la variable dateEndString esté vacia
            }else{
                
                print("dateEndString está vacia")
                
            }
            
        }
    }
    
    //MARK: Función disponible en ObjectiveC que detecta cambio de valores en un picker
    @objc func datePickerDidChange(_ pickerFechaStart: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        
        if txtFechaPresente.isEditing == true{
            
            txtFechaPresente.text = formatter.string(from: pickerFechaStart.date)
            let FechaPresentSelected = DateFormatter()
            FechaPresentSelected.dateFormat = "yyyy-MM-dd"
            dateStartString = FechaPresentSelected.string(from: pickerFechaStart.date)
            
            print(dateStartString)
            
        }else if txtFechaPasada.isEditing == true{
            
            txtFechaPasada.text = "vs. "+formatter.string(from: pickerFechaEnd.date)
            let FechaPasadaSelected = DateFormatter()
            FechaPasadaSelected.dateFormat = "yyyy-MM-dd"
            dateEndString = FechaPasadaSelected.string(from: pickerFechaEnd.date)
            print(dateEndString)
            
        }
        
    }
    
    //MARK: Indica a este objeto que se produjeron uno o más toques nuevos en una vista o ventana
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        if dateStartString == dateEndString{
            
        }else{
            
            // ConsultaServer(fechaStart: dateStartString , fechaEnd: dateEndString)
            
        }
        
        self.view.endEditing(false)
        txtFechaPresente.resignFirstResponder()
        
    }
    
    //MARK: Función para la configuración de las subvistas
    func conf_subviews(){
        
        viewVentaTotal.layer.cornerRadius = 10
        
        viewPiezas.layer.cornerRadius = 10
        viewNoTickets.layer.cornerRadius = 10
        viewPiezasPorTicket.layer.cornerRadius = 10
        viewTicketProm.layer.cornerRadius = 10
        viewUtiliadad.layer.cornerRadius = 10
        viewChartBar.layer.cornerRadius = 10
        
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
        
        viewChartBar.layer.shadowColor = UIColor.black.cgColor
        viewChartBar.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        viewChartBar.layer.shadowOpacity = 0.2
        viewChartBar.layer.shadowRadius = 2.0
        
    }
    
    //MARK: Control para ejecutar el calculo de fechas según su segmentación
    @IBAction func ctrlButton(_ sender: Any){
        
        //MARK: Switch to select segmented button
        switch SgtRangoFecha.selectedSegmentIndex {
            
        case 0:
            
            txtFechaPresente.isEnabled = false
            txtFechaPasada.isEnabled = false
            ConsultaServer(fechaStart: helper.formatDateQuery()! , fechaEnd: helper.substractFormatOneYear()!)
            self.txtFechaPresente.text = helper.detectAndConvertDate()
            self.txtFechaPasada.text = "vs. "+helper.substractOneYear()!
            self.lblTitlePerTime.text = "Ventas por hora"
            break
        case 1:
            txtFechaPresente.isEnabled = false
            txtFechaPasada.isEnabled = false
            
            let dateStart: Date = Date().startOfWeek!
            let dateEnd: Date = Date().endOfWeek!
            
            let pastYear: Date = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
            let pastYearDateStart: Date = pastYear.startOfWeek!
            let pastYearDateEnd: Date = pastYear.endOfWeek!
            
            txtFechaPresente.text = helper.convertDateToString(Fecha: dateStart)! + " - " + helper.convertDateToString(Fecha: dateEnd)!
            txtFechaPasada.text = "vs. " + helper.convertDateToString(Fecha: pastYearDateStart)! + " - " + helper.convertDateToString(Fecha: pastYearDateEnd)!
            self.lblTitlePerTime.text = "Ventas por día"
            break
        case 2:
            txtFechaPresente.isEnabled = false
            txtFechaPasada.isEnabled = false
            
            let dateFormatter = DateFormatter()
            let date:Date = Date()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
            let startOfMonth:Date = Calendar.current.date(from: comp)!
            
            
            var comps2 = DateComponents()
            comps2.month = 1
            comps2.day = -1
            let endOfMonth:Date = Calendar.current.date(byAdding: comps2, to: startOfMonth)!
            
            
            let pastStartMonthYear: Date = Calendar.current.date(byAdding: .year, value: -1, to: startOfMonth)!
            let pastEndMonthYear: Date = Calendar.current.date(byAdding: .year, value: -1, to: endOfMonth)!
            
            txtFechaPresente.text = helper.convertDateToString(Fecha:startOfMonth)! + " - " + helper.convertDateToString(Fecha:endOfMonth)!
            txtFechaPasada.text = "vs. " + helper.convertDateToString(Fecha:pastStartMonthYear)! + " - " + helper.convertDateToString(Fecha:pastEndMonthYear)!
            self.lblTitlePerTime.text = "Ventas por mes"
            break
            
        case 3:
            txtFechaPresente.isEnabled = true
            txtFechaPasada.isEnabled = true
            
            txtFechaPresente.becomeFirstResponder()
            self.txtFechaPresente.text = helper.detectAndConvertDate()
            self.txtFechaPasada.text = "vs. "+helper.substractOneYear()!
            
            if txtFechaPresente.isEnabled && txtFechaPasada.isEnabled == false{
                txtFechaPresente.isEnabled = true
                txtFechaPasada.isEnabled = true
            }
            break
            
        default:
            setData()
            txtFechaPresente.isEnabled = false
            txtFechaPasada.isEnabled = false
            ConsultaServer(fechaStart: "2022/11/16" , fechaEnd: "2021/11/16")
            self.txtFechaPresente.text = helper.detectAndConvertDate()
            self.txtFechaPasada.text = "vs. "+helper.substractOneYear()!
            self.lblTitlePerTime.text = "Ventas por hora"
            break
        }
        
        
    }
    
    //MARK: Hace la comunicación con el servidor para el envío de los parametros y descarga de los datos
    func ConsultaServer(fechaStart: String, fechaEnd: String){
 
     
        lblPresentVentaTotal.text = "- -"
        lblPresentPiezas.text = "- -"
        lblPresentTickets.text = "- -"
        lblPresentPzasTicket.text = "- -"
        lblPresentTicketProm.text = "- -"
        lblPresentUtilidad.text = "- -"
        
        lblPastVentaTotal.text = "- -"
        lblPastPiezas.text = "- -"
        lblPastTickets.text = "- -"
        lblPastPzasTicket.text = "- -"
        lblPastTicketProm.text = "- -"
        lblPastUtilidad.text = "- -"
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = URL(string:helper.host+"consultar")!
        let body = helper.bodyDates(dateStart: fechaStart, dateEnd:fechaEnd)
        
        print(body)
        var request = URLRequest(url: url)
        
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(elToken)", forHTTPHeaderField: "Authorization")
        
        spinningActivity?.labelText = "Descargando"
        spinningActivity?.detailsLabelText = "un momento por favor"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async { [self] in
                
                if error != nil{
                    spinningActivity?.hide(true)
                    helper.UIShowAlert(title: "Error de servidor", message: error!.localizedDescription, in: self)
                    return
                }
                do{
                    guard let data = data else{
                        spinningActivity?.hide(true)
                        helper.UIShowAlert(title: "Error de datos", message: error!.localizedDescription, in: self)
                        return
                    }
                    
                    let jsonQuery = try? JSONDecoder().decode(Consulta.self, from: data)
                    print(jsonQuery)
                    guard let parsedJSON = jsonQuery else{
                        spinningActivity?.hide(true)
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
                    
                    setData()
                    
                    
                    lblLastDownload.text = "Última actualización  "+helper.detectFullDate()!
                    
                    
                    spinningActivity?.hide(true)
                    
                }catch{
                    
                    spinningActivity?.hide(true)
                    helper.UIShowAlert(title: "Error", message: error.localizedDescription, in: self)
                    
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
