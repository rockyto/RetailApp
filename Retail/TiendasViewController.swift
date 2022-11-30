//
//  TiendasViewController.swift
//  Retail
//
//  Created by Rodrigo Sánchez on 23/11/22.
//

import UIKit

class TiendasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ConsultaModeloProtocol{
    
    var dateStartString: String = ""
    var dateEndString: String = ""
    
    var dateStart = DateFormatter()
    var dateEnd = DateFormatter()
    
    //MARK: Variable para la declaración del picker
    var pickerFechaStart: UIDatePicker!
    var pickerFechaEnd: UIDatePicker!
    
    @IBOutlet weak var txtFechaPresente: UITextField!
    @IBOutlet weak var txtFechaPasada: UITextField!
    
    @IBOutlet weak var SgtRangoFecha: UISegmentedControl!
    
    @IBOutlet var tableStores: UITableView!
    
    var feedItems = [DetallesConsulta]()
    
    var selectDato : DetallesConsulta = DetallesConsulta()
    
    //var arregloDatos : DetallesConsulta = feedItems
    
    lazy var spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateDay = helper.formatDateQuery()!
        
        txtFechaPresente.isEnabled = false
        txtFechaPasada.isEnabled = false
        
        SgtRangoFecha.backgroundColor = .systemGroupedBackground
        SgtRangoFecha.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        self.txtFechaPresente.text = helper.detectAndConvertDate()
        self.txtFechaPasada.text = "vs. "+helper.substractOneYear()!
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .tintColor
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Listo", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.okPicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
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
        pickerFechaEnd.maximumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        pickerFechaEnd.addTarget(self, action: #selector(self.datePickerDidChange(_:)), for: .valueChanged)
        
        
        if #available(iOS 13.4, *) {
            
            pickerFechaStart.preferredDatePickerStyle = .wheels
            pickerFechaEnd.preferredDatePickerStyle = .wheels
            
        }else{
            
        }
        txtFechaPasada.inputView = pickerFechaEnd
        txtFechaPresente.inputView = pickerFechaStart
        txtFechaPresente.inputAccessoryView = toolBar
        
        self.tableStores.reloadData()
        self.tableStores.delegate = self
        self.tableStores.dataSource = self
        
        let consultaModelo = ConsultaModelo()
        consultaModelo.ElDelegado = self
        consultaModelo.downloadConsulta()
        
        spinningActivity?.labelText = "Descargando"
        spinningActivity?.detailsLabelText = "un momento por favor"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        /*
         self.tableStores.reloadData()
         self.tableStores.delegate = self
         self.tableStores.dataSource = self
         
         let consultaModelo = ConsultaModelo()
         consultaModelo.ElDelegado = self
         consultaModelo.downloadConsulta()
         */
    }
    
    @objc func okPicker(){
        
        txtFechaPresente.resignFirstResponder()
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        spinningActivity?.labelText = "Descargando"
        spinningActivity?.detailsLabelText = "un momento por favor"
        
        self.tableStores.reloadData()
        self.tableStores.delegate = self
        self.tableStores.dataSource = self
        
        let consultaModelo = ConsultaModelo()
        consultaModelo.ElDelegado = self
        consultaModelo.downloadConsulta()
        spinningActivity?.hide(true)
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
            dateDay = dateStartString
        
    
            
        }else if txtFechaPasada.isEditing == true{
            
            txtFechaPasada.text = "vs. "+formatter.string(from: pickerFechaEnd.date)
            
            let FechaPasadaSelected = DateFormatter()
            FechaPasadaSelected.dateFormat = "yyyy-MM-dd"
            //dateEnd.dateFormat = "yyyy-MM-dd"
            
            dateEndString = FechaPasadaSelected.string(from: pickerFechaEnd.date)
            
            print(dateEndString)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaDetalles", for: indexPath) as! ConsultaTableViewCell
        let item : DetallesConsulta = feedItems[indexPath.row]
        
        print("Los items: ", item)
        cell.lblVenta!.text = item.VentaTotal
        cell.lblSucursal!.text = item.Sucursal
        cell.lblTicketProm!.text = item.TicketPromedio
        spinningActivity?.hide(true)
        return cell
        
    }
    
    func itemConsulta(LaConsulta: [DetallesConsulta]) {
        feedItems = LaConsulta
        self.tableStores.reloadData()
    }
    
    //MARK: Indica a este objeto que se produjeron uno o más toques nuevos en una vista o ventana
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        
       
        if dateStartString != dateEndString{
            // ConsultaServer(fechaStart: "2022/11/16" , fechaEnd: "2021/11/16")
        }else{
            
        }
        self.view.endEditing(false)
        txtFechaPresente.resignFirstResponder()
        
    }
    
    
    @IBAction func ctrlButton(_ sender: Any){
        
        switch SgtRangoFecha.selectedSegmentIndex{
        case 0:
            txtFechaPresente.isEnabled = false
            txtFechaPasada.isEnabled = false
            
            self.txtFechaPresente.text = helper.detectAndConvertDate()
            self.txtFechaPasada.text = "vs. "+helper.substractOneYear()!
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
            txtFechaPresente.isEnabled = false
            txtFechaPasada.isEnabled = false
            self.txtFechaPresente.text = helper.detectAndConvertDate()
            self.txtFechaPasada.text = "vs. "+helper.substractOneYear()!
            break
        }
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
