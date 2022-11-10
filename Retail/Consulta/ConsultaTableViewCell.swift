//
//  ConsultaTableViewCell.swift
//  Retail
//
//  Created by Rodrigo Sánchez on 09/11/22.
//

import UIKit

class ConsultaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblSucursal: UILabel!
    @IBOutlet weak var lblVenta: UILabel!
    @IBOutlet weak var lblTicketProm: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
